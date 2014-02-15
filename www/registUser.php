<?php
$token = $_GET['token'];
$gkey = $_GET['googlekey'];
$token = "";
//$res = request("https://graph.facebook.com/me?access_token=".$token);
updateUserDB($token,"");
//リクエストを投げてレスポンスを返す。
function request($url){

	$ch = curl_init();

	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_HEADER, 0);
	curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);

	$ret = curl_exec($ch);

	curl_close($ch);
	return $ret;
}

//FBからユーザーデータを取得してuserdbを更新
function updateUserDB($token,$gkey){
	try{
		$dbh = new PDO('mysql:host=localhost;dbname=taituri', 'root', '');
	} catch (PDOException $e) {
		echo "failed pdo";
	}
	$url = "https://graph.facebook.com/me?access_token=".$token;
	$json = request($url);
	$data = json_decode($json);
	$userid = $data->id;
	$sex = $data->gender=="male"?0:1;
	$birthday = "";

	$url = "https://graph.facebook.com/me/feed?with=location&access_token=".$token;
	$json = request($url);
	$data = json_decode($json);
	var_dump($data);
	$work = array();
	foreach($data->data as $v){
		$place_id=$v->place->id;
		$place_name=preg_replace("/'/","//",$v->place->name);
		$sql = "INSERT INTO pois (poiid,name) VALUES ('$place_id','$place_name')";
		array_push($work,$place_id);

		$st = $pdo->prepare("INSERT INTO pois (poiid,name) VALUES (:id,:name)");
		$st->bindParam(':name',$place_name);
		$st->bindParam(':id',$place_id);
		$st->execute();
	}
	$pois = implode(",",$work);


	$url = "https://graph.facebook.com/me/movies?access_token=".$token;
	$json = request($url);
	$data = json_decode($json);
	var_dump($data);
	$work = array();
	foreach($data->data as $v){
		array_push($work,$v->id);
	}
	$movies = implode(",",$work);

	$url = "https://graph.facebook.com/me/music?access_token=".$token;
	$json = request($url);
	$data = json_decode($json);
	$work = array();
	foreach($data->data as $v){
		array_push($work,$v->id);
	}
	$musics = implode(",",$work);

	$url = "https://graph.facebook.com/me/books?access_token=".$token;
	$json = request($url);
	$data = json_decode($json);
	$work = array();
	foreach($data->data as $v){
		array_push($work,$v->id);
	}
	$books = implode(",",$work);
	$st = $pdo->prepare("INSERT INTO users (userid,googlekey,accesstoken,sex,birthday,books,movies,pois,musics) VALUES (':id',':gkey',':token',:sex,':birthday','books',':movies',':pois',':musics')");
		$st->bindParam(':id',$userid);
		$st->bindParam(':gkey',$gkey);
		$st->bindParam(':token',$token);
		$st->bindParam(':sex',$sex);
		$st->bindParam(':birthday',$birthday);
		$st->bindParam(':books',$books);
		$st->bindParam(':movies',$movies);
		$st->bindParam(':pois',$pois);
		$st->bindParam(':musics',$musics);
		$st->execute();
	return $pois;
}
?>

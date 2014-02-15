<?php
$token = $_GET['token'];
$gkey = $_GET['googlekey'];
$aid = $_GET['android_id'];
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
		$dbh = new PDO('mysql:host=localhost;dbname=turitai', 'pixy', 'pass');
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
	$ramen = 0;
	$museum = 0;
	foreach($data->data as $v){
		$place_name=preg_replace("/'/","//",$v->place->name);
		$place_id=$v->place->id;
		$sql = "SELECT * from pois where poiid='$place_id'";
		$st = $pdo->query($sql);
		$st->execute();
		$cnt=0;
		while ($row = $st->fetch()) {
			$cnt++;
		}
		if($cnt==0){
			$place_name=preg_replace("/'/","//",$v->place->name);
			$sql = "INSERT INTO pois (poiid,name) VALUES ('$place_id','$place_name')";
			array_push($work,$place_id);

			$st = $pdo->prepare("INSERT INTO pois (poiid,name) VALUES (:id,:name)");
			$st->bindParam(':name',$place_name);
			$st->bindParam(':id',$place_id);
			$st->execute();
		}
		$pois = implode(",",$work);
		$sql = "SELECT * from userspots where userid='$userid' and poiid='$place_id' ";
		$st = $pdo->query($sql);
		$st->execute();
		$cnt=0;
		while ($row = $st->fetch()) {
			$cnt++;
		}
		if($cnt==0){
			$place_name=preg_replace("/'/","//",$v->place->name);
			$sql = "INSERT INTO userspots (poiid,name) VALUES ('$place_id','$place_name')";
			array_push($work,$place_id);

			$st = $pdo->prepare("INSERT INTO userspots (userid,poiid) VALUES (:uid,:pid)");
			$st->bindParam(':uid',$user_id);
			$st->bindParam(':pid',$place_id);
			$st->execute();

		}


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
		$sql = "SELECT * from users where android_id='$aid'";
		$st = $pdo->query($sql);
		$st->execute();
		$cnt=0;
		while ($row = $st->fetch()) {
			$cnt++;
		}
		if($cnt==0){
			$st = $pdo->prepare("INSERT INTO users (userid,googlekey,accesstoken,sex,birthday,books,movies,pois,musics,ramen,museum) VALUES (:id,:gkey,:token,:sex,:birthday,:books,:movies,:pois,:musics,:ramen,:museum')");
			$st->bindParam(':id',$userid);
			$st->bindParam(':gkey',$gkey);
			$st->bindParam(':aid',$aid);
			$st->bindParam(':token',$token);
			$st->bindParam(':sex',$sex);
			$st->bindParam(':birthday',$birthday);
			$st->bindParam(':books',$books);
			$st->bindParam(':movies',$movies);
			$st->bindParam(':pois',$pois);
			$st->bindParam(':musics',$musics);
			$st->bindParam(':ramen',$ramen);
			$st->bindParam(':museum',$museum);
			$st->execute();
		}
	}
	return true;
}
?>

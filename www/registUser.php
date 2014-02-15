<?php
$token = $_GET['token'];
$gkey = $_GET['googlekey'];
$token = "";
//$res = request("https://graph.facebook.com/me?access_token=".$token);
updateUserDB($token);
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
                array_push($work,$v->id);
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
	$sql = "INSERT INTO users (userid,googlekey,accesstoken,sex,birthday,books,movies,pois,musics,) VALUES ('$userid','$gkey','$token',$sex,'$birthday','$books','$movies','$pois','$musics')";
	return $pois;
}
?>

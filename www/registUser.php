<?php
$token = $_GET['token'];
$gkey = $_GET['googlekey'];
$token = "";
$res = request("https://graph.facebook.com/me?access_token=".$token);
//リクエストを投げてレスポンスを返す。
function request($url){

        $ch = curl_init();

        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_HEADER, 0);

        $ret = curl_exec($ch);

        curl_close($ch);
        return $ret;
}

//FBからユーザーデータを取得してuserdbを更新
function updateUserDB($token,$gkey){
	$url = "/me/feed?with=location?access_token=".$token;
	$json = request($url);
	$url = "https://graph.facebook.com/me/likes?access_token=".$token;
	$json = request($url);
	$url = "https://graph.facebook.com/me/movies?access_token=".$token;
	$json = request($url);
	$url = "https://graph.facebook.com/me/music?access_token=".$token;
	$json = request($url);
	$url = "https://graph.facebook.com/me/books?access_token=".$token;
	$json = request($url);
//$sql = "REPLACE INTO users () VALUES ()";

}
?>

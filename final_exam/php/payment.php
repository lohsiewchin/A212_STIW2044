<?php

$email = $_GET['email'];
$mobile = $_GET['mobile']; 
$name = $_GET['name']; 
$amount = $_GET['amount']; 


$api_key = '4a24bc62-d490-4160-a85b-ac340575d0a4';
$collection_id = '5jnbrhj8';
 
$host = 'https://www.billplz-sandbox.com/api/v3/bills';


$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'mobile' => $mobile,
          'name' => $name,
          'amount' => ($amount + 1) * 100, // RM20
		  'description' => 'Payment for order by '.$name,
          'callback_url' => "https://moneymoney12345.com/278723/MYTutor/users/php/return_url",
          'redirect_url' => "https://moneymoney12345.com/278723/MYTutor/users/php/payment_update.php?email=$email&mobile=$mobile&amount=$amount&name=$name" 
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);
header("Location: {$bill['url']}");
?>
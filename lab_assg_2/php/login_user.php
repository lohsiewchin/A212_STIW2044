<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM `tbl_users` WHERE email = '$email' AND user_password = '$password'";
$result = $conn->query($sqllogin);
$numrow = $result->num_rows;

if ($numrow > 0) {
    while ($row = $result->fetch_assoc()) {
        $userlist['email'] = $row['email'];
        $userlist['password'] = $row['user_password'];
        $userlist['name'] = $row['full_name'];
        $userlist['phone'] = $row['phone_no'];
        $userlist['address'] = $row['home_add'];
        
    }
    $response = array('status' => 'success', 'data' => $userlist);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
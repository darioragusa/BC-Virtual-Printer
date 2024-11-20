<?php
// http://10.0.16.42:8081/VirtualPrinter/
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
	header("HTTP/1.0 405 Method Not Allowed");
	exit();
}

$content = file_get_contents('php://input');
$now = DateTime::createFromFormat('U.u', microtime(true));
$file = 'C:\\Users\\Administrator\\Documents\\VirtualPrinter\\' . $now->format('Y-m-d-H-i-s-u') . '.pdf';
file_put_contents($file, $content, LOCK_EX);
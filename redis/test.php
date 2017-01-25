<?php

$redis = new Redis();
$redis->connect('127.0.0.1', 6379);
// $client = new PredisClient([
//     'scheme' => 'tcp',
//     'host'   => '127.0.0.1',
//     'port'   => 6379,
// ]);
// echo "Results" . $client->get("Key1");
echo "HI THERE!" . $redis->get('Key2');
?>
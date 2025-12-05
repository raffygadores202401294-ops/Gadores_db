<?php
include('database.php');
$sql = "SELECT orders.id, customers.name AS customer_name, COUNT(order_items.id) AS total_items FROM orders 
        JOIN customers ON orders.customer_id = customers.id 
        LEFT JOIN order_items ON orders.id = order_items.order_id 
        GROUP BY orders.id";
$result = mysqli_query($conn, $sql);

echo "<table>";
echo "<tr><th>Order ID</th><";

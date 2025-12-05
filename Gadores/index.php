<?php
include('database.php');
$sql = "SELECT products.id, products.name AS product_name, products.price, categories.name AS category_name FROM products 
        JOIN categories ON products.category_id = categories.id";
$result = mysqli_query($conn, $sql);

echo "<table>";
echo "<tr><th>Product Name</th><th>Category</th><th>Price</th></tr>";

while ($row = mysqli_fetch_assoc($result)) {
    echo "<tr>";
    echo "<td>" . $row['product_name'] . "</td>";
    echo "<td>" . $row['category_name'] . "</td>";
    echo "<td>" . $row['price'] . "</td>";
    echo "</tr>";
}
echo "</table>";
?>
<?php
$product_id = $_GET['id'];
include('database.php');

// Delete the product from the database
$sql = "DELETE FROM products WHERE id = $product_id";
if (mysqli_query($conn, $sql)) {
    echo "Product deleted successfully!";
} else {
    echo "Error: " . mysqli_error($conn);
}
?>

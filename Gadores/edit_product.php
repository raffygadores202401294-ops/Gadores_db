<?php
// Get product data to prefill the form
$product_id = $_GET['id'];
include('database.php');
$sql = "SELECT * FROM products WHERE id = $product_id";
$result = mysqli_query($conn, $sql);
$product = mysqli_fetch_assoc($result);

// Fetch categories for the dropdown
$categories_result = mysqli_query($conn, "SELECT * FROM categories");

?>

<form action="edit_product.php?id=<?php echo $product_id; ?>" method="POST">
    <label for="product_name">Product Name:</label>
    <input type="text" name="product_name" value="<?php echo $product['name']; ?>" required>
    
    <label for="price">Price:</label>
    <input type="number" name="price" value="<?php echo $product['price']; ?>" required>
    
    <label for="category_id">Category:</label>
    <select name="category_id">
        <?php
        while ($row = mysqli_fetch_assoc($categories_result)) {
            $selected = ($product['category_id'] == $row['id']) ? "selected" : "";
            echo "<option value='{$row['id']}' {$selected}>{$row['name']}</option>";
        }
        ?>
    </select>
    
    <button type="submit">Update Product</button>
</form>

<?php
// Update product in the database
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $product_name = $_POST['product_name'];
    $price = $_POST['price'];
    $category_id = $_POST['category_id'];
    
    $update_sql = "UPDATE products SET name = '$product_name', price = '$price', category_id = '$category_id' WHERE id = $product_id";
    if (mysqli_query($conn, $update_sql)) {
        echo "Product updated successfully!";
    } else {
        echo "Error: " . mysqli_error($conn);
    }
}
?>
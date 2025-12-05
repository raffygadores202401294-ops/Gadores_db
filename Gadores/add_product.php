<form action="add_product.php" method="POST">
    <label for="product_name">Product Name:</label>
    <input type="text" name="product_name" required>
    
    <label for="price">Price:</label>
    <input type="number" name="price" required>
    
    <label for="category_id">Category:</label>
    <select name="category_id">
        <?php
        include('database.php');
        $result = mysqli_query($conn, "SELECT * FROM categories");
        while ($row = mysqli_fetch_assoc($result)) {
            echo "<option value='{$row['id']}'>{$row['name']}</option>";
        }
        ?>
    </select>
    
    <button type="submit">Add Product</button>
</form>

<?php
// Add product to the database
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    include('database.php');
    $product_name = $_POST['product_name'];
    $price = $_POST['price'];
    $category_id = $_POST['category_id'];
    
    $sql = "INSERT INTO products (name, price, category_id) VALUES ('$product_name', '$price', '$category_id')";
    if (mysqli_query($conn, $sql)) {
        echo "Product added successfully!";
    } else {
        echo "Error: " . mysqli_error($conn);
    }
}
?>
<form action="add_order.php" method="POST">
    <label for="customer_id">Customer:</label>
    <select name="customer_id">
        <?php
        include('database.php');
        $result = mysqli_query($conn, "SELECT * FROM customers");
        while ($row = mysqli_fetch_assoc($result)) {
            echo "<option value='{$row['id']}'>{$row['name']}</option>";
        }
        ?>
    </select>
    
    <label for="product_ids[]">Products:</label>
    <select name="product_ids[]" multiple>
        <?php
        $products_result = mysqli_query($conn, "SELECT * FROM products");
        while ($row = mysqli_fetch_assoc($products_result)) {
            echo "<option value='{$row['id']}'>{$row['name']}</option>";
        }
        ?>
    </select>
    
    <button type="submit">Create Order</button>
</form>

<?php
// Add order to the database
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $customer_id = $_POST['customer_id'];
    $product_ids = $_POST['product_ids'];
    
    // Insert order into orders table
    $sql = "INSERT INTO orders (customer_id) VALUES ('$customer_id')";
    if (mysqli_query($conn, $sql)) {
        $order_id = mysqli_insert_id($conn); // Get the last inserted order ID
        
        // Insert order items
        foreach ($product_ids as $product_id) {
            $order_item_sql = "INSERT INTO order_items (order_id, product_id) VALUES ('$order_id', '$product_id')";
            mysqli_query($conn, $order_item_sql);
        }
        
        echo "Order created successfully!";
    } else {
        echo "Error: " . mysqli_error($conn);
    }
}
?>

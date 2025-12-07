
<link rel="stylesheet" href="style.css">


project_folder/
│
├── index.php                # Display products (Read)
├── database.php             # DB connection
├── style.css                # CSS
│
├── categories/
│   ├── manage_categories.php   # Read categories
│   ├── add_category.php        # Create category
│   ├── edit_category.php       # Update category
│   └── delete_category.php     # Delete category
│
├── products/
│   ├── add_product.php         # Create product
│   ├── edit_product.php        # Update product
│   ├── delete_product.php      # Delete product
│
├── customers/
│   ├── add_customer.php        # Create customer
│   ├── manage_customers.php    # Read customers
│   ├── edit_customer.php       # Update customer
│   └── delete_customer.php     # Delete customer
│
├── orders/
│   ├── add_order.php           # Create order
│   ├── view_orders.php         # Read all orders
│   └── view_order_details.php  # Read single order with products


<?php
$host = "localhost";
$db_name = "gadores_db"; // your database name
$username = "root";      // XAMPP default
$password = "";          // XAMPP default

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8mb4", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}
?>


<?php
include 'database.php';

$sql = "SELECT p.product_Id, p.product_name, p.price, p.quantity, c.name AS category_name
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.category_id";
$stmt = $conn->prepare($sql);
$stmt->execute();
$products = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Products List</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<h2>Products</h2>
<a href="products/add_product.php">Add Product</a>
<table border="1">
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Category</th>
        <th>Actions</th>
    </tr>
    <?php foreach($products as $product): ?>
    <tr>
        <td><?= $product['product_Id'] ?></td>
        <td><?= $product['product_name'] ?></td>
        <td><?= $product['price'] ?></td>
        <td><?= $product['quantity'] ?></td>
        <td><?= $product['category_name'] ?? 'N/A' ?></td>
        <td>
            <a href="products/edit_product.php?id=<?= $product['product_Id'] ?>">Edit</a> |
            <a href="products/delete_product.php?id=<?= $product['product_Id'] ?>">Delete</a>
        </td>
    </tr>
    <?php endforeach; ?>
</table>
</body>
</html>


<?php
include '../database.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $price = $_POST['price'];
    $quantity = $_POST['quantity'];
    $category_id = $_POST['category_id'];

    $sql = "INSERT INTO products (product_name, price, quantity, category_id) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->execute([$name, $price, $quantity, $category_id]);

    header("Location: ../index.php");
}

// Fetch categories for dropdown
$cat_stmt = $conn->query("SELECT * FROM categories");
$categories = $cat_stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<h2>Add Product</h2>
<form method="post">
    Name: <input type="text" name="name" required><br>
    Price: <input type="number" name="price" step="0.01" required><br>
    Quantity: <input type="number" name="quantity" required><br>
    Category:
    <select name="category_id" required>
        <?php foreach($categories as $cat): ?>
            <option value="<?= $cat['category_id'] ?>"><?= $cat['name'] ?></option>
        <?php endforeach; ?>
    </select><br>
    <input type="submit" value="Add Product">
</form>


<?php
$host = "localhost";
$db_name = "gadores_db";
$username = "root";
$password = "";

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8mb4", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}
?>


<?php
include 'database.php';

$sql = "SELECT p.product_Id, p.product_name, p.price, p.quantity, c.name AS category_name
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.category_id";
$stmt = $conn->prepare($sql);
$stmt->execute();
$products = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Products List</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<h2>Products</h2>
<a href="products/add_product.php">Add Product</a> |
<a href="categories/manage_categories.php">Manage Categories</a> |
<a href="customers/manage_customers.php">Manage Customers</a> |
<a href="orders/view_orders.php">View Orders</a>
<table border="1" cellpadding="10">
    <tr>
        <th>ID</th><th>Name</th><th>Price</th><th>Quantity</th><th>Category</th><th>Actions</th>
    </tr>
    <?php foreach($products as $product): ?>
    <tr>
        <td><?= $product['product_Id'] ?></td>
        <td><?= $product['product_name'] ?></td>
        <td><?= $product['price'] ?></td>
        <td><?= $product['quantity'] ?></td>
        <td><?= $product['category_name'] ?? 'N/A' ?></td>
        <td>
            <a href="products/edit_product.php?id=<?= $product['product_Id'] ?>">Edit</a> |
            <a href="products/delete_product.php?id=<?= $product['product_Id'] ?>" onclick="return confirm('Delete this product?')">Delete</a>
        </td>
    </tr>
    <?php endforeach; ?>
</table>
</body>
</html>


<?php
include '../database.php';
$stmt = $conn->query("SELECT * FROM categories");
$categories = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<h2>Categories</h2>
<a href="add_category.php">Add Category</a> | <a href="../index.php">Back to Products</a>
<table border="1" cellpadding="10">
<tr><th>ID</th><th>Name</th><th>Actions</th></tr>
<?php foreach($categories as $cat): ?>
<tr>
    <td><?= $cat['category_id'] ?></td>
    <td><?= $cat['name'] ?></td>
    <td>
        <a href="edit_category.php?id=<?= $cat['category_id'] ?>">Edit</a> |
        <a href="delete_category.php?id=<?= $cat['category_id'] ?>" onclick="return confirm('Delete this category?')">Delete</a>
    </td>
</tr>
<?php endforeach; ?>
</table>



<?php
include '../database.php';
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $stmt = $conn->prepare("INSERT INTO categories(name) VALUES (?)");
    $stmt->execute([$name]);
    header("Location: manage_categories.php");
}
?>
<h2>Add Category</h2>
<form method="post">
    Name: <input type="text" name="name" required><br><br>
    <input type="submit" value="Add Category">
</form>
<a href="manage_categories.php">Back</a>


<?php
include '../database.php';
$id = $_GET['id'];
$stmt = $conn->prepare("SELECT * FROM categories WHERE category_id=?");
$stmt->execute([$id]);
$category = $stmt->fetch(PDO::FETCH_ASSOC);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $stmt = $conn->prepare("UPDATE categories SET name=? WHERE category_id=?");
    $stmt->execute([$name, $id]);
    header("Location: manage_categories.php");
}
?>
<h2>Edit Category</h2>
<form method="post">
    Name: <input type="text" name="name" value="<?= $category['name'] ?>" required><br><br>
    <input type="submit" value="Update">
</form>
<a href="manage_categories.php">Back</a>

<?php
include '../database.php';
$id = $_GET['id'];
$stmt = $conn->prepare("DELETE FROM categories WHERE category_id=?");
$stmt->execute([$id]);
header("Location: manage_categories.php");


<?php
include '../database.php';

$cats = $conn->query("SELECT * FROM categories")->fetchAll(PDO::FETCH_ASSOC);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $price = $_POST['price'];
    $quantity = $_POST['quantity'];
    $category_id = $_POST['category_id'];

    $stmt = $conn->prepare("INSERT INTO products(product_name, price, quantity, category_id) VALUES (?,?,?,?)");
    $stmt->execute([$name,$price,$quantity,$category_id]);
    header("Location: ../index.php");
}
?>
<h2>Add Product</h2>
<form method="post">
    Name: <input type="text" name="name" required><br>
    Price: <input type="number" step="0.01" name="price" required><br>
    Quantity: <input type="number" name="quantity" required><br>
    Category:
    <select name="category_id" required>
        <?php foreach($cats as $cat): ?>
            <option value="<?= $cat['category_id'] ?>"><?= $cat['name'] ?></option>
        <?php endforeach; ?>
    </select><br><br>
    <input type="submit" value="Add Product">
</form>
<a href="../index.php">Back</a>


<?php
include '../database.php';
$id = $_GET['id'];
$product = $conn->query("SELECT * FROM products WHERE product_Id=$id")->fetch(PDO::FETCH_ASSOC);
$cats = $conn->query("SELECT * FROM categories")->fetchAll(PDO::FETCH_ASSOC);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $price = $_POST['price'];
    $quantity = $_POST['quantity'];
    $category_id = $_POST['category_id'];

    $stmt = $conn->prepare("UPDATE products SET product_name=?, price=?, quantity=?, category_id=? WHERE product_Id=?");
    $stmt->execute([$name,$price,$quantity,$category_id,$id]);
    header("Location: ../index.php");
}
?>
<h2>Edit Product</h2>
<form method="post">
    Name: <input type="text" name="name" value="<?= $product['product_name'] ?>" required><br>
    Price: <input type="number" step="0.01" name="price" value="<?= $product['price'] ?>" required><br>
    Quantity: <input type="number" name="quantity" value="<?= $product['quantity'] ?>" required><br>
    Category:
    <select name="category_id" required>
        <?php foreach($cats as $cat): ?>
            <option value="<?= $cat['category_id'] ?>" <?= $cat['category_id']==$product['category_id']?'selected':'' ?>><?= $cat['name'] ?></option>
        <?php endforeach; ?>
    </select><br><br>
    <input type="submit" value="Update">
</form>
<a href="../index.php">Back</a>

<?php
include '../database.php';
$id = $_GET['id'];
$conn->prepare("DELETE FROM products WHERE product_Id=?")->execute([$id]);
header("Location: ../index.php");


<?php
include '../database.php';
$customers = $conn->query("SELECT * FROM customer")->fetchAll(PDO::FETCH_ASSOC);
?>

<h2>Customers</h2>
<a href="add_customer.php">Add Customer</a> | <a href="../index.php">Back to Products</a>
<table border="1" cellpadding="10">
<tr><th>ID</th><th>Name</th><th>Address</th><th>Phone</th><th>Actions</th></tr>
<?php foreach($customers as $c): ?>
<tr>
    <td><?= $c['customer_id'] ?></td>
    <td><?= $c['first_name'].' '.$c['last_name'] ?></td>
    <td><?= $c['address'] ?></td>
    <td><?= $c['phone_number'] ?></td>
    <td>
        <a href="edit_customer.php?id=<?= $c['customer_id'] ?>">Edit</a> |
        <a href="delete_customer.php?id=<?= $c['customer_id'] ?>" onclick="return confirm('Delete?')">Delete</a>
    </td>
</tr>
<?php endforeach; ?>
</table>


<?php
include '../database.php';
if($_SERVER['REQUEST_METHOD']=='POST'){
    $stmt = $conn->prepare("INSERT INTO customer(first_name,last_name,address,phone_number) VALUES(?,?,?,?)");
    $stmt->execute([$_POST['first_name'],$_POST['last_name'],$_POST['address'],$_POST['phone_number']]);
    header("Location: manage_customers.php");
}
?>
<h2>Add Customer</h2>
<form method="post">
    First Name: <input type="text" name="first_name" required><br>
    Last Name: <input type="text" name="last_name" required><br>
    Address: <input type="text" name="address" required><br>
    Phone: <input type="text" name="phone_number" required><br><br>
    <input type="submit" value="Add Customer">
</form>
<a href="manage_customers.php">Back</a>


<?php
include '../database.php';
$customers = $conn->query("SELECT * FROM customer")->fetchAll(PDO::FETCH_ASSOC);
$products = $conn->query("SELECT * FROM products")->fetchAll(PDO::FETCH_ASSOC);

if($_SERVER['REQUEST_METHOD']=='POST'){
    $customer_id = $_POST['customer_id'];
    $product_ids = $_POST['product_id'];
    $quantities = $_POST['quantity'];

    // Insert order
    $stmt = $conn->prepare("INSERT INTO orders(customer_id) VALUES(?)");
    $stmt->execute([$customer_id]);
    $order_id = $conn->lastInsertId();

    // Insert order_items
    foreach($product_ids as $i=>$pid){
        $stmt2 = $conn->prepare("INSERT INTO order_items(order_id, product_id, quantity) VALUES(?,?,?)");
        $stmt2->execute([$order_id,$pid,$quantities[$i]]);
    }

    header("Location: view_orders.php");
}
?>
<h2>Create Order</h2>
<form method="post">
    Customer:
    <select name="customer_id" required>
        <?php foreach($customers as $c): ?>
            <option value="<?= $c['customer_id'] ?>"><?= $c['first_name'].' '.$c['last_name'] ?></option>
        <?php endforeach; ?>
    </select><br><br>

    <div id="products">
        Product:
        <select name="product_id[]" required>
            <?php foreach($products as $p): ?>
                <option value="<?= $p['product_Id'] ?>"><?= $p['product_name'] ?></option>
            <?php endforeach; ?>
        </select>
        Quantity: <input type="number" name="quantity[]" value="1" required><br>
    </div>
    <button type="button" onclick="addProduct()">Add Another Product</button><br><br>
    <input type="submit" value="Create Order">
</form>

<script>
function addProduct(){
    let div = document.getElementById('products');
    div.innerHTML += 'Product: <select name="product_id[]" required><?php foreach($products as $p){ echo "<option value=".$p["product_Id"].">".$p["product_name"]."</option>"; } ?></select> Quantity: <input type="number" name="quantity[]" value="1" required><br>';
}
</script>
<a href="view_orders.php">Back</a>


<?php
include '../database.php';
$sql = "SELECT o.order_id, c.first_name, c.last_name, COUNT(oi.order_item_id) AS items
        FROM orders o
        JOIN customer c ON o.customer_id=c.customer_id
        LEFT JOIN order_items oi ON o.order_id=oi.order_id
        GROUP BY o.order_id";
$orders = $conn->query($sql)->fetchAll(PDO::FETCH_ASSOC);
?>

<h2>Orders</h2>
<a href="add_order.php">Create Order</a> | <a href="../index.php">Back to Products</a>
<table border="1" cellpadding="10">
<tr><th>ID</th><th>Customer</th><th>Items</th><th>Actions</th></tr>
<?php foreach($orders as $o): ?>
<tr>
    <td><?= $o['order_id'] ?></td>
    <td><?= $o['first_name'].' '.$o['last_name'] ?></td>
    <td><?= $o['items'] ?></td>
    <td><a href="view_order_details.php?id=<?= $o['order_id'] ?>">View Details</a></td>
</tr>
<?php endforeach; ?>
</table>


<?php
include '../database.php';
$id = $_GET['id'];
$sql = "SELECT p.product_name, p.price, oi.quantity
        FROM order_items oi
        JOIN products p ON oi.product_id=p.product_Id
        WHERE oi.order_id=?";
$stmt = $conn->prepare($sql);
$stmt->execute([$id]);
$items = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<h2>Order Details</h2>
<table border="1" cellpadding="10">
<tr><th>Product</th><th>Price</th><th>Quantity</th><th>Total</th></tr>
<?php
$total = 0;
foreach($items as $i):
    $line_total = $i['price']*$i['quantity'];
    $total += $line_total;
?>
<tr>
    <td><?= $i['product_name'] ?></td>
    <td><?= $i['price'] ?></td>
    <td><?= $i['quantity'] ?></td>
    <td><?= $line_total ?></td>
</tr>
<?php endforeach; ?>
<tr><td colspan="3">Total Amount</td><td><?= $total ?></td></tr>
</table>
<a href="view_orders.php">Back</a>

/* General Styles */
body {
    font-family: Arial, sans-serif;
    background-color: #f5f5f5;
    margin: 20px;
}

h2 {
    color: #333;
}

a {
    text-decoration: none;
    color: #007BFF;
}

a:hover {
    text-decoration: underline;
}

/* Tables */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
    background-color: #fff;
}

table th, table td {
    border: 1px solid #ccc;
    padding: 10px;
    text-align: left;
}

table th {
    background-color: #f0f0f0;
}

/* Forms */
form {
    background-color: #fff;
    padding: 20px;
    border: 1px solid #ddd;
    max-width: 600px;
}

form input[type="text"],
form input[type="number"],
form select {
    width: 100%;
    padding: 8px;
    margin: 6px 0 12px 0;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
}

form input[type="submit"],
form button {
    background-color: #28a745;
    color: white;
    padding: 10px 16px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

form input[type="submit"]:hover,
form button:hover {
    background-color: #218838;
}

/* Buttons & Links */
button {
    margin-top: 10px;
}

a.button {
    display: inline-block;
    padding: 8px 12px;
    margin: 4px 0;
    background-color: #007BFF;
    color: #fff;
    border-radius: 4px;
}

a.button:hover {
    background-color: #0056b3;
}

/* Responsive */
@media screen and (max-width: 768px) {
    table, form {
        width: 100%;
        font-size: 14px;
    }
}


<form action="add_customer.php" method="POST">
    <label for="customer_name">Customer Name:</label>
    <input type="text" name="customer_name" required>
    
    <label for="email">Email:</label>
    <input type="email" name="email" required>
    
    <button type="submit">Add Customer</button>
</form>

<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    include('database.php');
    $customer_name = $_POST['customer_name'];
    $email = $_POST['email'];
    $sql = "INSERT INTO customers (name, email) VALUES ('$customer_name', '$email')";
    if (mysqli_query($conn, $sql)) {
        echo "Customer added successfully!";
    } else {
        echo "Error: " . mysqli_error($conn);
    }
}
?>

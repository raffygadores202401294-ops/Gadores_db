<form action="add_category.php" method="POST">
    <label for="category_name">Category Name:</label>
    <input type="text" name="category_name" required>
    <button type="submit">Add Category</button>
</form>

<?php
// Add category to the database
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    include('database.php');
    $category_name = $_POST['category_name'];
    $sql = "INSERT INTO categories (name) VALUES ('$category_name')";
    if (mysqli_query($conn, $sql)) {
        echo "Category added successfully!";
    } else {
        echo "Error: " . mysqli_error($conn);
    }
}
?>
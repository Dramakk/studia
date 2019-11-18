<?php include "header.html"; ?>
<body>
<div id="container-nav">
    <a href="../index.php?action=browse" class="icon-block">
        <button type="button">User Panel</button>
    </a>
    <a href="../index.php?action=logout" class="icon-block">
        <button type="button">Logout</button>
    </a>
</div>
<div id="container">
    <h1>Recipe lookup</h1>
    <form method="GET" action="../index.php">
        <input type="text" placeholder="Type ingredients You have (e.g. beef, eggs, tomato)" name="searchString">
        <button type="submit">Search for recipes!</button>
    </form>
</div>
</body>
</html>
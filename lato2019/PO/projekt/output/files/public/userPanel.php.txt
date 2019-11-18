<?php
session_start();
if(!isset($_SESSION['zalogowany']))
    header("Location: /index.php");
include "header.html"; ?>
<body>
<div id="container-nav">
    <a href="../index.php" class="icon-block">
        <button type="button">Go back</button>
    </a>
    <a href="../index.php?action=logout" class="icon-block">
        <button type="button">Logout</button>
    </a>
</div>
<h2 class="text-center"><?php echo "User: ". $_SESSION['zalogowany']->getUsername();?></h2>

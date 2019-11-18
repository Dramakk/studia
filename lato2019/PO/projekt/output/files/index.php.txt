<?php
include_once 'src/Application.php';
include_once "src/userController.php";
include_once "src/userView.php";
include_once "src/recipeView.php";
include_once "src/user.php";
session_start();
try {
    $app = new Application();
    $action = 'showMain';
    if (isset($_GET['action'])) {
        $action = $_GET['action'];
    }
    switch ($action) {
        case 'save':
            if (!isset($_GET['id']))
                include 'public/mainTemplate.php';
            else
                $app->save($_GET['id']);
                header("Location: " . $_SESSION['returnUrl']);
            break;
        case 'logout':
            $app->logout();
            break;
        case 'registration':
            include "./public/register.php";
            break;
        case 'signIn':
            include "./public/login.php";
            break;
        case 'loginUser':
            $app->login();
            break;
        case 'registerUser':
            if (!isset($_POST['userU']) || !isset($_POST['userP'])) {
                header("Location: /public/register.php");
            } else
                $app->register();
            break;
        case 'browse':
            if (!isset($_SESSION['zalogowany']))
                include 'public/mainTemplate.php';
            else {
                include "public/userPanel.php";
                $n = new UserView($app->getDatabase());
                $n->generateView();
            }
            break;
        case 'delete':
            if (!isset($_SESSION['zalogowany']))
                include 'public/mainTemplate.php';
            else
                if (!isset($_GET['recipeName'])) {
                    header("Location: /index.php?action=browse");
                } else {
                    $app->getDatabase()->delete($_SESSION['zalogowany']->getUserID(), urldecode($_GET['recipeName']));
                    header("Location: /index.php?action=browse");
                }
            break;
        default:
            if (!isset($_SESSION['zalogowany']))
                if ($_GET['action'] == "success") {
                    echo "<h2 class='text-center'>Registration succesful!</h2>";
                    include 'public/mainTemplate.php';
                } else {
                    include 'public/mainTemplate.php';
                }
            else
                include "public/logged.php";
            if(isset($_GET['searchString'])){
                $view = new RecipeView();
                $view->generateView();
            }
    }
    include "public/footer.php";
} catch (Exception $e) {
    //echo 'Błąd: ' . $e->getMessage();
    exit('Portal chwilowo niedostępny');
}
?>

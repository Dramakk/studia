<?php
include "database.php";
/**
 * Class Application
 * klasa obudowująca cały serwis
 */
class Application
{
    /**
     * @var DB
     */
    private $database;
    /**
     * Application constructor.
     */
    public function __construct()
    {
        $this->database = new DB();
    }
    /**
     * @return DB
     */
    public function getDatabase(): DB
    {
        return $this->database;
    }
    /**
     * Wrapper do funkcji logującej
     */
    public function login()
    {
        $controller = new UserController();
        $_SESSION['zalogowany'] = $controller->login($this->database);
        header("Location: /index.php");
    }

    /**
     *
     */
    public function logout()
    {
        $_SESSION['zalogowany'] = null;
        header("Location: /index.php");
    }

    /**
     * Wrapper do funckji rejestrującej
     */
    public function register()
    {
        $controller = new UserController();
        $controller->register($this->database);
        header("Location: /index.php?action=success");
    }

    /**
     * @param $id
     * Funkcja zapisująca przepisy do bazy danych
     */
    public function save($id)
    {
        $this->database->insert("INSERT INTO recipe (link, linkURL, userID, recipeName) VALUES (?, ?, ?, ?)",
            array($_SESSION['recipe' . $id][0], $_SESSION['recipe' . $id][1], $_SESSION['zalogowany']->getUserId(), $_SESSION['recipe' . $id][2]));
    }
}

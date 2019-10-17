<?php
include_once "user.php";

/**
 * Class UserController
 * implementuje podstawowe operacje związane z użytkownikami
 */
class UserController
{
    /**
     * @var string
     */
    private $userName;
    /**
     * @var string
     */
    private $password;

    /**
     * UserController constructor.
     */
    public function __construct()
    {
        if (!isset($_POST['userU']) || !isset($_POST['userP'])) {
            header("Location: /index.php");
        } else {
            $this->userName = $_POST['userU'];
            $this->password = $_POST['userP'];
        }
    }

    /**
     * @param DB $database
     * @return User|null
     */
    public function login($database)
    {
        $userObject = $database->select("SELECT * FROM users WHERE username = :username", array(':username' => $this->userName));
        if (password_verify($this->password, $userObject[0]['password'])) {
            print_r($userObject);
            return new User($userObject[0]['username'], $userObject[0]['Id']);
        } else
            return null;
    }

    /**
     * @param DB $database
     * Sprawdza czy można zarejestrować użytkownika o podanej nazwie, jeśli tak to hashuje hasło i zapisuje do bazy danych
     * wpp. wracamy do formularza rejestracji
     */
    public function register($database)
    {
        $result = $database->select("SELECT * FROM users WHERE username = ?", array($this->userName));
        if (empty($result)) {
            $hash = password_hash($this->password, PASSWORD_DEFAULT);
            $database->insert("INSERT INTO users (username, password) VALUES (?, ?)", array($this->userName, $hash));
        } else {
            header("Location: /public/register.php?action=taken");
        }
    }
}

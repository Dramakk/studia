<?php
/**
 * Class User
 * model użytkownika
 */
class User
{
    /**
     * @var string|null
     */
    private $userName = null;
    /**
     * @var integer|null
     */
    private $userID = null;

    /**
     * @param DB $db
     * @return Recipe[]|mixed
     * Funckja zwraca przepisy zapisane w bazie danych przez tego użytkownika
     */
    function getBookmarksFromDB($db)
    {
        return $db->select("SELECT * FROM recipe WHERE userID = ?", array($this->userID));
    }

    /**
     * User constructor.
     * @param string $userName
     * @param integer $userID
     */
    function __construct($userName, $userID)
    {
        $this->userName = $userName;
        $this->userID = $userID;
    }

    /**
     * @return integer|null
     */
    public function getUserID()
    {
        return $this->userID;
    }

    /**
     * @return string|null
     */
    public function getUserName()
    {
        return $this->userName;
    }
}

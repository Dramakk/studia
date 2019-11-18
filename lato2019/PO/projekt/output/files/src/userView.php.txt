<?php
session_start();

/**
 * Class UserView
 * generuje widok dla panelu użytkownika
 */
class UserView
{
    /**
     * @var array
     */
    private $fetchedBookmarks;

    /**
     * UserView constructor.
     * @param DB $db
     */
    public function __construct($db)
    {
        if (!isset($_SESSION['zalogowany'])) {
            header("Location: /index.php");
        } else
            $this->fetchedBookmarks = $_SESSION['zalogowany']->getBookmarksFromDB($db);
    }

    /**
     * Generowanie widoku panelu użytkownika
     */
    public function generateView()
    {
        if (empty($this->fetchedBookmarks)) {
            echo "<h3 class='text-center'>Nothing here :( Try adding some bookmarks!</h3>";
        };
        $i = 0;
        foreach ($this->fetchedBookmarks as $u) {
            if ($i % 3 == 0) {
                echo "<div class=\"row text-center\">";
            }
            echo "<div class=\"col col-4\">";
            echo "<figure class=\"figure\">";
            echo "<a href=\"";
            echo $u['link'];
            echo "\">";
            echo "<img src=\"";
            echo $u['linkURL'];
            echo "\" class=\"figure-img img-fluid rounded mx-auto d-block\">";
            echo "</a>";
            echo "<figcaption>";
            echo $u['recipeName'];
            echo "</figcaption>";
            echo '<a href="../index.php?action=delete&recipeName=' . urlencode($u['recipeName']) . '"><button type="button" class="btn btn-primary" style="background-color: crimson">Delete</button></a>';
            echo "</figure>";
            echo "</div>";
            if (($i + 1) % 3 == 0) {
                echo "</div>";
            }
            $i = $i + 1;
        }
    }
}

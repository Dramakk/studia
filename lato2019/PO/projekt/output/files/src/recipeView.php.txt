<?php
session_start();
include_once "recipeSearch.php";

/**
 * Class RecipeView
 * generator widoku dla przepisów
 */
class RecipeView{
    /**
     * @var RecipeSearch|null
     */
    private $recipeSearch = null;
    /**
     * @var Recipe[]|null
     */
    private $recipesFound = null;

    /**
     * RecipeView constructor.
     */
    function __construct()
    {
        $this->recipeSearch = new RecipeSearch();
        if(!isset($_GET['index'])){
            $page = 0;
        }
        else $page = (int)utf8_decode($_GET['index']);
        $from = $page*9;
        $to = $from + 9;
        $this->recipesFound = $this->recipeSearch->makeRequest($from, $to);
        $_SESSION["returnUrl"] = "index.php" . "?index=" . $page. "&searchString=" . $this->recipeSearch->getSearchUrl();
    }

    /**
     *
     */
    public function generateView()
    {
        for ($i = 0; $i < 3; $i++) {
            echo "<div class=\"row text-center\">";
            for ($j = $i*3; $j < $i*3+3; $j++) {
                echo "<div class=\"col col-4\">";
                echo "<figure class=\"figure\">";
                echo "<a href=\"";
                echo $this->recipesFound[$j]->getUrl();
                echo "\">";
                echo "<img src=\"";
                echo $this->recipesFound[$j]->getUrlImage();
                echo "\" class=\"figure-img img-fluid rounded mx-auto d-block\">";
                echo "</a>";
                echo "<figcaption>";
                echo $this->recipesFound[$j]->getRecipeName();
                echo "</figcaption>";
                if(isset($_SESSION['zalogowany'])){
                    $_SESSION['recipe'.$j] = array($this->recipesFound[$j]->getUrl(), $this->recipesFound[$j]->getUrlImage(), $this->recipesFound[$j]->getRecipeName());
                    echo '<a href="../index.php?action=save&id=' . $j . '"><button type="button" class="btn btn-primary" style="background-color: crimson">Save</button></a>';
                }
                echo "</figure>";
                echo "</div>";
            }
            echo "</div>";
        }
        echo "<div class='row text-center'>";
        for($i = 1; $i<=10; $i++){
            echo "<div class='col col-1'><a style='color: black;' href='../index.php" . "?index=" . $i . "&searchString=" . $this->recipeSearch->getSearchUrl() . "'" . ">" . $i ."</a></div>";
        }
        echo "</div>";
    }

    /**
     * @return RecipeSearch|null
     */
    public function getRecipeSearch()
    {
        return $this->recipeSearch;
    }
}
?>

<?php
include_once "recipe.php";
/**
 * Używane przy połączeniu z bazą przepisów
 */
const appId = "&app_id=da41b10e";
/**
 * Używane przy połączeniu z bazą przepisów
 */
const appKey = "&app_key=a0328f2d802935d7c03c4233f2c5fc82";

/**
 * Class RecipeSearch
 * służy do tworzenia i wykonywania zapytań do bazy przepisów
 */
class RecipeSearch
{
    /**
     * @var string|null
     */
    private $searchUrl = null;

    /**
     * RecipeSearch constructor.
     */
    function __construct()
    {
        if (!isset($_GET['searchString'])) {
            header("Location: /index.php");
        } else {
            $this->searchUrl = $_GET['searchString'];
        }
    }

    /**
     * @return string|null
     */
    public function getSearchUrl()
    {
        return $this->searchUrl;
    }

    /**
     * @param int $from
     * @param int $to
     * @return Recipe[]
     */
    function makeRequest($from = 0, $to = 9)
    {
        $url = "https://api.edamam.com/search?q=";
        $searchArr = explode(", ", $this->searchUrl);
        foreach ($searchArr as $ingr) {
            $url .= $ingr . "+";
        }
        $url .= appId . appKey;
        $url .= "&from=" . $from . "&to=" . $to;
        $url = str_replace(" ", "+", $url);
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/json',
        ));
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
        $result = curl_exec($curl);
        if (!$result) {
            die("Connection Failure");
        }
        curl_close($curl);
        $response = json_decode($result, true);
        $data = $response['hits'];
        $recipesToShow = array();
        foreach ($data as $r) {
            $recipeObject = new Recipe($r['recipe']['url'], $r['recipe']['image'], $r['recipe']['label']);
            $recipesToShow[] = $recipeObject;
        }
        return $recipesToShow;
    }
}
<?php
/**
 * Class Recipe
 * model przepisu
 */
class Recipe
{
    /**
     * @var string|null
     */
    private $url = null;
    /**
     * @var string|null
     */
    private $urlImage = null;
    /**
     * @var string|null
     */
    private $recipeName = null;

    /**
     * Recipe constructor.
     * @param string $url
     * @param string $urlImage
     * @param string $recipeName
     */
    function __construct($url, $urlImage, $recipeName)
    {
        $this->url = $url;
        $this->urlImage = $urlImage;
        $this->recipeName = $recipeName;
    }

    /**
     * @return string|null
     */
    public function getUrl()
    {
        return $this->url;
    }

    /**
     * @return string|null
     */
    public function getRecipeName()
    {
        return $this->recipeName;
    }

    /**
     * @return string|null
     */
    public function getUrlImage()
    {
        return $this->urlImage;
    }
}

?>

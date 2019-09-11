<?php 

use \Hcode\Page;
use \Hcode\Model\Product;
use \Hcode\Model\Category;

/* Chamando a Página Inicial (index.html) */
$app->get('/', function() {

	$products = Product::listAll();
	
	$page = new Page();

	$page->setTpl("index",[
		'products'=>Product::checkList($products)
	]);

});
/* Chamando a Página Inicial (index.html) */

$app->get("/categories/:idcategory", function($idcategory) {

	$category = new Category();

	$category->get((int)$idcategory);

	$page = new Page();

	$page->setTpl("category", [
		'category'=>$category->getValues(),
		'products'=>Product::checkList($category->getProducts())
	]);

});

?>
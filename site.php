<?php 

use \Hcode\Page;
use \Hcode\Model\Product;
use \Hcode\Model\Category;
use \Hcode\Model\Cart;
use \Hcode\Model\Address;
use \Hcode\Model\User;
use \Hcode\Model\Order;
use \Hcode\Model\OrderStatus;

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

	$page = (isset($_GET['page'])) ? (int)$_GET['page'] : 1;
	
	$category = new Category();

	$category->get((int)$idcategory);
	
	$pagination = $category->getProductsPage($page);
	
	$pages = [];
	
	for ($i=1; $i <= $pagination['pages']; $i++) {
		array_push($pages, [
			'link'=>'/categories/'.$category->getidcategory().'?page='.$i,
			'page'=>$i
		]);
	}

	$page = new Page();

	$page->setTpl("category", [
		'category'=>$category->getValues(),
		'products'=>$pagination["data"],
		'pages'=>$pages
	]);

});

$app->get("/products/:desurl", function($desurl){
	
	$product = new Product();
	
	$product->getFromURL($desurl);
	
	$page = new Page();
	
	$page->setTpl("product-detail", [
		'product'=>$product->getValues(),
		'categories'=>$product->getCategories()
	]);
});


$app->get("/profile", function(){
	
	User::verifyLogin(false);
	
	$user = User::getFromSession();
	
	$page = new Page();
	
	$page->setTpl("profile", [
		'user'=>$user->getValues(),
		'profileMsg'=>User::getSuccess(),
		'profileError'=>User::getError()
	]);
	
});

$app->post("/profile", function(){
	
	User::verifyLogin(false);
	
	if (!isset($_POST['desperson']) || $_POST['desperson'] === '') {
		
		User::setError("Preencha o seu nome");
		
		header("Location: /profile");
		exit;
		
	}
	
	if (!isset($_POST['desemail']) || $_POST['desemail'] === '') {
		
		User::setError("Preencha o seu e-mail");
		
		header("Location: /profile");
		exit;
		
	}
	
	$user = User::getFromSession();
	
	if ($_POST['desemail'] !== $user->getdesemail()) {
		
		if (User::checkLoginExists($_POST['desemail']) === true) {
			
			User::setError("Este endereço de e-mail já está cadastrado");
			
			header("Location: /profile");
			exit;
		}
	}
	
	
	
	$_POST['inadmin'] = $user->getinadmin();
	$_POST['despassword'] = $user->getdespassword();
	$_POST['deslogin'] = $_POST['desemail'];
	
	$user->setData($_POST);
	
	$user->update();
		
	User::setSuccess("Cadastro alterado com sucesso");
	
	header("Location: /profile");
	exit;
	
});

$app->get("/profile/orders", function(){
	
	User::verifyLogin(false);
	
	$user = User::getFromSession();
	
	$page = new Page();
	
	$page->setTpl("profile-orders", [
		'orders'=>$user->getOrders()
	]);
	
	
});


$app->get("/profile/orders/:idorder", function($idorder){
		
	User::verifyLogin(false);
														 
	$order = new Order();
	
	$order->get((int)$idorder);
	
	$cart = new Cart();
	
	$cart->get((int)$order->getidcart());	
	
	$cart->getCalculateTotal();
	
	$user = User::getFromSession();
	
	$page = new Page();
	
	$page->setTpl("profile-orders-detail", [
		'order'=>$order->getValues(),
		'cart'=>$cart->getValues(),
		'products'=>$cart->getProducts()
	]);
												
});


?>
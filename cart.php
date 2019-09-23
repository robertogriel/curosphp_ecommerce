<?php 

use \Hcode\Page;
use \Hcode\Model\Product;
use \Hcode\Model\Category;
use \Hcode\Model\Cart;
use \Hcode\Model\Address;
use \Hcode\Model\User;
use \Hcode\Model\Order;
use \Hcode\Model\OrderStatus;

$app->get("/cart", function(){
	
	$cart = Cart::getFromSession();
	
	$page = new Page();
	
	$page->setTpl("cart", [
		'cart'=>$cart->getValues(),
		'products'=>$cart->getProducts(),
		'error'=>Cart::getMsgError()
	]);
});

$app->get("/cart/:idproduct/add", function($idproduct) {
	
	$product = new Product();
	
	$product->get((int)$idproduct);
	
	$cart = Cart::getFromSession();
	
	$qtd = (isset($_GET['qtd'])) ? (int)$_GET['qtd'] : 1;
	
	for ($i = 0; $i < $qtd; $i++) {
		
		$cart->addProduct($product);
		
	}
	
	header("Location: /cart");
	exit;
});

$app->get("/cart/:idproduct/minus", function($idproduct) {
	
	$product = new Product();
	
	$product->get((int)$idproduct);
	
	$cart = Cart::getFromSession();
	
	$cart->removeProduct($product);
	
	header("Location: /cart");
	exit;
});

$app->get("/cart/:idproduct/remove", function($idproduct) {
	
	$product = new Product();
	
	$product->get((int)$idproduct);
	
	$cart = Cart::getFromSession();
	
	$cart->removeProduct($product, true);
	
	header("Location: /cart");
	exit;
});

$app->post("/cart/freight", function(){
	
	$cart = Cart::getFromSession();
	
	$cart->setFreight($_POST['zipcode']);
	
	header("Location: /cart");
	exit;
	
});

$app->get("/checkout", function(){
	
	User::verifyLogin(false);
	
	$address = new Address();
	
	$cart = Cart::getFromSession();
	
/*	if (isset($_GET['zipcode'])) {
		$_GET['zipcode'] = $cart->deszipcode();
	}*/
	
	if (isset($_GET['zipcode'])) {
		
		$address->loadFromCEP($_GET['zipcode']);
		
		$cart->setdeszipcode($_GET['zipcode']);
		
		$cart->save();
		
		$cart->getCalculateTotal();
		
	}
	
	if (!$address->getdesaddress()) $address->setdesaddress('');
	if (!$address->getdesnumber()) $address->setdesnumber('');
	if (!$address->getdescomplement()) $address->setdescomplement('');
	if (!$address->getdesdistrict()) $address->setdesdistrict('');
	if (!$address->getdescity()) $address->setdescity('');
	if (!$address->getdesstate()) $address->setdesstate('');
	if (!$address->getdescountry()) $address->setdescountry('');
	if (!$address->getdeszipcode()) $address->setdeszipcode('');
		
	$page = new Page();
	
	$page->setTpl("checkout", [
		'cart'=>$cart->getValues(),
		'address'=>$address->getValues(),
		'products'=>$cart->getProducts(),
		'error'=>Address::getMsgError()
	]);
});

$app->post("/checkout", function(){
	
	User::verifyLogin(false);
	
	if (!isset($_POST['zipcode']) || $_POST['zipcode'] === '') {
		
		Address::setMsgError("Por favor, preencha o CEP");
		header("Location: /checkout");
		exit;
	}
	
	if (!isset($_POST['desaddress']) || $_POST['desaddress'] === '') {
		
		Address::setMsgError("Por favor, preencha o endereço");
		header("Location: /checkout");
		exit;
	}
	if (!isset($_POST['desnumber']) || $_POST['desnumber'] === '') {
		
		Address::setMsgError("Por favor, preencha o número");
		header("Location: /checkout");
		exit;
	}
	if (!isset($_POST['desdistrict']) || $_POST['desdistrict'] === '') {
		
		Address::setMsgError("Por favor, preencha o bairro");
		header("Location: /checkout");
		exit;
	}
	if (!isset($_POST['descity']) || $_POST['descity'] === '') {
		
		Address::setMsgError("Por favor, preencha a cidade");
		header("Location: /checkout");
		exit;
	}
	if (!isset($_POST['desstate']) || $_POST['desstate'] === '') {
		
		Address::setMsgError("Por favor, preencha o estado");
		header("Location: /checkout");
		exit;
	}
	if (!isset($_POST['descountry']) || $_POST['descountry'] === '') {
		
		Address::setMsgError("Por favor, preencha o país");
		header("Location: /checkout");
		exit;
	}
	
	
	$user = User::getFromSession();
	
	$address = new Address();
	
	$_POST['deszipcode'] = $_POST['zipcode'];
	$_POST['idperson'] = $user->getidperson();
	$address->setData($_POST);
	
	$address->save();
	
	$cart = Cart::getFromSession();
	
	$cart->getCalculateTotal();
	
	$order = new Order();
	
	$order->setData([
	'idcart'=>$cart->getidcart(),
	'idaddress'=>$address->getidaddress(),
	'iduser'=>$user->getiduser(),
	'idstatus'=>OrderStatus::EM_ABERTO,
	'vltotal'=>$cart->getvltotal()
	]);
	
	$order->save();
	
	$_SESSION[Cart::SESSION] = NULL;
	
	session_regenerate_id();
	
	switch ((int)$_POST['payment-method']) {
			
		case 1:
			
			header("Location: /order/" . $order->getidorder() . "/pagseguro");
			exit;
			
		break;
			
		case 2:
			
			header("Location: /order/" . $order->getidorder() . "/paypal");
			exit;
			
		break;
			
		case 3:
			
			header("Location: /order/" . $order->getidorder() . "/boleto");
			exit;
		
		break;
		
	}
	
	
	
	
});

$app->get("/order/:idorder", function($idorder){
	
	User::verifyLogin(false);
	
	$order = new Order();
	
	$order->get((int)$idorder);
	
	$page = new Page();
	
	$page->setTpl("payment", [
		'order'=>$order->getValues()
	]);
	
});
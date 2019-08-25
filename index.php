<?php 
session_start();
require_once("vendor/autoload.php");

use \Slim\Slim;
use \Hcode\Page;
use \Hcode\PageAdmin;
use \Hcode\Model\User;

$app = new Slim();

$app->config('debug', true);

/* Chamando a Página Inicial (index.html) */
$app->get('/', function() {
    
	$page = new Page();

	$page->setTpl("index");

});
/* Chamando a Página Inicial (index.html) */

/* Chamando a Página de Administração (admin/index.html) */
$app->get('/admin', function() {
    
	User::verifyLogin();

	$page = new PageAdmin();

	$page->setTpl("index");

});
/* Chamando a Página de Administração (admin/index.html) */

/* Chamando a Página de Login (admin/login.html) */
$app->get('/admin/login', function() {
    
	$page = new PageAdmin([
		"header"=>false,
		"footer"=>false
	]);

	$page->setTpl("login");

});
/* Chamando a Página de Login (admin/login.html) */

/* Chamando a Página de Confirmação de Login (admin/login.html) */
$app->post('/admin/login', function() {

	User::login($_POST["login"], $_POST["password"]);

	header("Location: /admin");
	exit;

});
/* Chamando a Página de Confirmação Login (admin/login.html) */

/* Chamando a Página de Logout  */
$app->get('/admin/logout', function() {
    
	User::logout();

	header("Location: /admin/login");

	exit;

});
/* Chamando a Página de Logout */

$app->run();

 ?>
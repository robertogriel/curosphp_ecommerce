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

/* Chamando a Página de Usuários */
$app->get("/admin/users", function() {

	User::verifyLogin();

	$users = User::listAll();

	$page = new PageAdmin();

	$page->setTpl("users", array(
		"users"=>$users
	));

});
/* Chamando a Página de Usuários */

/* Chamando a Página de Criar Usuários */
$app->get("/admin/users/create", function() {

	User::verifyLogin();

	$page = new PageAdmin();

	$page->setTpl("users-create");
	
});
/* Chamando a Página de Criar Usuários */

/* Definindo os dados que foram enviados na exclusão do usuário */
$app->get("/admin/users/:iduser/delete", function($iduser) {

	User::verifyLogin();

	$user = new User();

	$user->get((int)$iduser);

	$user->delete();

	header("Location: /admin/users");
 	exit;

});
/* Definindo os dados que foram enviados na exclusão do usuário */

/* Chamando a Página de Editar Usuários */
$app->get('/admin/users/:iduser', function($iduser){
 
   User::verifyLogin();
 
   $user = new User();
 
   $user->get((int)$iduser);
 
   $page = new PageAdmin();
 
   $page ->setTpl("users-update", array(
        "user"=>$user->getValues()
    ));
 
});
/* Chamando a Página de Editar Usuários */

/* Definindo os dados que foram enviados na criação do usuário */
$app->post("/admin/users/create", function () {

 	User::verifyLogin();

	$user = new User();

 	$_POST["inadmin"] = (isset($_POST["inadmin"])) ? 1 : 0;

 	$_POST['despassword'] = password_hash($_POST["despassword"], PASSWORD_DEFAULT, [

 		"cost"=>12

 	]);

 	$user->setData($_POST);

	$user->save();

	header("Location: /admin/users");
 	exit;

});
/* Definindo os dados que foram enviados na criação do usuário */

/* Definindo os dados que foram enviados na edição do usuário */
$app->post("/admin/users/:iduser", function($iduser) {

	User::verifyLogin();

	$user = new User();

	$_POST["inadmin"] = (isset($_POST["inadmin"])) ? 1 : 0;

	$user->get((int)$iduser);

	$user->setData($_POST);

	$user->update();

	header("Location: /admin/users");

	exit;
});
/* Definindo os dados que foram enviados na edição do usuário */


$app->run();

 ?>
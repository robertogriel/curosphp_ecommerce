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

/* Criando a Página para Recuperar Senha */
$app->get("/admin/forgot", function() {

	$page = new PageAdmin([
		"header"=>false,
		"footer"=>false
	]);

	$page->setTpl("forgot");
});
/* Criando a Página para Recuperar Senha */

/* Recuperando dados da Página de Recuperação de Senha */
$app->post("/admin/forgot", function() {

	$user = User::getForgot($_POST["email"]);

	header("Location: /admin/forgot/sent");
	exit;

});
/* Recuperando dados da Página de Recuperação de Senha */

/* Criando a Página para Recuperação de Senha Enviada */
$app->get("/admin/forgot/sent", function(){

	$page = new PageAdmin([
		"header"=>false,
		"footer"=>false
	]);

	$page->setTpl("forgot-sent");

});
/* Criando a Página para Recuperação de Senha Enviada */

/* Criando a Página para Recuperação de Senha para Nova Senha */
$app->get("/admin/forgot/reset", function(){

	$user = User::validForgotDecrypt($_GET["code"]);

	$page = new PageAdmin([
		"header"=>false,
		"footer"=>false
	]);

	$page->setTpl("forgot-reset", array(
		"name"=>$user["desperson"],
		"code"=>$_GET["code"]
	));

});
/* Criando a Página para Recuperação de Senha para Nova Senha */

/* Recuperando e Verificando dados para Recuperação de Senha */
$app->post("/admin/forgot/reset", function(){

	$forgot = User::validForgotDecrypt($_POST["code"]);

	User::setForgotUsed($forgot["idrecovery"]);

	$user = new User();

	$user->get((int)$forgot["iduser"]);

	$password = password_hash($_POST["password"], PASSWORD_BCRYPT,[
		"cost"=>12
	]);

	$user->setPassword($password);

	$page = new PageAdmin([
		"header"=>false,
		"footer"=>false
	]);

	$page->setTpl("forgot-reset-success");

});
/* Recuperando e Verificando dados para Recuperação de Senha */


$app->run();

 ?>
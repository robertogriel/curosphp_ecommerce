<?php

use \Hcode\PageAdmin;
use \Hcode\Model\User;

/* Chamando a Página de Usuários */
$app->get("/admin/users", function() {

	User::verifyLogin();
	
	$search = (isset($_GET['search'])) ? $_GET['search'] : '';
	
	$page = (isset($_GET['page'])) ? (int)$_GET['page'] : 1;
	
	if ($search != '') {
		
		$pagination = User::getPageSearch($search, $page, 10);
		
	} else {
		
		$pagination = User::getPage($page, 10);
		
	}

	
	
	$pages = [];
	
	for ($x = 0; $x < $pagination['pages']; $x++)
	{
		array_push($pages,[
			'href'=>'/admin/users?'.http_build_query([
				'page'=>$x+1,
				'search'=>$search
			]),
			'text'=>$x+1
		]);
	}

	$page = new PageAdmin();

	$page->setTpl("users", array(
		"users"=>$pagination['data'],
		"search"=>$search,
		'pages'=>$pages
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

?> 
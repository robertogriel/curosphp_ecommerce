<?php 

require_once("vendor/autoload.php");

use \Slim\Slim;
use \Hcode\Page;
use \Hcode\PageAdmin;

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
    
	$page = new PageAdmin();

	$page->setTpl("index");

});
/* Chamando a Página de Administração (admin/index.html) */

$app->run();

 ?>
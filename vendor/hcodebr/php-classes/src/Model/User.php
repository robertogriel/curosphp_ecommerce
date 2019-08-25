<?php 

namespace Hcode\Model; //Onde está essa classe

use \Hcode\DB\Sql; //Usar a classe SQL que está na pasta DB
use \Hcode\Model;

class User extends Model
{
	const SESSION = "User";
	public static function login($login, $password) //Método estático que recebe o login e senha
	{
		$sql = new Sql(); //Instanciando a classe SQL

		$results = $sql->select("SELECT  * FROM tb_users WHERE deslogin = :LOGIN", // Chamo a query SQL e coloco na variavel $results
		array(
			":LOGIN"=>$login //Onde for :LOGIN vai ser a variavel $login
		));

		if (count($results) === 0) //Se o resultado da busca pela variavel $results for zero, irá dar erro
		{
			throw new \Exception("Usuário ou Senha Inválido"); 
			
		}

		$data = $results[0]; //O primeiro registro que encontrar na query $results vai para variavel $data

		if (password_verify($password, $data["despassword"]) === true) //Verifica a senha do que foi digitado com o que houver no DB
		{
			$user = new User(); //Se der certo, irá instanciar a classe

			$user->setData($data);

			$_SESSION[User::SESSION] = $user->getValues(); //Irá criar uma sessão com o valor retornado de getValues

			return $user;



		} else {
			throw new \Exception("Usuário ou Senha Inválido"); 
		}

	}

	public static function verifyLogin($inadmin = true) //Verificando se o usuário existe
	{

		if( //Se...
			!isset($_SESSION[User::SESSION]) //...existe a sessão definida
			|| //...ou...
			!$_SESSION[User::SESSION] //...se a sessão for falsa
			|| //...ou...
			!(int)$_SESSION[User::SESSION]["iduser"] > 0 //Transfomo o resultado em inteiro e pergunto se é maior que zero
			||//...ou...
			(bool)$_SESSION[User::SESSION]["inadmin"] !== $inadmin //se no DB o usuário está como admin
		) {

			header("Location: /admin/login"); //Envio de volta para a página de login
			exit; //Encerro o comando

		}

	}

	public static function logout()
	{
		$_SESSION[User::SESSION] == NULL;
	}

}

 ?>
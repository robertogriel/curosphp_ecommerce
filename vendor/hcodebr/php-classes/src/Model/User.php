<?php 

namespace Hcode\Model; //Onde está essa classe

use \Hcode\DB\Sql; //Usar a classe SQL que está na pasta DB
use \Hcode\Model;
use \Hcode\Mailer;

class User extends Model
{
	const SESSION = "User";

	const SECRET = "HcodePhp7_Secret";
	const SECRET_IV = "HcodePhp7_Secret_IV";

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
		$_SESSION[User::SESSION] == NULL; //Destroi a sessão se o usuário fizer logout
	}

	public static function listAll()
	{

		$sql = new Sql();
		return $sql->select("SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) ORDER BY b.desperson");
		//Lista os usuários do banco de dados e faz comparação de duas tabelas
	}

	public function get($iduser)
	{
	 
	 $sql = new Sql();
	 
	 $results = $sql->select("SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = :iduser;", array(
	 ":iduser"=>$iduser
	 ));
	 
	 $data = $results[0];
	 
	 $this->setData($data);
	 
	 }

	 public function save()
	 {

	 	$sql = new Sql();

	 	$results = $sql->select("CALL sp_users_save(:desperson, :deslogin, :despassword, :desemail, :nrphone, :inadmin)", array(
	 		":desperson"=>$this->getdesperson(),
	 		":deslogin"=>$this->getdeslogin(),
	 		":despassword"=>$this->getdespassword(),
	 		":desemail"=>$this->getdesemail(),
	 		":nrphone"=>$this->getnrphone(),
	 		":inadmin"=>$this->getinadmin()
	 	));

	 	$this->setData($results[0]);

	 }

	 public function update()
	 {

	 	$sql = new Sql();

	 	$results = $sql->select("CALL sp_usersupdate_save(:iduser, :desperson, :deslogin, :despassword, :desemail, :nrphone, :inadmin)", array(
	 		":iduser"=>$this->getiduser(),
	 		":desperson"=>$this->getdesperson(),
	 		":deslogin"=>$this->getdeslogin(),
	 		":despassword"=>$this->getdespassword(),
	 		":desemail"=>$this->getdesemail(),
	 		":nrphone"=>$this->getnrphone(),
	 		":inadmin"=>$this->getinadmin()
	 	));

	 	$this->setData($results[0]);

	 }

	 public function delete()
	 {

	 	$sql = new Sql();

	 	$sql->query("CALL sp_users_delete(:iduser)", array(
	 		":iduser"=>$this->getiduser()
	 	));

	 }

	 public static function getForgot($email) 
	 {

	 	$sql = new Sql();

	 	$results = $sql->select("
		SELECT *
		FROM tb_persons a
		INNER JOIN tb_users b USING(idperson)
		WHERE a.desemail = :email;
	 		", array(
	 			":email"=>$email
	 		));

	 	if (count($results) === 0)
	 	{
	 		throw new \Exception("Não foi possível recuperar a senha.", 1);
	 		
	 	} else {

	 		$data = $results[0];

	 		$results2 = $sql->select("CALL sp_userspasswordsrecoveries_create(:iduser, :desip)", array(
	 			":iduser"=>$data["iduser"],
	 			":desip"=>$_SERVER["REMOTE_ADDR"]
	 		));

	 		if (count($results2) === 0)
	 		{
	 			throw new \Exception("Não foi possível recuperar a senha", 2);
	 			
	 		} else {

				$dataRecovery = $results2[0];
				$code = openssl_encrypt(
					$dataRecovery['idrecovery'],
					'AES-128-CBC',
					pack("a16", User::SECRET),
					0,
					pack("a16", User::SECRET_IV));
					
					$code = base64_encode($code);

					$link = "http://www.hcodecommerce.com.br/admin/forgot/reset?code=$code";

					$mailer = new Mailer($data["desemail"], $data["desperson"], "Redefinir Senha da HCode Store", "forgot", 

					array(
						"name"=>$data["desperson"],
						"link"=>$link
					)

				);

				$mailer->send();

				return $data;

	 		}

	 	}

	 }

	public static function validForgotDecrypt($code)
	{
		$code = base64_decode($code);
		$idrecovery = openssl_decrypt($code, 'AES-128-CBC', pack("a16", User::SECRET), 0, pack("a16", User::SECRET_IV));
		$sql = new Sql();
		$results = $sql->select("
			SELECT *
			FROM tb_userspasswordsrecoveries a
			INNER JOIN tb_users b USING(iduser)
			INNER JOIN tb_persons c USING(idperson)
			WHERE
				a.idrecovery = :idrecovery
				AND
				a.dtrecovery IS NULL
				AND
				DATE_ADD(a.dtregister, INTERVAL 1 HOUR) >= NOW();
		", array(
			":idrecovery"=>$idrecovery
		));
		if (count($results) === 0)
		{
			throw new \Exception("Não foi possível recuperar a senha.");
		}
		else
		{
			return $results[0];
		}
	}


	public static function setForgotUsed($idrecovery)
	{

		$sql = new Sql();
		$sql->query("UPDATE tb_userspasswordsrecoveries SET dtrecovery = NOW() WHERE idrecovery = :idrecovery", array(
			":idrecovery"=>$idrecovery
		));

	}

	public function setPassword($password)
	{
		$sql = new Sql();

		$sql->query("UPDATE tb_users SET despassword = :password WHERE iduser = :iduser", array(
			":password"=>$password,
			":iduser"=>$this->getiduser()
		));
	}
}

 ?>
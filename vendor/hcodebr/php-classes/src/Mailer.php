<?php 

namespace Hcode;

use Rain\Tpl;

class Mailer
{

	const USERNAME = "cursophp@griel.com.br";
	const PASSWORD = "WoNjjRRcl8MD";
	const NAME_FROM = "Hcode Store";

	private $mail;


	public function __construct($toAddress, $toName, $subject, $tplName, $data = array())
	{

			$config = array
							(
							"tpl_dir"       => $_SERVER["DOCUMENT_ROOT"] . "/views/email/", //Pasta onde estão os arquivos html do projeto
							"cache_dir"     => $_SERVER["DOCUMENT_ROOT"] . "/views-cache/", //Pasta onde estão os caches
							"debug"         => false //Deixo como falso para não gerar debugs
							);

			Tpl::configure( $config );

			// create the Tpl object
			$tpl = new Tpl; //Criando um atributo para poder utilizar em outros locais

			foreach ($data as $key => $value) {
				$tpl->assign($key, $value);
			}

			$html = $tpl->draw($tplName, true);

	$this->mail = new \PHPMailer;
	//Tell PHPMailer to use SMTP
	$this->mail->isSMTP();

	//Enable SMTP debugging
	// 0 = off (for production use)
	// 1 = client messages
	// 2 = client and server messages
	$this->mail->SMTPDebug = 0;

	//Set the hostname of the mail server
	$this->mail->Host = 'mail.griel.com.br';
	//Set the SMTP port number - likely to be 25, 465 or 587
	$this->mail->Port = 587;
	//Whether to use SMTP authentication
	$this->mail->SMTPAuth = true;
	//Username to use for SMTP authentication
	$this->mail->Username = Mailer::USERNAME;
	//Password to use for SMTP authentication
	$this->mail->Password = Mailer::PASSWORD;
	//Set who the message is to be sent from
	$this->mail->setFrom(Mailer::USERNAME, Mailer::NAME_FROM);
	//Set an alternative reply-to address
	$this->mail->addReplyTo('cursophp@griel.com.br', 'Aula de PHP7');
	//Set who the message is to be sent to
	$this->mail->addAddress($toAddress, $toName);
	//Set the subject line
	$this->mail->Subject = $subject;
	//Read an HTML message body from an external file, convert referenced images to embedded,
	//convert HTML into a basic plain-text alternative body
	$this->mail->msgHTML($html);
	//Replace the plain text body with one created manually
	$this->mail->AltBody = 'Este é um exemplo de email';
	//Attach an image file
	//$mail->addAttachment('images/phpmailer_mini.png');
	//send the message, check for errors

}

	public function send()
	{

		return $this->mail->send();

	}
}

 ?>
<?php 

namespace Hcode;
//Especificando onde está a classe que eu preciso

use Rain\Tpl;
//Vamos usar a classe que está em outro namespace

class Page
{

		private $tpl;
		private $options = [];
		private $defaults = [
			"data"=>[] //Irá receber as variaveis para os templates
		];

		public function __construct($opts = array()) //Usando a base do exemplo do RainTPL
		{

			$this->options = array_merge($this->defaults, $opts); //O que for informado no __destruct sobrescreva o $default

			$config = array(
							"tpl_dir"       => $_SERVER["DOCUMENT_ROOT"] . "/views/",
							"cache_dir"     => $_SERVER["DOCUMENT_ROOT"] . "/views-cache/",
							"debug"         => false // set to false to improve the speed
						   );

			Tpl::configure( $config );

			// create the Tpl object
			$this->tpl = new Tpl; //Criando um atributo para poder utilizar em outros locais

			$this->setData($this->options["data"]);

			$this->tpl->draw("header");

		}

		private function setData($data = array()) //Atribuir as variaveis que irão aparecer no template
		{

			foreach ($data as $key => $value) {
				$this->tpl->assign($key, $value);
			}

		}

		public function setTpl($name, $data = array(), $returnHtml = false) 
		{

			$this->setData($data);

			return $this->tpl->draw($name, $returnHtml);

		}

		public function __destruct() 
		{

		$this->tpl->draw("footer");

		}

}

 ?>
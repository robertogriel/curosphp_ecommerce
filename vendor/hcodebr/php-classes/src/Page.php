<?php 

namespace Hcode;
//Especificando onde está a classe que eu preciso

use Rain\Tpl;
//Vamos usar a classe que está em outro namespace

class Page //Classe onde as configurações do template estão
{

		private $tpl; //Atributo que irá definir o template
		private $options = [];//Irá receber as variaveis para os templates
		private $defaults = [
			"data"=>[] 
		];

		public function __construct($opts = array()) //Usando a base do exemplo do RainTPL
		{

			$this->options = array_merge($this->defaults, $opts); //O que for informado no __destruct sobrescreva o $default

			$config = array
							(
							"tpl_dir"       => $_SERVER["DOCUMENT_ROOT"] . "/views/", //Pasta onde estão os arquivos html do projeto
							"cache_dir"     => $_SERVER["DOCUMENT_ROOT"] . "/views-cache/", //Pasta onde estão os caches
							"debug"         => false //Deixo como falso para não gerar debugs
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
						//Nome do Templete, Dados que vamos ter, Retornar HTML
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
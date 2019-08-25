<?php 

namespace Hcode;

class Model
{

	private $values = []; //Irá recuperar todos os dados do usuário

	public function __call($name, $args) //args é o valor que foi passado ao atributo
	{

		$method = substr($name, 0 , 3); //Irá contar da variavel $name, irá contar de 0 a 3 a quantidade de caracteres
		$fieldName = substr($name, 3, strlen($name)); //Irá contar da variavel $name a partir da posição 3 até a quantidade de caracteres que houver

		switch ($method)
		{
			case 'get':
				return $this->values[$fieldName];
				break;

			case 'set':
				$this->values[$fieldName] = $args[0];
				break;
			
			default:
				# code...
				break;
		}


	}
	//Criando geters e seters dinamicamente
	public function setData($data = array())
	{

		foreach ($data as $key => $value) {
			$this->{"set" . $key}($value);
		}

	}

	public function getValues() 
	{
		return $this->values;
	}

}

 ?>
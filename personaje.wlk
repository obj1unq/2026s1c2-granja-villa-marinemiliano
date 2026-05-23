import wollok.game.*
import cultivos.*
import direcciones.*
import granja.*



object hector {

	var property granjaDeHector = farmVille 
	var property position = game.center()
	const property image = "mplayer.png"

	const property cultivosSembrados = []
	const property cultivosCosechados = []  

	method mover(nuevaPosition){position = nuevaPosition.siguiente(position)}

    method sembrar(cultivo) {self.ponerCultivo(cultivo)}
	
	method regar() {  
	
		self.validarCultivo()
		self.regadio(self.obtenerCultivoAca())
	}

	method validarCultivo() {
	  
    	return if(not granjaDeHector.hayCultivoAca()) {
		
	    self.error("No tengo nada para hacer aca, parcela vacia")
	    //game.say(self,"No tengo nada para regar")
	  }
	}


	//EL ACTO DE SEMBRAR Y REGAR SE LE CONOCE COMO REGADIO
	method regadio(cultivo) {
	  
	  self.sacarCultivo(cultivo)
	  cultivo.madurar()
	  self.ponerCultivo(cultivo)
	  game.say(self, "REGUE!")
	}


	//DEVUELVE EL PRIMERO DE LA LISTA QUE ME TRAE COLLIDERS
	//COLLIDERS AL PASARLE EL GRANJERO (SELF), LO EXCEPTUA 
	//DIRECTAMENTE DE LA POSICION
	method obtenerCultivoAca(){
		
		//return game.colliders(self.cultivosSembrados().get(1))
		return game.colliders(self).first()	
	}

	method ponerCultivo(cultivo) {
	  
	   self.colocarCultivo(cultivo)
	   self.agregarCultivoSembrado(cultivo)
	   game.addVisual(cultivo) // Se agrega a modo de prueba
	}


	method agregarCultivoSembrado(cultivo) {
	  
	  cultivosSembrados.add(cultivo)  
	}


	method colocarCultivo(cultivo) {
	  
	   cultivo.position(self.position()) 
	}

	method sacarCultivo(cultivo) {

		cultivosSembrados.remove(cultivo)
		game.removeVisual(cultivo)
	}

	method cosechar() {self.validarCultivo()}


	//PROBAR PONIENDO EL MAIZ NO SOBRE HECTOR SINO AL LADO 
	// method sembrar(cultivo) 
	// {cultivo.ponerCultivoEn(game.at(self.position().x()+1,
	// 						        self.position().y()))}


	//SEGUNDA OPCION QUE TAMBIEN FUNCIONA 
	
	//method regar() {return  granjaDeHector.validarRiegoEn(self.position())}

	//method esCosechable() {return false}
}
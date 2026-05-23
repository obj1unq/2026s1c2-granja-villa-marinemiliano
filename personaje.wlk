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


	method ponerCultivo(cultivo) {
	  
	   cultivo.posicionarCultivoEn(self.position())
	   self.agregarCultivoSembrado(cultivo)
	   game.addVisual(cultivo) // Se agrega a modo de prueba
	}


	method regar() {  
	
		self.validarCultivo()
		self.regadio(self.obtenerCultivoDeLaPosicion())
	}

	method validarCultivo() {
	  
    	return if(not granjaDeHector.hayCultivoAca()) {
		
	    self.error("No puedo cosechar ni regar aca, parcela vacia")
	    //game.say(self,"No tengo nada para regar")
	  }
	}

	//AL ACTO DE REGAR LO SEMBRADO SE LO CONOCE COMO REGADIO
	method regadio(cultivo) {
	  
	  cultivo.madurar()
	  game.say(self, "REGUE!")
	}

	method obtenerCultivoDeLaPosicion(){
		
		//DIFERENTES FORMAS DE TRAERME EL CULTIVO QUE SE 
		//ENCUENTRA EN LA MISMA POSICION

		//return game.colliders(self.cultivosSembrados().get(1))
		//return game.colliders(self).first()
		  return game.uniqueCollider(self)
	}

	method agregarCultivoSembrado(cultivo) {cultivosSembrados.add(cultivo)}

	method sacarCultivo(cultivo) {

		cultivosSembrados.remove(cultivo)
		game.removeVisual(cultivo)
	}
	
	method cosechar() {
		
		self.validarCultivo()

		if(self.puedeCosechar(self.obtenerCultivoDeLaPosicion()))
		{
			
			self.cultivosCosechados()
			self.sacarCultivo(self.obtenerCultivoDeLaPosicion())	
		}
	}

	method puedeCosechar(cultivo) {return cultivo.soyCosechable(cultivo)}


	//PROBAR PONIENDO EL MAIZ NO SOBRE HECTOR SINO AL LADO 
	// method sembrar(cultivo) 
	// {cultivo.ponerCultivoEn(game.at(self.position().x()+1,
	// 						        self.position().y()))}


	//SEGUNDA OPCION QUE TAMBIEN FUNCIONA 
	
	//method regar() {return  granjaDeHector.validarRiegoEn(self.position())}

	//method esCosechable() {return false}
}
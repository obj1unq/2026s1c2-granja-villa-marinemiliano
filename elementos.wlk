import direcciones.*
import wollok.game.*
import personaje.*
import granja.*


class Maiz {

	var property position = game.center() 
	var property image  
	var property nombreElemento = "Maiz"

	var property granja = farmVille  

	method mensaje(visual,stringMensaje) {game.say(visual,stringMensaje)}
	method mensajeError(stringMensaje) {self.error(stringMensaje)}

	method posicionarElementoEn(nuevaPosicion) {self.position(nuevaPosicion)}

	method madurar() {image = "corn_adult.png"}

	method soyCosechable(cultivo) {return cultivo.image() ==  "corn_adult.png"}

	method precio() {return 150}

	//para respetar lo polimorfico
	method validarEspacio(mensaje,posicion) { }

}

class Trigo {
	
	var property position = game.center() 
	var property image  
	var property evolucion = 0
	var property nombreElemento = "Trigo"

	var property granja = farmVille  

	method mensaje(visual,stringMensaje) {game.say(visual,stringMensaje)}
	method mensajeError(stringMensaje) {self.error(stringMensaje)}

	method posicionarElementoEn(nuevaPosicion) {self.position(nuevaPosicion)}

	method madurar() {
		
		//CUANDO LLEGUE A 4 ME RETORNA 0 Y ARRANCA DE NUEVO
		evolucion = self.estadoActual(evolucion + 1) 	
		image = "wheat_" + self.evolucion() + ".png"
	}

	method estadoActual(numero) {
	  
	  return if (numero <= 3) {
		
			numero

	  } else {
					
		 	0
	  }
	}
	
	method soyCosechable(cultivo) {return self.evolucion() >= 2}

	method precio() {

		return if(self.evolucion() == 2) {
		  
			100
	
		} else if(self.evolucion() == 3) {
		   
		    200
		}
		else
		{

			//la cuenta cheta en definitiva termina dando
			//cero La cuenta cheta es (etapa - 1) * 100.
			0
		}
	}


	//para respetar lo polimorfico
	method validarEspacio(mensaje,posicion) { }
}


class Tomaco {

	var property position = game.at(1, 1) 
	var property image  
	var property nombreElemento = "Tomaco"

	var property granja = farmVille  

	method mensaje(visual,stringMensaje) {game.say(visual,stringMensaje)}
	method mensajeError(stringMensaje) {self.error(stringMensaje)}

	method posicionarElementoEn(nuevaPosicion) {self.position(nuevaPosicion)}

	method madurar() {
		
		if (self.position().y() == farmVille.alto()-1) {
		  
			//position = game.at(self.position().x(), 0)
			self.position(game.at(self.position().x(),0) )
			
			self.mensaje(self, "Teletransportacion!")

		} else {		  
		
			//tengo que validar antes que no haya un elemento arriba para 
			//asi si poder mover el tomate (o sea regarlo)
		    
			self.validarEspacio("no me puedo mover,hay algo",game.at(position.x(),position.y() + 1))
			
			self.position(arriba.siguiente(self.position()))						
		}
	}


	//ES EL TOMATE ACA QUIEN TIENE QUE PREGUNTARLE A LA GRANJA SI 
	//ESTA OCUPADA LA CELDA DE ARRIBA SUYO

	method validarEspacio(mensaje,posicion) {
	  
	  const nuevaPosicion = posicion
	  
      return if(granja.hayElementoEnPosicion(nuevaPosicion)) {
		
		  self.mensajeError(mensaje)
	  }
	}

	method soyCosechable(cultivo) {return true}

	method precio() {return 80}
}

class Aspersor {
  
  var property position = game.center() 
  var property image = "aspersor.png"
  var property nombreElemento = "Aspersor"

  var property granja = farmVille  

  method mensaje(visual,stringMensaje) {game.say(visual,stringMensaje)}
  method mensajeError(stringMensaje) {self.error(stringMensaje)}

  method posicionarElementoEn(nuevaPosicion) {self.position(nuevaPosicion)}
	
  method regar() {

     //game.onTick(3000,"riega celdas vecinas",{ self.moverAspersorAVecinas() })
	
     game.schedule(2000,{self.moverAspersorAVecinas()})
  }


  method moverAspersorAVecinas(){
	
	self.regarHacia(game.at(position.x() + 1,position.y()))
	self.irAPosicion(game.at(position.x() - 1,position.y()))

	self.regarHacia(game.at(position.x() - 1,position.y()))
	self.irAPosicion(game.at(position.x() + 1,position.y()))

	self.regarHacia(game.at(position.x(),position.y() + 1))
	self.irAPosicion(game.at(position.x(),position.y() - 1))

	self.regarHacia(game.at(position.x(),position.y()-1))
	self.irAPosicion(game.at(position.x(),position.y() + 1))

	//DIAGONALES

	self.regarHacia(game.at(position.x() + 1,position.y() - 1))
	self.irAPosicion(game.at(position.x()- 1,position.y() + 1))
	
	self.regarHacia(game.at(position.x() + 1,position.y() + 1))
	self.irAPosicion(game.at(position.x()- 1,position.y() - 1))
	
	self.regarHacia(game.at(position.x() - 1,position.y() - 1))
	self.irAPosicion(game.at(position.x()+ 1,position.y() + 1))
	
	self.regarHacia(game.at(position.x() - 1,position.y() + 1))
	self.irAPosicion(game.at(position.x()+ 1,position.y() - 1))
  }

					//direccion
  method regarHacia(nuevaPosicion) {

	position = nuevaPosicion
    //position = direccion.siguiente(self.position())
    self.regadio(self.cultivoEnLaPosicion())
  }

  method irAPosicion(nuevaPosicion) {
	
	position = nuevaPosicion
  }

   //AL ACTO DE REGAR LO SEMBRADO SE LO CONOCE COMO REGADIO
   method regadio(cultivo) {
	  
	  cultivo.madurar()
	  self.mensaje(self,"Regando " + cultivo.nombreElemento())
	}


	method cultivoEnLaPosicion(){
		
		//comprobe que tanto unique como colliders NO obtiene el objeto sino el visual, OJO ACA! 
		return game.uniqueCollider(self)
		
		//return game.colliders(self).first()
		
		//OTRAS DIFERENTES FORMAS DE TRAERME EL CULTIVO QUE SE 
		//ENCUENTRA EN LA MISMA POSICION

		//return game.colliders(self.cultivosSembrados().get(1))
	}


	method validarEspacio(mensaje,posicion) { }

}

class Mercado{

	var monedasParaAbonar = 10000

	method monedasParaAbonar() {return monedasParaAbonar}

	var property mercaderia = []

	method vender() {
	  
	  self.descontar(self.monedasParaAbonar())
	} 

	method descontar(monedasParaAbonar) {
	  
	  monedasParaAbonar = monedasParaAbonar - 
	} 

	method validarEspacio(mensaje,posicion) { }
}
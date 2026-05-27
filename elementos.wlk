import direcciones.*
import wollok.game.*
import personaje.*
import granja.*


class Maiz {

	var property position = game.center() 
	var property image  
	var property nombreElemento = "Maiz"

	var property granja = farmVille  

    method mensajeError(stringMensaje) {self.error(stringMensaje)}


	//MENSAJES PARAMETRIZADOS   
	const interprete = gameMock
	
	method hablar(_visual,stringMensaje) {game.say(_visual,stringMensaje)}

	method globosDeTexto(_visual,_mensaje) {interprete.say(_visual,_mensaje)} 
	
	method mensajePersonaje() {return interprete.mensajePersonaje()}
	

	method posicionarElementoEn(nuevaPosicion,elemento) {
		
		self.position(nuevaPosicion)
		game.addVisual(elemento) // Se agrega a modo de prueba	
	}

	method madurar() {image = "corn_adult.png"}

	method soyCosechable() {return self.image() ==  "corn_adult.png"}

	method precio() {return 150}

	//para respetar lo polimorfico
	method validarPosicion(mensaje,posicion) { }

    method soyMercado() {return false}
    
	method soyCultivo() {return true}

}

class Trigo {
	
	var property position = game.center() 
	var property image  
	var property evolucion = 0
	var property nombreElemento = "Trigo"

	var property granja = farmVille  

    method mensajeError(stringMensaje) {self.error(stringMensaje)}


	//MENSAJES PARAMETRIZADOS
    const interprete = gameMock
	
	method hablar(_visual,stringMensaje) {game.say(_visual,stringMensaje)}

	method globosDeTexto(_visual,_mensaje) {interprete.say(_visual,_mensaje)} 
	
	method mensajePersonaje() {return interprete.mensajePersonaje()}
	

	method posicionarElementoEn(nuevaPosicion,elemento) {
		
		self.position(nuevaPosicion)
		game.addVisual(elemento) // Se agrega a modo de prueba	
	}

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
	
	method soyCosechable() {return self.evolucion() >= 2}

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
	method validarPosicion(mensaje,posicion) { }

    method soyMercado() {return false}

	method soyCultivo() {return true}
}


class Tomaco {

	var property position = game.at(1, 1) 
	var property image  
	var property nombreElemento = "Tomaco"

	var property granja = farmVille  

	method mensajeError(stringMensaje) {self.error(stringMensaje)}

	
	//MENSAJES PARAMETRIZADOS

	const interprete = gameMock
		
	method hablar(_visual,stringMensaje) {game.say(_visual,stringMensaje)}

	method globosDeTexto(_visual,_mensaje) {interprete.say(_visual,_mensaje)} 


	method mensajePersonaje() {return interprete.mensajePersonaje()}
	
	method posicionarElementoEn(nuevaPosicion,elemento) {
		
		self.position(nuevaPosicion)
		game.addVisual(elemento) // Se agrega a modo de prueba	
	}

	method madurar() {
		
		if (self.position().y() == farmVille.alto()-1) {
		  
			//position = game.at(self.position().x(), 0)
			self.position(game.at(self.position().x(),0) )
						
			self.hablar(self,"teletransportacion!")
			
			//OFICIA DE TRADUCTOR PARA LOS GLOBOS DE TEXTO EN LO_ TEST
			self.globosDeTexto(self,"teletransportacion!")


		} else {		  
		
			//tengo que validar antes que no haya un elemento arriba para 
			//asi si poder mover el tomate (o sea regarlo)
		    
			self.validarPosicion("no me puedo mover hacia arriba,parcela ocupada.",
			
			game.at(position.x(),position.y() + 1))
			
			self.position(arriba.siguiente(self.position()))						
		}
	}


	//ES EL TOMATE ACA QUIEN TIENE QUE PREGUNTARLE A LA GRANJA SI 
	//ESTA OCUPADA LA CELDA DE ARRIBA SUYO

	method validarPosicion(mensaje,posicion) {
	  
	  const nuevaPosicion = posicion
	  
      return if(granja.hayElementoEnPosicion(nuevaPosicion)) {
		
		  self.mensajeError(mensaje)
	  }
	}

	method soyCosechable() {return true}

	method precio() {return 80}

    method soyMercado() {return false}

	method soyCultivo() {return true}
}

class Aspersor {
  
  var property position = game.center() 
  var property image = "aspersor.png"
  var property nombreElemento = "Aspersor"

  var property granja = farmVille  

  method mensajeError(stringMensaje) {self.error(stringMensaje)}

  
  //MENSAJES PARAMETRIZADOS

  const interprete = gameMock

  method hablar(_visual,stringMensaje) {game.say(_visual,stringMensaje)}

  method globosDeTexto(_visual,_mensaje) {interprete.say(_visual,_mensaje)} 

  method mensajePersonaje() {return interprete.mensajePersonaje()}
	

  method soyCosechable() {return false}
  
  method posicionarElementoEn(nuevaPosicion,elemento) {
		
		self.position(nuevaPosicion)
		game.addVisual(elemento) // Se agrega a modo de prueba	
  }
	
  method regar() {


     game.onTick(3000,"riega celdas vecinas",{self.moverAspersorAVecinas()})
     //game.schedule(2000,{self.moverAspersorAVecinas()})
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

  method irAPosicion(nuevaPosicion) {position = nuevaPosicion}

   //AL ACTO DE REGAR LO SEMBRADO SE LO CONOCE COMO REGADIO
   method regadio(cultivo) {
	  
		cultivo.madurar()
	
		self.hablar(self,"regando... " + cultivo.no_mbreElemento())
		
		self.globosDeTexto(self,"regando... " + cultivo.nombreElemento())
   }

   method cultivoEnLaPosicion(){
		
		// /method que tanto unique como colliders NO obtiene el objeto sino el visual, OJO ACA! 
		
		return game.uniqueCollider(self)
		
		//return game.colliders(self).first()
		
		//OTRAS DIFERENTES FORMAS DE TRAERME EL CULTIVO QUE SE 
		//ENCUENTRA EN LA MISMA POSICION

		//return game.colliders(self.cultivosSembrados().get(1))
	}


	method validarPosicion(mensaje,posicion) { }

    method soyMercado() {return false}

	method soyCultivo() {return false}
}

class Mercado{

   var property position 
   var property image = "market.png"
   var property nombreElemento = "Mercado"
   var property granja = farmVille  

   const property cultivosComprados = [] 

   method mensajeError(stringMensaje) {self.error(stringMensaje)}


   //MENSAJES PARAMETRIZADOS

    const interprete = gameMock

	method hablar(_visual,stringMensaje) {game.say(_visual,stringMensaje)}

	method globosDeTexto(_visual,_mensaje) {interprete.say(_visual,_mensaje)} 

	method mensajePersonaje() {return interprete.mensajePersonaje()}
	
    var property monedasParaAbonar 

    var pago = 0 

   method soyCosechable() {return false}

   var property mercaderia = []

   method transaccion(_cultivos,persona) {
		
		if (self.puedeComprarCultivos(self.sumarPreciosCultivos(_cultivos))) 
		{
		  
			self.agregarTodosLosCultivos(_cultivos)
			self.compra(_cultivos)	
			self.pagarA(persona)

		} else {
		  
			self.mensajeError("no tengo plata para comprar")
		
			//self.hablar(self,"no tengo plata para comprar")

			//PARA TEST	
			self.globosDeTexto(self,"no tengo plata para comprar")
		}
	} 

	method pagarA(persona) {
		
		persona.cobrar(pago)
		
		//LO REINICIO PARA UNA FUTURA TRANSACCION 
		pago = 0	
	}


	method puedeComprarCultivos(monedasADescontar) {
	  
	  return self.monedasParaAbonar() > monedasADescontar
	}


	method agregarTodosLosCultivos(_cultivos) {
	  		
	  _cultivos.forEach({unCultivo => self.agregarCultivo(unCultivo)})   
	}

	method agregarCultivo(_unCultivo) {cultivosComprados.add(_unCultivo)}


	method compra(_cultivos) {
	    
		pago = self.sumarPreciosCultivos(_cultivos)
		self.descontarPorCompra(self.sumarPreciosCultivos(_cultivos))
	}

	method descontarPorCompra(_dinero) {
		
	    monedasParaAbonar = monedasParaAbonar - _dinero
	} 

	method sumarPreciosCultivos(listaCosechados) {
		
		//ACUMULAR RESULTA CLAVE ACÁ PORQUE CUANDO VACÍO LA LISTA Y QUIERO COSECHAR DE NUEVO, SI NO HUBIERA UN ACUMULADOR, LA NUEVA COSECHA PISARÍA EL ORO RECIBIDO DE LA COSECHA ANTERIOR

		return listaCosechados.sum({cultivo => self.precioCultivo(cultivo)})
	}

	method precioCultivo(cultivo) {return cultivo.precio()}

	method validarPosicion(mensaje,posicion) { }

    method soyMercado() {return true}

	method soyCultivo() {return false}
}
import direcciones.*
import wollok.game.*
import personaje.*
import granja.*


class Maiz {

	var property position = game.center() 
	var property image = "corn_baby.png" 
	var property nombreElemento = "Maiz"

	var property granja = farmVille  	

	method posicionarElementoEn(_nuevaPosicion,_elemento) {
		
		self.position(_nuevaPosicion)
		game.addVisual(_elemento) // Se agrega a modo de prueba	
	}

	method madurar() {image = "corn_adult.png"}

	method precio() {return 150}

	method soyCosechable() {return self.image() ==  "corn_adult.png"}

	method soyMercado() {return false}
    
	method esCultivo() {return true}

}

class Trigo {
	
	var property position = game.center() 
	var property image = "wheat_0.png"
	
	var property evolucion = 0
	var property nombreElemento = "Trigo"

	var property granja = farmVille  

	method posicionarElementoEn(_nuevaPosicion,_elemento) {
		
		self.position(_nuevaPosicion)
		game.addVisual(_elemento) // Se agrega a modo de prueba	
	}

	method madurar() {
		
		//CUANDO LLEGUE A 4 ME RETORNA 0 Y ARRANCA DE NUEVO
		evolucion = self.estadoActual(evolucion + 1) 	
		image = "wheat_" + self.evolucion() + ".png"
	}

	method estadoActual(_numero) {
	  
	  return if (_numero <= 3) {
		
			_numero

	  } else {
					

			//LA CUENTA CHETA DARIA CERO 		
		 	0
	  }
	}
	

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
	
	method soyCosechable() {return self.evolucion() >= 2}

	method esCultivo() {return true}

    method soyMercado() {return false}

}


class Tomaco {

	var property position = game.at(1, 1) 
	var property image = "tomaco.png" 
	var property nombreElemento = "Tomaco"

	var property granja = farmVille  

	method mensajeError(_stringMensaje) {self.error(_stringMensaje)}

	
	//MENSAJES PARAMETRIZADOS

	const interprete = gameMock
		
	method hablar(_visual,_stringMensaje) {game.say(_visual,_stringMensaje)}

	method globosDeTexto(_visual,_mensaje) {interprete.say(_visual,_mensaje)} 


	method mensajePersonaje() {return interprete.mensajePersonaje()}
	
	method posicionarElementoEn(_nuevaPosicion,_elemento) {
		
		self.position(_nuevaPosicion)
		game.addVisual(_elemento) // Se agrega a modo de prueba	
	}

	method madurar() {
		
		if (self.position().y() == game.height()-1) {
		  
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
	method validarPosicion(_mensaje,_posicion) {
	  
	  const nuevaPosicion = _posicion
	  
      return if(granja.hayElementoEnPosicion(_posicion)) {
		
		  self.mensajeError(_mensaje)
	  }
	}


	method precio() {return 80}
	
	method soyCosechable() {return true}

    method soyMercado() {return false}

	method esCultivo() {return true}
}




class Aspersor {
  
  var property position = game.center() 
  var property image = "aspersor.png"
  var property nombreElemento = "Aspersor"

  var property granja = farmVille  

  method mensaje(_visual,_stringMensaje) {game.say(_visual,_stringMensaje)}
  method mensajeError(_stringMensaje) {self.error(_stringMensaje)}

  method posicionarElementoEn(_nuevaPosicion,_elemento) {
	
		self.irAPosicion(_nuevaPosicion)
		
		//self.position(_nuevaPosicion)
		//position = _nuevaPosicion	//self.irAPosicion(_nuevaPosicion)
		game.addVisual(_elemento) // Se agrega a modo de prueba	
   	
	}
	
  method correrSistemaDeRiego() {

     game.onTick(3000,"riega celdas vecinas",{ self.moverAspersorAVecinas() })

  }


  method moverAspersorAVecinas(){


	/* 
	   Creo que entiendo cuál es el error. Primero, estás haciéndolo 
	   de forma muy rara, estás moviendo el aspersor para verificar las colisiones, 
	   lo cual podrías simplificar mucho.


		Si querés seguir moviendo el aspersor, simplemente cambiá `cultivoEnLaPosicion()` para que use `game.colliders(self)`, para que te devuelva una lista y no te de error si está vacía, lo podrías filtrar con el `esCultivo()`, y también tendrías que cambiar `regarHacia(_nuevaPosicion)` para que llame `regadio()` sólo si se encontró posta un cultivo.

		Lo que yo haría, es añadir un método helper, algo onda `regarPosicion(_posicion)`, que directamente use `game.getObjectsIn(position)`, y así actualizás `moverAspersorAVecinas()` (también habría que cambiarle el nombre xd) para que use ese `regarPosicion()`
	
	
	   Para solucionar esto, te recomiendo hacer la verificación 
	   de las posiciones lindantes manteniendo el aspersor en su lugar,
	   creando un método auxiliar "regarPosicion(_posicion)",
	   usando game.getObjectsIn(_posicion.
	
	


	   No te voy a mentir, este método está bastante feo. 
	   Estás repitiendo demasiado código.

		
       Lo ideal sería que reemplaces todos los regarHacia y 
	   irAPosicion por un par de regarPosicion(game.at(x, y)) 
	*/
	
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
  method regarHacia(_nuevaPosicion) {

	self.irAPosicion(_nuevaPosicion)

	//position = _nuevaPosicion

    self.regadio(self.cultivoEnLaPosicion())
  }

    method regar() {  
	
		return if(granja.elementoQueCompartePosicionCon(self).esCultivo()) {


		 	self.regadio(granja.elementoQueCompartePosicionCon(self))
		}
		else
		{}

		// return if (not granja.tieneElementoAcaAdemasDe(self) ) {
		  
		// 	//self.hablar(self,"imposible regar aqui!,parcela vacia")		

		// 	//MENSAJE PARA TEST, OFICIA COMO INTERPRETE
		// 	//self.globosDeTexto(self,"imposible regar aqui!,parcela vacia")

		// } 
		// else if(self.esCultivo(granja.elementoQueCompartePosicionCon(self))) {


		// 	self.regadio(granja.elementoQueCompartePosicionCon(self))
		// }
		// else {

		// 	//self.hablar(self,"imposible regar aqui! esto no es un cultivo")
			
		// 	//MENSAJE PARA TEST, OFICIA COMO INTERPRETE
		// 	//self.globosDeTexto(self,"imposible regar aqui! esto no es un cultivo")

		// }

	}


  	method irAPosicion(_nuevaPosicion) {
	
		position = _nuevaPosicion
  	}

   //AL ACTO DE REGAR LO SEMBRADO SE LO CONOCE COMO REGADIO
   method regadio(_cultivo) {
	  
	  _cultivo.madurar()
	  self.mensaje(self,"Regando " + _cultivo.nombreElemento())
	}


	method cultivoEnLaPosicion(){
		
		//comprobe que tanto unique como colliders NO obtiene el objeto sino el visual, OJO ACA! 
		return game.uniqueCollider(self)
		
		//return game.colliders(self).first()
		
		//OTRAS DIFERENTES FORMAS DE TRAERME EL CULTIVO QUE SE 
		//ENCUENTRA EN LA MISMA POSICION

		//return game.colliders(self.cultivosSembrados().get(1))
	}


	method validarEspacio(_mensaje,_posicion) {
	  
	  const _nuevaPosicion = _posicion
	  
      return if(granja.hayElementoEnPosicion(_nuevaPosicion)) {
		
		self.mensajeError(_mensaje)
	  }
	}

	method esCultivo() {return false}

	method soyCosechable() {return false}
	
    method soyMercado() {return true}
}




// class Aspersor {
  
//   var property position = game.center() 
//   var property image = "aspersor.png"
//   var property nombreElemento = "Aspersor"

//   var property granja = farmVille  

//   method mensajeError(stringMensaje) {self.error(stringMensaje)}

  
//   //MENSAJES PARAMETRIZADOS

//   const interprete = gameMock

//   method hablar(_visual,stringMensaje) {game.say(_visual,stringMensaje)}

//   method globosDeTexto(_visual,_mensaje) {interprete.say(_visual,_mensaje)} 

//   method mensajePersonaje() {return interprete.mensajePersonaje()}
	
  
//   method posicionarElementoEn(nuevaPosicion,elemento) {

// 		position = nuevaPosicion
// 		//self.irAPosicion(nuevaPosicion)
// 		game.addVisual(elemento) // Se agrega a modo de prueba	
//   }
	
//   method correrSistemaDeRiego() {

// 	 //self.moverAspersorAVecinas()
//     const posicionOriginal = self.position()

// 	 game.onTick(1000,"riega celdas vecinas",{self.irAPosicion(game.at(position.x() + 1,position.y()))})

// 	 //self.regadio(granja.elementoQueCompartePosicionCon(self))
     
// 	 game.onTick(1000,"riega celdas vecinas",{self.irAPosicion(posicionOriginal)})
     
// 	 //game.schedule(2000,{self.moverAspersorAVecinas()})

//   }


//   method moverAspersorAVecinas(){
	
// 				//ES EL QUE AGREGUE EN PONER ELEMENTO EN EL OBJETO PERSONAJE 
						 
// 	const posicionOriginal = self.position()

// 	self.irAPosicion(game.at(posicionOriginal.x() + 1,posicionOriginal.y()))
	
// 	//self.irAPosicion(game.at(position.x() + 1,position.y() ) )

// 	self.regadio(granja.elementoQueCompartePosicionCon(self))
	
// 	//VUELVE A SU POSICION ORIGINAL PARA MANTENER SU EJE
// 	//self.irAPosicion(game.at(position.x(), position.y()))
	
// 	self.irAPosicion(posicionOriginal)


// 	//  self.regarHacia(game.at(position.x() + 1,position.y()))
// 	//  self.irAPosicion(game.at(position.x() - 1,position.y()))


// 	// self.regarHacia(game.at(position.x() - 1,position.y()))
// 	// self.irAPosicion(game.at(position.x() + 1,position.y()))

// 	// self.regarHacia(game.at(position.x(),position.y() + 1))
// 	// self.irAPosicion(game.at(position.x(),position.y() - 1))

// 	// self.regarHacia(game.at(position.x(),position.y()-1))
// 	// self.irAPosicion(game.at(position.x(),position.y() + 1))

// 	// //DIAGONALES

// 	// self.regarHacia(game.at(position.x() + 1,position.y() - 1))
// 	// self.irAPosicion(game.at(position.x()- 1,position.y() + 1))
	
// 	// self.regarHacia(game.at(position.x() + 1,position.y() + 1))
// 	// self.irAPosicion(game.at(position.x()- 1,position.y() - 1))
	
// 	// self.regarHacia(game.at(position.x() - 1,position.y() - 1))
// 	// self.irAPosicion(game.at(position.x()+ 1,position.y() + 1))
	
// 	// self.regarHacia(game.at(position.x() - 1,position.y() + 1))
// 	// self.irAPosicion(game.at(position.x()+ 1,position.y() - 1))

//   }

//   //AL ACTO DE REGAR LO SEMBRADO SE LO CONOCE COMO REGADIO
//    method regadio(cultivo) {
	  
// 	  cultivo.madurar()
  
// 	}


//    method irAPosicion(nuevaPosicion) {
	
// 	position = nuevaPosicion}

// 					//direccion

//   method regarHacia(nuevaPosicion) {

// 	self.irAPosicion(nuevaPosicion)

// 	self.regadio(granja.elementoQueCompartePosicionCon(self))

//   }

//   method regar() {  
	

// 		self.regadio(granja.elementoQueCompartePosicionCon(self))

// 		// return if(self.esCultivo(granja.elementoQueCompartePosicionCon(self))) {


// 		//  	self.regadio(granja.elementoQueCompartePosicionCon(self))
// 		// }

// 		// return if (not granja.tieneElementoAcaAdemasDe(self) ) {
		  
// 		// 	//self.hablar(self,"imposible regar aqui!,parcela vacia")		

// 		// 	//MENSAJE PARA TEST, OFICIA COMO INTERPRETE
// 		// 	//self.globosDeTexto(self,"imposible regar aqui!,parcela vacia")

// 		// } 
// 		// else if(self.esCultivo(granja.elementoQueCompartePosicionCon(self))) {


// 		// 	self.regadio(granja.elementoQueCompartePosicionCon(self))
// 		// }
// 		// else {

// 		// 	//self.hablar(self,"imposible regar aqui! esto no es un cultivo")
			
// 		// 	//MENSAJE PARA TEST, OFICIA COMO INTERPRETE
// 		// 	//self.globosDeTexto(self,"imposible regar aqui! esto no es un cultivo")

// 		// }
// 	}


// }

class Mercado{

   var property position 
   var property image = "market.png"
   var property nombreElemento = "Mercado"
   var property granja = farmVille  

   const property cultivosComprados = [] 

   method mensajeError(_stringMensaje) {self.error(_stringMensaje)}


   //MENSAJES PARAMETRIZADOS

    const interprete = gameMock

	method hablar(_visual,_stringMensaje) {game.say(_visual,_stringMensaje)}

	method globosDeTexto(_visual,_mensaje) {interprete.say(_visual,_mensaje)} 

	method mensajePersonaje() {return interprete.mensajePersonaje()}
	
    var property monedasParaAbonar 


   var property mercaderia = []

   method transaccion(_cultivos,_persona) {
		
   		var dineroAPagar = 0 
		
		if (self.puedeComprarCultivos(self.sumarPreciosCultivos(_cultivos))) 
		{
		  
			self.agregarTodosLosCultivos(_cultivos)
			
			//ESTO LO CAMBIE PORQUE AL PONER EL PAGO COMO LOCAL DE TRANSACCION NO PODIA
			//USARLO EN COBRAR ENTONCES ESTA ASIGNACION LA MANDE ACA Y PASO EL DINERO
			//A PAGAR POR PARAMETRO
			
			dineroAPagar = self.sumarPreciosCultivos(_cultivos)
			
			self.compra(_cultivos)	
			self.pagarA(_persona,dineroAPagar)

		} else {
		  
			self.mensajeError("no tengo plata para comprar")
		
			//self.hablar(self,"no tengo plata para comprar")

			//PARA TEST	
			self.globosDeTexto(self,"no tengo plata para comprar")
		}
	} 

	method pagarA(_persona,dinero) {
		
		_persona.cobrar(dinero)	
	}


	method puedeComprarCultivos(_monedasADescontar) {
	  
	  return self.monedasParaAbonar() > _monedasADescontar
	}


	method agregarTodosLosCultivos(_cultivos) {
	  		
	  _cultivos.forEach({_unCultivo => self.agregarCultivo(_unCultivo)})   
	}

	method agregarCultivo(_unCultivo) {cultivosComprados.add(_unCultivo)}


	method compra(_cultivos) {
	    
		self.descontarPorCompra(self.sumarPreciosCultivos(_cultivos))
	}

	method descontarPorCompra(_dinero) {
		
	    monedasParaAbonar = monedasParaAbonar - _dinero
	} 

	method sumarPreciosCultivos(_listaCosechados) {
		
		//ACUMULAR RESULTA CLAVE ACÁ PORQUE CUANDO VACÍO LA LISTA Y QUIERO COSECHAR DE NUEVO, SI NO HUBIERA UN ACUMULADOR, LA NUEVA COSECHA PISARÍA EL ORO RECIBIDO DE LA COSECHA ANTERIOR

		return _listaCosechados.sum({_cultivo => self.precioCultivo(_cultivo)})
	}

	method precioCultivo(_cultivo) {return _cultivo.precio()}

	method soyCosechable() {return false}

    method soyMercado() {return true}

	method esCultivo() {return false}
}
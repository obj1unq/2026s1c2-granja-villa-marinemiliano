import wollok.game.*
import elementos.*
import direcciones.*
import granja.*



object hector {

	var property granja = farmVille 
	var property position = game.center()
	const property image = "mplayer.png"
	
	const property cultivosSembrados = []
	const property cultivosCosechados = []

	//OJO PRECALCULO ACA. CREO QUE ASI ES CORRECTO
	var oroRecibido = 0
	

	//MOVIMIENTO DEL PERSONAJE

	method mover(nuevaPosition){position = nuevaPosition.siguiente(position)}


	//MENSAJES PARAMETRIZADOS

	method mensaje(visual,stringMensaje) {game.say(visual,stringMensaje)}

	method mensajeError(stringMensaje) {self.error(stringMensaje)}


	//SEMBRAR

    method sembrar(cultivo) {
		
		self.ponerElemento(cultivo,"Sembrando ")

		self.cultivosSembrados().add(cultivo)	
	}

	
	    //todos los metodos respondian al nombre de cultivo pero cuando se 
		//agrego aspersor tuve que generalizar y cambiar a que hector agrega "elementos"


	method ponerElemento(elemento,mensaje) {
	  
	   elemento.posicionarElementoEn(self.position())
	
	   game.addVisual(elemento) // Se agrega a modo de prueba
	
	   self.mensaje(self, mensaje + elemento.nombreElemento())
	}


	//REGAR

	method regar() {  
	

		self.validarEspacio("no puedo regar, parcela vacia")


		//como al validar ya se que personaje y un cultivo estan en la misma
		//parcela, con la funcion que le paso a regadio obtengo el cultivo que
		//se encuentra en esa posicion


		self.regadio(self.cultivoEnLaPosicion())
	}


	method validarEspacio(mensaje) {
	  
    	return if(not granja.hayElementoAca()) {
		
			//self.mensajeError(mensaje)
			game.say(self,mensaje)
		}
	}


	//AL ACTO DE REGAR LO SEMBRADO SE LO CONOCE COMO REGADIO
	
	method regadio(cultivo) {


	  cultivo.madurar()

	  self.mensaje(self,"Regando " + cultivo.nombreElemento())

	}

	method cultivoEnLaPosicion(){	
 
		//me consigo el cultivo que se encuentra en la misma posicion

		return game.uniqueCollider(self)
		

		//OTRAS DIFERENTES FORMAS DE TRAERME EL CULTIVO QUE SE 
		//ENCUENTRA EN LA MISMA POSICION

		//return game.colliders(self.cultivosSembrados().get(1))
	
		//return game.colliders(self).first()
	}

	//COSECHAR

	method cosechar() {
		
		self.validarEspacio("no puedo cosechar,parcela vacia")

		if(self.puedeCosechar(self.cultivoEnLaPosicion()))
		{

			self.agregarCultivoCosechado(self.cultivoEnLaPosicion())
			
			self.mensaje(self,"Coseche " 
							+ self.nombreCultivoEnPosicion() + "! " +
									 " Tocá la letra v para venderlo")

			self.sacarCultivoCosechado(self.cultivoEnLaPosicion())
			
		}
		else{

			self.mensaje(self,"este cultivo no es cosechable todavia!")
		}
	}


	method nombreCultivoEnPosicion() {return self.cultivoEnLaPosicion().nombreElemento()}


	method agregarCultivoCosechado(cultivo){cultivosCosechados.add(cultivo)}


	method sacarCultivoCosechado(cultivo) {game.removeVisual(cultivo)}


	method puedeCosechar(cultivo) {return cultivo.soyCosechable(cultivo)}


	
   //VENTA


	method vender() {
	  
	  self.validarListaCosechados()
	  
	  self.validarPuntoDeVenta()

	  self.sumarPreciosCultivos(self.cultivosCosechados())
	 
	  

	  self.vaciarLista(self.cultivosCosechados())

	  self.mensaje(self,"Todo vendido!")
	 
	}   

	method validarListaCosechados() {
	  
	  if (self.cultivosCosechados().isEmpty()) {
		
			self.mensajeError("no hay cultivos para vender")
	  }
	}

	method sumarPreciosCultivos(listaCosechados) {
	  
		//ACUMULAR RESULTA CLAVE ACÁ PORQUE CUANDO VACÍO LA LISTA Y QUIERO COSECHAR DE NUEVO, SI NO HUBIERA UN ACUMULADOR, LA NUEVA COSECHA PISARÍA EL ORO RECIBIDO DE LA COSECHA ANTERIOR

		oroRecibido += listaCosechados.sum
							({cultivo => self.precioCultivo(cultivo)})
	}


	method precioCultivo(cultivo) {return cultivo.precio()}


	//generica vacia cualquier lista
	method vaciarLista(lista) {lista.clear()}



	//ESTADO CONTABLE

	method estadoContable() {
	  
	  self.mensaje(self, "tengo " + self.cantidadPlantas() + " para vender. " +
	  		   " recaudacion por ventas: " + self.oroRecibido() + " monedas" )
	}

	method cantidadPlantas() {return self.cultivosCosechados().size()}

	method oroRecibido() {return oroRecibido}



	//BONUS ASPERSORES

	method ponerAspersor(unAspersor) {

		self.validarEspacioLleno("celda ocupada,no puedo poner aspersor")
		
		self.ponerElemento(unAspersor,"Coloqué ") 
		
		unAspersor.regar()
	}


	method validarEspacioLleno(mensaje) {
	  
      return if(granja.hayElementoAca()) {
		
		self.mensajeError(mensaje)
	  }
	}
	

	//PROBAR PONIENDO EL MAIZ NO SOBRE HECTOR SINO AL LADO 
	// method sembrar(cultivo) 
	// {cultivo.ponerCultivoEn(game.at(self.position().x()+1,
	// 						        self.position().y()))}


	//SEGUNDA OPCION QUE TAMBIEN FUNCIONA 
	
	//method regar() {return  granja.validarRiegoEn(self.position())}

	//method esCosechable() {return false}
}
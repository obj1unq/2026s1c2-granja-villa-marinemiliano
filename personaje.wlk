import wollok.game.*
import cultivos.*
import direcciones.*
import granja.*



object hector {

	var property granjaDeHector = farmVille 
	var property position = game.center()
	const property image = "mplayer.png"
	//const property cultivosSembrados = []
	const property cultivosCosechados = []

	//OJO PRECALCULO ACA. CREO QUE ASI ES CORRECTO
	var oroRecibido = 0
	method oroRecibido() {return oroRecibido}

	method mover(nuevaPosition){position = nuevaPosition.siguiente(position)}

	method mensaje(visual,stringMensaje) {game.say(visual,stringMensaje)}

	method mensajeError(stringMensaje) {self.error(stringMensaje)}


	//SEMBRAR

    method sembrar(cultivo) {self.ponerCultivo(cultivo)}

	method ponerCultivo(cultivo) {
	  
	   cultivo.posicionarCultivoEn(self.position())
	   //self.agregarCultivoSembrado(cultivo)
	   game.addVisual(cultivo) // Se agrega a modo de prueba
	   self.mensaje(self,"Sembrando " + cultivo.nombreCultivo())
	}


	//REGAR

	method regar() {  
	
		self.validarCultivo("no puedo regar, parcela vacia")
		self.regadio(self.cultivoEnLaPosicion())
	}

	method validarCultivo(mensaje) {
	  
    	return if(not granjaDeHector.hayCultivoAca()) {
		
		self.mensajeError(mensaje)
	    //game.say(self,"No tengo nada para regar")
	  }
	}

	//AL ACTO DE REGAR LO SEMBRADO SE LO CONOCE COMO REGADIO
	method regadio(cultivo) {
	  
	  cultivo.madurar()
	  self.mensaje(self,"Regando " + cultivo.nombreCultivo())
	}

	method cultivoEnLaPosicion(){
		

		//comprobe que tanto unique como colliders NO obtiene el objeto sino el visual, OJO ACA! 
		return game.uniqueCollider(self)
		
		//return game.colliders(self).first()
		

		//OTRAS DIFERENTES FORMAS DE TRAERME EL CULTIVO QUE SE 
		//ENCUENTRA EN LA MISMA POSICION

		//return game.colliders(self.cultivosSembrados().get(1))

	}


	//COSECHAR

	method cosechar() {
		
		self.validarCultivo("no puedo cosechar,parcela vacia")

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

	method nombreCultivoEnPosicion() {
	  
	  return self.cultivoEnLaPosicion().nombreCultivo()
	}

	method agregarCultivoCosechado(cultivo){cultivosCosechados.add(cultivo)}

	method sacarCultivoCosechado(cultivo) {

		game.removeVisual(cultivo)
	}

	method puedeCosechar(cultivo) {return cultivo.soyCosechable(cultivo)}

	method estadoContable() {
	  
	  self.mensaje(self, "tengo " + self.cantidadPlantas() + " para vender. " +
	  		   " recaudacion por ventas: " + self.oroRecibido() + " monedas" )
	}

   //VENTA

	method cantidadPlantas() {
	  
		return self.cultivosCosechados().size()
	}

	method vender() {
	  
	  self.validarListaCosechados()
	  self.sumarPreciosCultivos(self.cultivosCosechados())
	  self.mensaje(self,"Todo vendido!")
	  self.vaciarLista(self.cultivosCosechados())
	}   

	//generica vacia cualquier lista
	method vaciarLista(lista) {lista.clear()}

	method sumarPreciosCultivos(listaCosechados) {
	  
		//ACUMULAR RESULTA CLAVE ACÁ PORQUE CUANDO VACÍO LA LISTA Y QUIERO COSECHAR DE NUEVO, SI NO HUBIERA UN ACUMULADOR, LA NUEVA COSECHA PISARÍA EL ORO RECIBIDO DE LA COSECHA ANTERIOR

		oroRecibido += listaCosechados.sum
							({cultivo => self.precioCultivo(cultivo)})
	}

	method precioCultivo(cultivo) {return cultivo.precio()}

	method validarListaCosechados() {
	  
	  if (self.cultivosCosechados().isEmpty()) {
		
		self.mensajeError("no hay cultivos para vender")
	  }
	}

	//PROBAR PONIENDO EL MAIZ NO SOBRE HECTOR SINO AL LADO 
	// method sembrar(cultivo) 
	// {cultivo.ponerCultivoEn(game.at(self.position().x()+1,
	// 						        self.position().y()))}


	//SEGUNDA OPCION QUE TAMBIEN FUNCIONA 
	
	//method regar() {return  granjaDeHector.validarRiegoEn(self.position())}

	//method esCosechable() {return false}
}
import wollok.game.*
import elementos.*
import direcciones.*
import granja.*

object gameMock {
	  
	   var property mensajePersonaje = null

	   method say(visual,mensaje) {
		 
		 mensajePersonaje = mensaje
	   } 
}


object hector {

	var property granja = farmVille 
	var property position = game.center()
	const property image = "mplayer.png"
	
	const property cultivosSembrados = []
	const property cultivosCosechados = []
	
	const interprete = gameMock

	//OJO PRECALCULO ACA. CREO QUE ASI ES CORRECTO
	var oroRecibido = 0
	
	//MOVIMIENTO DEL PERSONAJE
	method mover(nuevaPosition){position = nuevaPosition.siguiente(position)}


	//MENSAJES PARAMETRIZADOS

	method hablar(visual,stringMensaje) {game.say(visual,stringMensaje)}

	method globosDeTexto(_visual,_mensaje) {interprete.say(_visual,_mensaje)} 

	method mensajePersonaje() {return interprete.mensajePersonaje()}
	

	//METODOS GENERICOS

	//generica vacia cualquier lista
	method vaciarLista(lista) {lista.clear()}

	method ponerElemento(elemento) {
	  
	   elemento.posicionarElementoEn(self.position(),elemento)
	}


	//CUANDO APARECIO EL MERCADO TENGO QUE PREGUNTARLE A CADA ELEMENTO SI LO ES

	method soyMercado() {return false}

	method soyCultivo() {return false}

	method soyCosechable() {return false}

	//SEMBRAR

    method sembrar(_cultivo) {


		//SI LA GRANJA NO TIENE UN ELEMENTO JUNTO CON HECTOR (SELF) ENTONCES ES PARCELA VACIA Y PUEDE SEMBRAR
		if (not granja.tieneElementoAcaAdemasDe(self)) {
		  
			self.ponerElemento(_cultivo)
		
			self.hablar(self, "sembrando... " + _cultivo.nombreElemento())
			
			//OFICIA DE TRADUCTOR PARA LOS GLOBOS DE TEXTO EN LOS TEST
			self.globosDeTexto(self, "sembrando... " + _cultivo.nombreElemento())

			self.cultivosSembrados().add(_cultivo)	

		} else {


			self.hablar(self,"imposible sembrar aqui! parcela ocupada ")

			//OFICIA DE TRADUCTOR PARA LOS GLOBOS DE TEXTO EN LOS TEST
			self.globosDeTexto(self,"imposible sembrar aqui! parcela ocupada ")
		}
	}


	//REGAR

	method regar() {  
	
		return if (not granja.tieneElementoAcaAdemasDe(self) ) {
		  

			self.hablar(self,"imposible regar aqui!,parcela vacia")		

			//MENSAJE PARA TEST, OFICIA COMO INTERPRETE
			self.globosDeTexto(self,"imposible regar aqui!,parcela vacia")

		} 
		else if(self.esCultivo(granja.elementoQueCompartePosicionCon(self))) {


			self.regadio(granja.elementoQueCompartePosicionCon(self))
		}
		else {

			self.hablar(self,"imposible regar aqui! esto no es un cultivo")
			
			//MENSAJE PARA TEST, OFICIA COMO INTERPRETE
			self.globosDeTexto(self,"imposible regar aqui! esto no es un cultivo")

		}
	}


	method esCultivo(_elemento) {return _elemento.soyCultivo()}


	//AL ACTO DE REGAR LO SEMBRADO SE LO CONOCE COMO REGADIO
	
	method regadio(_cultivo) {


	  _cultivo.madurar()

	  self.hablar(self,"regando... " + _cultivo.nombreElemento())

	  //PARA TEST 
	  self.globosDeTexto(self,"regando... " + _cultivo.nombreElemento())

	}


	method cosechar() {
		
		return if (not granja.tieneElementoAcaAdemasDe(self)) {

			  
		  self.hablar(self,"imposible cosechar aquí!,parcela vacía")

		  //MENSAJE PARA TEST, OFICIA COMO INTERPRETE
		  self.globosDeTexto(self,"imposible cosechar aquí!,parcela vacía")   		
		
		}
		else if(self.puedeCosechar(granja.elementoQueCompartePosicionCon(self)))
		{

			// return if(self.puedeCosechar(granja.elementoQueCompartePosicionCon(self)))
			// {

				self.agregarCultivoCosechado(granja.elementoQueCompartePosicionCon(self))
				
				self.hablar(self,"coseché! " 
								+ self.nombreElementoEnLaPosicion() + "! " +
										"ve al mercado, vendelo presionando la v")



	self.globosDeTexto(self,"coseché! " + self.nombreElementoEnLaPosicion() + " ve al mercado, vendelo presionando la v")


				self.sacarCultivoCosechado(granja.elementoQueCompartePosicionCon(self))
			//}
		}
		else
		{

			self.hablar(self,"Este " + self.nombreElementoEnLaPosicion() + " no es cosechable! tenes que regar con la letra r")


			self.globosDeTexto(self,"Este " + self.nombreElementoEnLaPosicion() + " no es cosechable! tenes que regar con la letra r")

		}
	}


	method puedeCosechar(_elemento) {return _elemento.soyCosechable()}

	method nombreElementoEnLaPosicion() {return granja.elementoQueCompartePosicionCon(self).nombreElemento()}

	method agregarCultivoCosechado(_cultivo){cultivosCosechados.add(_cultivo)}

	method sacarCultivoCosechado(_cultivo) {game.removeVisual(_cultivo)}


	
   //VENTA

	method vender() {
	  
		return if (not granja.tieneElementoAcaAdemasDe(self)) {

				self.hablar(self,"imposible vender algo!,no existe mercado en la parcela")

				self.globosDeTexto(self,"imposible vender algo!,no existe mercado en la parcela")

		} 
		else if(granja.hayMercadoAca(self.position())) {


		   if(self.cultivosCosechados().isEmpty())
		   {

				self.hablar(self,"imposible vender! granero vacío tenes que cosechar")
			
				self.globosDeTexto(self,"imposible vender! granero vacío tenes que cosechar")
		   }
		   else
		   {
				//AL HABERLO VALIDADO yo se que hay UN MERCADO COMPARTIENDO LUGAR CON
				//HECTOR, ME TRAIGO AL MERCADO EN "elementoQueCompartePosicionCon"self

				granja.elementoQueCompartePosicionCon(self).transaccion(self.cultivosCosechados(),self)	  

				self.vaciarLista(self.cultivosCosechados())

				self.hablar(self,"Todo vendido!")

				self.globosDeTexto(self,"Todo vendido!")
		   }
		
		}
			  
	}   


	method cobrar(dinero) {oroRecibido += dinero}

	//ESTADO CONTABLE

	method estadoContable() {
	  
	  self.hablar(self, "tengo " + self.cantidadCultivosCosechados() + " para vender. " + " recaudacion por ventas: " + self.oroRecibido() + " monedas" )

	  self.globosDeTexto(self, "tengo " + self.cantidadCultivosCosechados() + " para vender. " + " recaudacion por ventas: " + self.oroRecibido() + " monedas" )

	}


	method verSembrados() {
	  
	  self.hablar(self, "tengo " + self.cantCultivosSembrados() + " cultivos para cosechar.")

	  self.globosDeTexto(self, "tengo " + self.cantCultivosSembrados() + " cultivos para cosechar.")
	}

	method cantCultivosSembrados() {return self.cultivosSembrados().size()}


	method cantidadCultivosCosechados() {return self.cultivosCosechados().size()}

	
	method oroRecibido() {return oroRecibido}


	//BONUS ASPERSORES

	method ponerAspersor(unAspersor) {

		if (granja.tieneElementoAcaAdemasDe(self)) {
		  
			self.hablar(self,"imposible poner aspersor aquí!, celda ocupada")

			self.globosDeTexto(self,"imposible poner aspersor aquí!, celda ocupada")

		} else {
		  
			self.ponerElemento(unAspersor) 
		
			self.hablar(self, "colocando... " + self.nombreElementoEnLaPosicion())

											//unAspersor.nombreElemento()

			self.globosDeTexto(self, "colocando... " + self.nombreElementoEnLaPosicion())

			unAspersor.regar()	
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
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


	//METODOS GENERICOS

	//generica vacia cualquier lista
	method vaciarLista(lista) {lista.clear()}

	method ponerElemento(elemento) {
	  
	   elemento.posicionarElementoEn(self.position(),elemento)
	}


	//CUANDO APARECIO EL MERCADO TENGO QUE PREGUNTARLE A CADA ELEMENTO SI LO ES

	method soyMercado() {return false}

	//SEMBRAR

    method sembrar(_cultivo) {


		//SI LA GRANJA NO TIENE UN ELEMENTO JUNTO CON HECTOR (SELF) ENTONCES ES PARCELA VACIA Y PUEDE SEMBRAR
		if (not granja.tieneElementoAcaAdemasDe(self)) {
		  
			self.ponerElemento(_cultivo)
		
			self.mensaje(self, "Sembrando " + _cultivo.nombreElemento())

			self.cultivosSembrados().add(_cultivo)	

		} else {


			self.mensaje(self,"imposible sembrar aqui! parcela ocupada ")
		}
	}
	

	//REGAR

	method regar() {  
	
		if (not granja.tieneElementoAcaAdemasDe(self)) {
		  

			self.mensaje(self,"no puedo regar aqui!, parcela vacia")		

		} else {


			self.regadio(granja.elementoQueCompartePosicionCon(self))
		}
	}


	//AL ACTO DE REGAR LO SEMBRADO SE LO CONOCE COMO REGADIO
	
	method regadio(_cultivo) {


	  _cultivo.madurar()

	  self.mensaje(self,"Regando " + _cultivo.nombreElemento())
	}


	method cosechar() {
		
		return if (not granja.tieneElementoAcaAdemasDe(self)) {

			  
			  self.mensaje(self,"no puedo cosechar aquí!,parcela vacia")		
		
		}
		else if(self.puedeCosechar(granja.elementoQueCompartePosicionCon(self)))
		{

			// return if(self.puedeCosechar(granja.elementoQueCompartePosicionCon(self)))
			// {

				self.agregarCultivoCosechado(granja.elementoQueCompartePosicionCon(self))
				
				self.mensaje(self,"Coseche " 
								+ self.nombreElementoEnLaPosicion() + "! " +
										" Tocá la letra v para venderlo")

				self.sacarCultivoCosechado(granja.elementoQueCompartePosicionCon(self))
			//}
		}
		else
		{

			self.mensaje(self,"Este " + self.nombreElementoEnLaPosicion() + " no es cosechable todavia!")
			
		}
	}


	method puedeCosechar(_cultivo) {return _cultivo.soyCosechable(_cultivo)}

	method nombreElementoEnLaPosicion() {return granja.elementoQueCompartePosicionCon(self).nombreElemento()}

	method agregarCultivoCosechado(_cultivo){cultivosCosechados.add(_cultivo)}

	method sacarCultivoCosechado(_cultivo) {game.removeVisual(_cultivo)}


	
   //VENTA

	method vender() {
	  
		return if (not granja.tieneElementoAcaAdemasDe(self)) {

			self.mensaje(self,"no existe un mercado en la parcela")

		} 
		else if(self.cultivosCosechados().isEmpty())
		{

			self.mensaje(self,"no hay cultivos para vender")
		
		}
		else if(granja.hayMercadoAca(self.position())) {


			//AL HABERLO VALIDADO yo se que hay UN MERCADO COMPARTIENDO LUGAR CON
			//HECTOR, ME TRAIGO AL MERCADO EN "elementoQueCompartePosicionCon"self

			granja.elementoQueCompartePosicionCon(self).transaccion(self.cultivosCosechados(),self)	  

			self.vaciarLista(self.cultivosCosechados())

			self.mensaje(self,"Todo vendido!")
		
		}
			  
	}   


	method cobrar(dinero) {oroRecibido += dinero}

	//ESTADO CONTABLE

	method estadoContable() {
	  
	  self.mensaje(self, "tengo " + self.cantidadCultivosCosechados() + " para vender. " +
	  		   " recaudacion por ventas: " + self.oroRecibido() + " monedas" )
	}


	method verSembrados() {
	  
	  self.mensaje(self, "tengo " + self.cantCultivosSembrados() + " cultivos para cosechar.")
	}

	method cantCultivosSembrados() {return self.cultivosSembrados().size()}


	method cantidadCultivosCosechados() {return self.cultivosCosechados().size()}

	
	method oroRecibido() {return oroRecibido}


	//BONUS ASPERSORES

	method ponerAspersor(unAspersor) {

		if (granja.tieneElementoAcaAdemasDe(self)) {
		  
			self.mensaje(self,"no puedo poner aspersor aquí!, celda ocupada")

		} else {
		  
			self.ponerElemento(unAspersor) 
		
			self.mensaje(self, "Coloqué " + self.nombreElementoEnLaPosicion())

											//unAspersor.nombreElemento()

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
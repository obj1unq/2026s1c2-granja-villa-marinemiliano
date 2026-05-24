import direcciones.*
import wollok.game.*
import personaje.*
import granja.*


class Maiz {

	var property position = game.center() 
	var property image  
	var property nombreCultivo = "Maiz"

	method mensaje(visual,stringMensaje) {game.say(visual,stringMensaje)}

	method posicionarCultivoEn(nuevaPosicion) {self.position(nuevaPosicion)}

	method madurar() {image = "corn_adult.png"}

	method crecerCultivo(cultivo) { }

	method soyCosechable(cultivo) {
	
	   return cultivo.image() ==  "corn_adult.png"
	}

	method precio() {return 150}
}

class Trigo {
	
	var property position = game.center() 
	var property image  
	var property evolucion = 0
	var property nombreCultivo = "Trigo"

	method mensaje(visual,stringMensaje) {game.say(visual,stringMensaje)}
	
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

	method posicionarCultivoEn(nuevaPosicion) {self.position(nuevaPosicion)}
	
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
}


class Tomaco {

	var property position = game.at(1, 1) 
	var property image  
	var property nombreCultivo = "Tomaco"

	method mensaje(visual,stringMensaje) {game.say(visual,stringMensaje)}

	method madurar() {
		
		if (self.position().y() == farmVille.alto()-1) {
		  
			//position = game.at(self.position().x(), 0)
			self.position(game.at(self.position().x(),0) )
			self.mensaje(self, "Teletransportacion!")

		} else {
		  
			self.position(arriba.siguiente(self.position()))			
			//position = nuevaPosicion
		}
	}

	method posicionarCultivoEn(nuevaPosicion) {
		
		self.position(nuevaPosicion)
	}

	method soyCosechable(cultivo) {return true}

	method precio() {return 80}

}


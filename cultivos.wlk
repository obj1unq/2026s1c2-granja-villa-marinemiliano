import direcciones.*
import wollok.game.*
import personaje.*
import granja.*


class Maiz {

	var property position = game.center() 
	var property image  

	method posicionarCultivoEn(nuevaPosicion) {self.position(nuevaPosicion)}

	method madurar() {image = "corn_adult.png"}

	method crecerCultivo(cultivo) { }

	method soyCosechable(cultivo) {
	
	   return cultivo.image() ==  "corn_adult.png"
	}
}

class Trigo {
	
	var property position = game.center() 
	var property image  
	var property evolucion = 0
	
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
}


class Tomaco {

	var property position = game.at(1, 1) 
	var property image  

	method madurar() {
		
		if (self.position().y() == farmVille.alto()-1) {
		  
			//position = game.at(self.position().x(), 0)
			self.position(game.at(self.position().x(),0) )

		} else {
		  
			
			self.position(arriba.siguiente(self.position()))			
			//position = nuevaPosicion
		}
	}

	method posicionarCultivoEn(nuevaPosicion) {
		
		self.position(nuevaPosicion)
	}

	method soyCosechable(cultivo) {return true}
}


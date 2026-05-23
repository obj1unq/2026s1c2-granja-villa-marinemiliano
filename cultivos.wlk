import wollok.game.*
import personaje.*


class Maiz {

	var property position = game.center() 
	var property image  

	method madurar() {image = "corn_adult.png"}

	method crecerCultivo(cultivo) { }

	//method esCosechable() {return  true}
}

class Trigo {
	
	var property position = game.center() 
	var property image  

	method madurar() {image = "wheat_1.png"}

	//method esCosechable() {return  true}
}


class Tomaco {

	var property position = game.at(1, 1) 
	var property image  

	method madurar() {image = "tomaco.png"}
	
	//method esCosechable() {return  true}
}
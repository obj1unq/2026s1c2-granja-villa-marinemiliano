import wollok.game.*
import personaje.*


object farmVille{


    //MENSAJES PARAMETRIZADOS   
	const interprete = gameMock
	
	method hablar(_visual,_stringMensaje) {game.say(_visual,_stringMensaje)}

	method globosDeTexto(_visual,_mensaje) {interprete.say(_visual,_mensaje)} 
	
	method mensajePersonaje() {return interprete.mensajePersonaje()}
	
    
    const mapa = [
        [_, _, _, _, _, _, _, _, _, _ ],
        [_, _, _, _, _, _, _, _, _, _ ],
        [_, _, _, _, _, _, _, _, _, _ ],
        [_, _, _, _, _, _, _, _, _, _ ],
        [_, _, _, _, _, _, _, _, _, _ ],
        [_, _, _, _, _, _, _, _, _, _ ],
        [_, _, _, _, _, _, _, _, _, _ ]
    ].reverse()

    method alto() {

        return mapa.size()
    }
    method ancho() {

        return mapa.anyOne().size()
    }

    method dibujarMapa() {
        
        game.height(self.alto())
        game.width(self.ancho())

        (0 .. self.ancho() -1).forEach({ x =>
            (0 .. self.alto() -1).forEach({y =>
                 self.dibujarCelda(x,y)
            })
        })
    
        // game.addVisual(pepita) //Lo agrego al final para que siempre esté arriba
    }

    method dibujarCelda(x,y) {

        const dibujante = mapa.get(y).get(x)
        dibujante.dibujar(game.at(x,y))
    }

    method validarDentro(_position) {
        if (not self.dentro(_position)) {
            self.error(_position.toString() + " no está dentro del tablero ")
        }
    }

    method dentro(_position) {
        return _position.x().between(0, game.width() -1) and _position.y().between(0, game.height() -1 )
    }

	method esCultivo() {return false}

    method soyMercado() {return false}

    method soyCosechable() {return false}
    

    method hayMercadoAca(_posicion) {
      
      return game.getObjectsIn(_posicion).any({ o => o.soyMercado() })
    }

    
    //esta evalua si hay un objeto en la celda donde tambien esta 
    //el elemento pasado por parametro
    method tieneElementoAcaAdemasDe(_elemento) {
        
        return not game.colliders(_elemento).isEmpty()
        //return game.colliders(self.granjero()).size() > 0
        //return game.colliders(hector).size() > 0
    }


    //esta va y evalua si en tal posicion hay algun objeto
    //la tuve que incorporar en el problema del tomate cuando
    //se riega y tiene que verificar si ya hay un cultivo arriba suyo
    method hayElementoEnPosicion(_nuevaPosicion) {
    
      return not game.getObjectsIn(_nuevaPosicion).isEmpty()
    }


    method elementoQueCompartePosicionCon(_elemento){	
 
		//me consigo el elemento que se encuentra en la misma posicion

		return game.uniqueCollider(_elemento)
		

		//OTRAS DIFERENTES FORMAS DE TRAERME EL CULTIVO QUE SE 
		//ENCUENTRA EN LA MISMA POSICION

		//return game.colliders(self.cultivosSembrados().get(1))
	
		//return game.colliders(self).first()
	}

}

    //SEGUNDA OPCION QUE TAMBIEN FUNCIONA

    /*
    method validarRiegoEn(posicion) {
	  
	  return if (not self.hayCultivoAca(posicion)) {
		
	      granjero.error("No tengo nada para regar")
	     //game.say(granjero,"No tengo nada para regar")
	  }
	}

    method hayCultivoAca(posicion) {
        
      return game.getObjectsIn(posicion).any({obj => obj.esCosechable()})        
    }
    */


object m {
  
  method dibujar() {
    
  }
}

object _{
    method dibujar(posicion) {

    }


}



// object m {
//     method dibujar(posicion) {
//         game.addVisual(new Muro(position=posicion))   
//     }
// }
// object n {
//     method dibujar(posicion) {
//         nido.position(posicion)
//         game.addVisual(nido)
//     }
// }
// object p {
//     method dibujar(posicion) {
//         pepita.position(posicion)
//     }    
// }

// object s {
//     method dibujar(posicion) {
//         game.addVisual(silvestre)
//     }    
// }


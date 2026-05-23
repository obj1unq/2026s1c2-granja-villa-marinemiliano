import wollok.game.*
import personaje.*


object farmVille{

    var property granjero = hector

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

    method validarDentro(position) {
        if (not self.dentro(position)) {
            self.error(position.toString() + " no está dentro del tablero ")
        }
    }

    method dentro(position) {
        return position.x().between(0, game.width() -1) and position.y().between(0, game.height() -1 )
    }
    
    method hayCultivoAca() {
        
        return not game.colliders(self.granjero()).isEmpty()
        //return game.colliders(self.granjero()).size() > 0
        //return game.colliders(hector).size() > 0
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


import granja.*


object arriba {

    method siguiente(position) {
        const nueva = position.up(1) 
        farmVille.validarDentro(nueva)
        return nueva
    }
}


object abajo {
    
    method siguiente(position) {
        const nueva = position.down(1) 
        farmVille.validarDentro(nueva)
        return nueva
    }
}

object derecha {

    method siguiente(position) {
        const nueva = position.right(1) 
        farmVille.validarDentro(nueva)
        return nueva
    }
}

object izquierda{

    method siguiente(position) {
        const nueva = position.left(1) 
        farmVille.validarDentro(nueva)
        return nueva
    }

}

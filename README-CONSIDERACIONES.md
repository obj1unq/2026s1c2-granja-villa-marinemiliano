

 A NIVEL QUE EL EJERCICIO IBA ESCALANDO ES QUE SUFRIO VARIAS MODIFICACIONES.

 En los cultivos tengo la problemática de "qué pasaría si un tomate es regado y justo arriba hay un elemento", para ello incluí un método en el cual el tomate que conoce a la granja le consulta si puede moverse hacia arriba
 

 Esto forzó a polimorfizar todos los cultivos a los cuales le agregué "validarEspacio" a pesar de que solo en tomaco lo usa. Este acccionar no se si es correcto, yo en alguun lado había leído que no hace falta polimorfizar todo si es que no se va a usar.



 OBJETO FARMAVILLE - DOS METODOS QUE A SIMPLE VISTA PARECEN REPETIDOS PERO QUE NO LO SON 
 

 los metodos en cuestión son tieneElementoAcaAdemasDe, hayElementoEnPosicion


 Al principio del proyecto cuando solo había que chequear si había un objeto en la misma posición que Hector para para saber si podía regar, cosechar etc. la utilización del método "hay elemento aca" me fue muy útil 


 El problema surgió al tener que evaluar la posiciones lindantes a un elemento en cuestión, ahí ya no me servía el primer modelo porque en ese método siempre compara los elementos que hay en la posición


 Esto me vio obligado a pensar con que método se podía resolver la consulta sobre "espacios vacíos (o no) aledaños al tomate  y al aspersor". Para tal caso utilicé un metodo que uso en la granja: "hay elemento en posicion" en donde la granja recibe  una posición y devuelve si la misma se encuentra ocupada.    


 COSAS QUE ME QUEDARON POR RESOLVER SOBRE ESTE TEMA

 Dicha evolución del modelo también me lleva a pensar en la situación de que ese nuevo método tiene que ser capaz de evaluar elemento (tomate o aspersor) con su posición lindante. O sea "moverlos" y preguntar ¿"comparten posición con otro elemento para regarlo? (en el caso del aspersor)

 También pensé en delegar todo esto a la la utilización de objetos invisibles que se encarguen de evaluar posiciones, objetos etc,pero no llegué quedó solo en una idea teórica.

 
 SEGUNDA COSA QUE ME QUEDO SIN RESOLVER

  El riego funciona bien si por ejemplo se coloca trigo alrededor del aspersor en todas sus posiciones lindantes,(tanto vecinas ortogonales como

  sus diagonales). Los problemas surgen cuando no se colocan en todas las posiciones y solo en algunas, ahí el aspersor comienza a moverse y a fallar.

  Por falta de tiempo es que no logré solucionarlo.  







 

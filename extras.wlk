// import pepita.*
// import randomizer.*
// object silvestre {
//     const presa = pepita
//     method image() {
//         return "silvestre.png"
//     }
//     method position() {
//         return game.at(3.max(presa.position().x()), 0)
//     }

//     method atravesable() { 
//         return true 
//     }

//     method interactuar(personaje) {
//         personaje.perder()
//     }
// }

// object nido {

//     var property position = game.at(9,9)

//     method image() {
//         return "nido.png"
//     }

//     method atravesable() { 
//         return true 
//     }
//     method interactuar(personaje) {
//         personaje.ganar()
//     }

// }

// object alpisteFactory {
//     method crear() {
//         return new Alpiste(position=randomizer.emptyPosition(), peso=(40..100).anyOne())  
//     }
// }

// object manzanaFactory {
//     method crear() {
//         return new Manzana(position=randomizer.emptyPosition())  
//     }
// }

// object alimentos {

//     const factories = [
//             manzanaFactory,
//             alpisteFactory 
//     ]

//     const alimentosEnTablero = #{}

//     method aparecerSiFalta() {
//         if(self.tieneQueAparecer()) {
//             const alimento = self.construirNuevoAlimento()
//             game.addVisual(alimento)
//             alimentosEnTablero.add(alimento)
//         }
//     }

//     method construirNuevoAlimento() {
    
//         return factories.anyOne().crear()
//     }

//     method remover(alimento) {
//         alimentosEnTablero.remove(alimento)
//         game.removeVisual(alimento)
//     }

//     method tieneQueAparecer() {
//         return self.cantidadAlimentos() < 3
//     }

//     method cantidadAlimentos() {
//         return alimentosEnTablero.size()
//     }


// }
// class Alpiste {

//     const property position = game.at(8,8)

//     method image() = "alpiste.png"
//     const peso = 20


//     method energiaQueAporta() {
//         return peso
//     }

//     method atravesable() { 
//         return true 
//     }

//     method interactuar(personaje) {
//         personaje.comerVisual(self)
//     }


// }

// class Manzana {

//     const property position = game.at(2,6)

//     method image() = "manzana.png"



//     method energiaQueAporta() {
//         return 30 //TODO poner el algoritmo del primer ejercicio
//     }

//     method atravesable() { 
//         return true 
//     }

//     method interactuar(personaje) {
//         personaje.comerVisual(self)
//     }

// }

// class Muro {

//     const property position = game.at(4,4)

//     method image() = "muro.png"

//     method atravesable() { 
//         return false 
//     }


// }


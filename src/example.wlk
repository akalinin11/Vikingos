class Vikingo{
	
	var property castaSocial    // esclavos - media - nobles 
	var armas 
	var oro
	
	method esProductivo()
	
	method validarCastaSocial(){
		if(self.castaSocial().puedesubirAExpedicion(self)){
			throw new DomainException(message = "El esclavo tiene armas")
			}
		}	
	
	method tenerArmas()= armas > 0	
	
	
	//ESTO SE ENCARGA LA EXPEDICION
	method subirseAExpedicion(expedicion){
		
		if(not self.esProductivo()){
				throw new DomainException(message = "No pude subir, no es productivo")
			}
			else{
				
				expedicion.aniadirVikingo(self)
			}			
	}
	
	
	method ascenderCastaSocial(){
		self.castaSocial().ascender(self)
	}	
	
	method recompensa()
	
	method conseguirOro(cantOro){
		oro+= cantOro
	}
}

class Soldado inherits Vikingo{
	

	var property vidasCobradas
	
	override method esProductivo(){
		
		self.validarCastaSocial()  // No va fijarse despues
		
		return self.vidasCobradas() > 20 and self.tenerArmas()
			
			}

	override method recompensa(){ //nombre poco declarativo, es mejor poner recompensas
		armas += 10
	}			
}


class Granjero inherits Vikingo {
	
	var cantidadHijos
	var hectareas 
	

	override method esProductivo(){
		self.validarCastaSocial()
		
		return cantidadHijos*2 <= hectareas
	
			}		
	
	override method ascenderCastaSocial(){
		self.castaSocial().ascender(self)
	}	
	
	override method recompensa(){
		cantidadHijos+=2
		hectareas +=2	
		}
	
	}	

// CLASES SOCIALES DE LOS VIKINGOS
object esclavo{
	
	method puedesubirAExpedicion(vikingo){
		return not vikingo.tieneArmas()
	}
	
	method ascender(vikingo){
		
		vikingo.castaSocial(media)
		vikingo.recompensa()
	}
}

object media{
	
	method puedesubirAExpedicion(vikingo){
		return true
	}
	
	method ascender(vikingo){
		vikingo.castaSocial(noble)
	}
}

object noble{
	
	method puedesubirAExpedicion(vikingo){
		return true
	}
	
	method ascender(vikingo){
		
	}
}


// EXPEDCIONES, CAPITALES y ALDEAS
class Expedicion{
	
	var capitales = #{}
	var aldeas = #{}
	var vikingosABordo = #{}
	var objetivos= capitales+aldeas
	
	method aniadirVikingo(vikingo){
			vikingosABordo.add(vikingo)
	}
	
	method valeLaPena()= self.valeLaPenaCapital() and self.valeLaPenaAldea()
	
	method valeLaPenaCapital() = capitales.all({capital => capital.valePenaBotin(vikingosABordo.sizeof())})
	
	method valeLaPenaAldea()= aldeas.all({aldea => aldea.valePenaBotin(vikingosABordo.sizeof())})
	
	
	// HACER UNA LISTA DE OBJETIVO 
	method realizarExpedicion(){
		
		//PIERDO POLIMORFISMO
		capitales.forEach({capital => capital.producirEfecto(vikingosABordo.sizeof())}) 
		aldeas.forEach({aldea => aldea.producirEfecto()})
		vikingosABordo.forEach({vikingo =>  vikingo.conseguirOro( self.oroGanadoXVikingo() )})
		
		
	}

	method calcularOroExpedicion(){
		
		return  capitales.map({capital => capital.oroPerdido()}).sum() + aldeas.map({aldea => aldea.oroPerdido()}).sum()
	}
	
	// capitales.sum({capital=>capital.oroPerdido()}) = Todo el oro de las capitales
	
	method oroGanadoXVikingo() = self.calcularOroExpedicion() / vikingosABordo.sizeof()
}

class Capitales{
	var defensoresCapital
	var factorRiqueza
	
	method valePenaBotin(cantidadVikingos){
		return self.botin(cantidadVikingos) >= 3* cantidadVikingos
		}
	
	method botin(cantVikingos){
		return cantVikingos*factorRiqueza
	}	
	
	method producirEfecto(cantidad){
		defensoresCapital -= cantidad
		
	}
	
	method oroPerdido(cantidadVikingos){
		
		return self.botin(cantidadVikingos)
	}
	
	}

class Aldeas{
	
	var crucifijos 
	
	method valePenaBotin(cantidadVikingos){
		
			return self.botin() >= 15
		}
		
	method botin() = crucifijos
	
	method producirEfecto(){
			crucifijos= 0
	}
	
	method oroPerdido(cantidadVikingos){
			return self.botin()
	}
	
}

class AldeasAmuralladas inherits Aldeas{
	
	const cantidadMinimaDeVikingos 	
	
	override method valePenaBotin(cantidadVikingos){
		return super(cantidadVikingos) and cantidadVikingos >= cantidadMinimaDeVikingos
	}
}
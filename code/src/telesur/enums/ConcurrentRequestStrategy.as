package telesur.enums
{
	// Enumeración que contiene las distintas estrategias que utilizar en el API en caso de peticiones concurrentes
	public class ConcurrentRequestStrategy
	{
		//Niega la petición actual. Lanza un FaultEvent para la nueva petición. Es la opción por defecto.
		public static const DENEGAR:String = "Denegar";
		
		//Cancela la petición actual y lanza la nueva. No manda evento de error al cancelar la petición actual.
		public static const CANCELAR:String = "Cancelar";
		
		//Encola las peticiones, lanzandolas una detrás de otra conforme se vayan completando.		
		public static const ENCOLAR:String = "Encolar";
		
		public function ConcurrentRequestStrategy()
		{
		}
	}
}
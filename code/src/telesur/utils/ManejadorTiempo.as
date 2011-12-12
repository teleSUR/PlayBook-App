package telesur.utils
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import telesur.data.GeoNamesAPI;

	public class ManejadorTiempo
	{
		private static const MSECX5MIN:uint = 1000 * 60 * 5;
		private static const MSECXHORA:uint = 1000 * 60  * 60;
		private static const MSECXDIA:uint = 1000 * 60  * 60 * 24;
		private static const MSECXSEM:uint = 1000 * 60  * 60 * 24 * 7;
		private static const MSECXMES:uint = 1000 * 60  * 60 * 24 * 30;
		private static const MSECXANIO:uint = 1000 * 60  * 60 * 24 * 365;
		
		private static var _startTime:Number = 0;
		private static var _apiTime:Number = 0;
		
		private static function get Now():Number {
			var now:Date = new Date();
			
			if ( ManejadorTiempo._apiTime > 0 ) {
				return ManejadorTiempo._apiTime + (now.getTime() - ManejadorTiempo._startTime);
			} else {
				return now.getTime();	
			}
		}
		
		public function ManejadorTiempo()
		{
		}
		
		public static function Timestamp(timestamp:String):String {
			if ( ! timestamp ) {
				return ManejadorRecursos.localizarCadena("HaceError");
			}
			
			var tiempoTranscurrido:Number = ManejadorTiempo.Now - ManejadorTiempo.parseTime(timestamp);
			
			var returnString:String = "Hace";
			
			if ( tiempoTranscurrido >= MSECXANIO ) {
				//Un año o más
				var anios:uint = Math.floor(tiempoTranscurrido/ MSECXANIO);
				var meses:uint = Math.floor( (tiempoTranscurrido - anios * MSECXANIO) / MSECXMES );
				
				if ( anios > 1 ) {
					returnString += "Anios";
				} else {
					returnString += "Anio";
				}
				
				if ( meses > 0 ) {
					if ( meses > 1 ) {
						returnString += "Meses";
					} else {
						returnString += "Mes";	
					}
					
					returnString = ManejadorRecursos.localizarCadena(returnString).replace("<Anios>", anios.toString()).replace("<Meses>",meses.toString());
				} else {
					returnString = ManejadorRecursos.localizarCadena(returnString).replace("<Anios>", anios.toString());
				}
				
			} else if ( tiempoTranscurrido > MSECXMES ) {
				var mesess:uint = Math.floor(tiempoTranscurrido / MSECXMES);

				if ( mesess > 1 ) {
					returnString += "Meses";
				} else {
					returnString += "Mes";
				}
				
				returnString = ManejadorRecursos.localizarCadena(returnString).replace("<Meses>", mesess.toString());
				
			} else if ( tiempoTranscurrido > MSECXSEM ) {
				var sem:uint = Math.floor(tiempoTranscurrido / MSECXSEM);

				if ( sem > 1 ) {
					returnString += "Semanas";
				} else {
					returnString += "Semana";
				}
				
				returnString = ManejadorRecursos.localizarCadena(returnString).replace("<Semanas>",sem.toString());
				
			} else if ( tiempoTranscurrido > MSECXDIA ) {
				var dia:uint = Math.floor(tiempoTranscurrido / MSECXDIA);
				
				if ( dia > 1 ) {
					returnString += "Dias";
				} else {
					returnString += "Dia";
				}
				
				returnString = ManejadorRecursos.localizarCadena(returnString).replace("<Dias>",dia.toString());

			} else if ( tiempoTranscurrido > MSECXHORA ) {
				var hora:uint = Math.floor(tiempoTranscurrido / MSECXHORA);

				if ( hora > 1 ) {
					returnString += "Horas";
				} else {
					returnString += "Hora";
				}
				
				returnString = ManejadorRecursos.localizarCadena(returnString).replace("<Horas>",hora.toString());
				
			} else if ( tiempoTranscurrido > MSECX5MIN) {
				var minutos:uint = 5 * Math.floor(tiempoTranscurrido / MSECX5MIN);
				returnString += "Minutos";
				
				returnString = ManejadorRecursos.localizarCadena(returnString).replace("<Minutos>",minutos.toString());

			} else {
				
				returnString += "Ahora";
				
				returnString = ManejadorRecursos.localizarCadena(returnString);
			}
			return returnString;
		}
		
		public static function Duracion(timestamp:String):String {
			if ( ! timestamp ) {
				return ManejadorRecursos.localizarCadena("TimeStampError");
			}
			
			var timeParts:Array = timestamp.split(":",3);
			var horas:Number = Number(timeParts[0]);
			var mins:Number = Number(timeParts[1]);
			var secs:Number = Number(timeParts[2]);
			
			if ( mins >= 28 ) {
				var minPart:Number = Math.round(mins / 30);
				return (minPart * 30).toString() + ":00";
			} else {
				return (mins > 9 ? "" : "0") + mins.toString() + ":" + (secs > 9 ? "" : "0") + secs.toString();
			}
		}
		
		public static function Fecha(timestamp:String):String {
			var fecha:Date = ManejadorTiempo.parseDate(timestamp);
			
			return ManejadorRecursos.localizarCadena("InformacionFecha")
				.replace("<Dia>", fecha.date.toString())
				.replace("<Mes>", ManejadorRecursos.localizarCadena("Mes" + fecha.month.toString()))
				.replace("<Anio>", fecha.fullYear.toString());
		}
		
		public static function iniciar():void {
			ManejadorTiempo._startTime = (new Date()).time;
			var api:GeoNamesAPI = new GeoNamesAPI( ManejadorRecursos.configString("GeoNamesAPI_Username") );
			api.getTimezone(ManejadorRecursos.configNumber("GeoNamesAPI_BaseLatitude"), ManejadorRecursos.configNumber("GeoNamesAPI_BaseLongitude"),ManejadorTiempo.onGetTimeResult,ManejadorTiempo.onGetTimeFault);
		}
		
		private static function onGetTimeResult(event:ResultEvent):void {
			ManejadorTiempo._apiTime = ManejadorTiempo.parseTime( event.result["time"] ); 
			DEBUG::time {
				trace("ManejadorTiempo> Hora Local:", new Date(ManejadorTiempo._startTime), " / Hora remota:", new Date(ManejadorTiempo._apiTime));
			}
		}
		
		private static function onGetTimeFault(event:FaultEvent):void {
			DEBUG::time {
				trace("ManejadorTiempo> Error obteniendo el tiempo remoto: ", event.fault);
			}
		}
		
		private static function parseTime(value:String):Number {
			return ManejadorTiempo.parseDate(value).time;
		}
		
		private static function parseDate(value:String):Date {
			var pieces:Array = value.match(/^(\d+)-(\d+)-(\d+) (\d+):(\d+)(?::(\d+))?/);
			
			return new Date(pieces[1],pieces[2] - 1,pieces[3],pieces[4],pieces[5], pieces[6] ? pieces[6] : 0);
		}
	}
}
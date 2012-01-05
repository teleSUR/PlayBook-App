package telesur.data
{
	import flash.events.Event;
	
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import telesur.enums.ConcurrentRequestStrategy;
	import telesur.utils.ManejadorRecursos;

	public class TelesurAPI
	{
		private static const APIURL:String = "http://multimedia.tlsur.net/api/";
		
		//public static const QUERY_CATEGORIAS:String = "Q_CATEGORIAS";
		//public static const QUERY_CLIPSPORCAT:String = "Q_CLIPSPORCAT";
		
		private var _httpService:HTTPService;
		
		private var _active:Boolean = false;
		public function get active():Boolean {
			return this._active;
		}
		
		private var _concurrentRequestStrategy:String;
		private var _requestQueue:Array;
		
		public function TelesurAPI(concurrentRequestStrategy:String = ConcurrentRequestStrategy.DENEGAR)
		{
			this._concurrentRequestStrategy = concurrentRequestStrategy;
			this._requestQueue = new Array();
		}
		
		private function _onFinishedCall(event:Event):void {
			DEBUG::telesur_api {
				trace("TelesurAPI> Llamada terminada");
			}
			
			if ( this._concurrentRequestStrategy == ConcurrentRequestStrategy.ENCOLAR && this._requestQueue.length > 0 ) {
				var request:TelesurAPIRequest = (this._requestQueue.shift() as TelesurAPIRequest);
				//this._active = true; //Técnicamente, si llega aqui es para apagar la bandera active, asi que debe seguir prendida o.O
				this._httpService = request.Launch(this._onFinishedCall);
			} else {
				this._active = false;
				this._httpService = null;
			}
		}
		
		private function _llamadaAPI(ruta:String,options:Object,resultCallback:Function,faultCallback:Function):void {
			if ( this.active ) {
				if (this._concurrentRequestStrategy == ConcurrentRequestStrategy.CANCELAR ) {
					DEBUG::telesur_api {
						trace("TelesurAPI> Hay una petición activa. Cancelando.");
					}
					this.cancelarActual();
				} else if (this._concurrentRequestStrategy == ConcurrentRequestStrategy.ENCOLAR ) {
				 //Do Nothing. La request se encolará
				} else {//if ( this._concurrentRequestStrategy == ConcurrentRequestStrategy.DENEGAR ) 
					DEBUG::telesur_api {
						trace("TelesurAPI> Hay una petición activa y la estrategia actual es Denegar.");
					}
					faultCallback(new FaultEvent(FaultEvent.FAULT,false,true,new Fault("REQUESTINPROGRESS","Hay una petición en proceso")));
					return;
				}
			}
			
			if ( ! options["key"] ) {
				options["key"] = ManejadorRecursos.configString("teleSURApiKey");
			}
			
			var request:TelesurAPIRequest = new TelesurAPIRequest(APIURL + ruta, options, resultCallback, faultCallback);  
			
			if ( this.active && this._concurrentRequestStrategy == ConcurrentRequestStrategy.ENCOLAR ) {
				this._requestQueue.push(request);
			} else {
				this._active = true;
				this._httpService = request.Launch(this._onFinishedCall);
			}
		}
		
		public function cancelarActual():void {
			if ( this._requestQueue.length > 0 ) {
				DEBUG::telesur_api {
					trace("TelesurAPI> Lista de peticiones pendientes eliminada");
				}
				this._requestQueue = new Array();
			}
			
			if ( this.active) {
				DEBUG::telesur_api {
					trace("TelesurAPI> Petición cancelada");
				}
				
				this._httpService.cancel();
				this._httpService = null;
				
				this._active = false;
			}
		}
		
		/** Helpers para hacer las peticiones **/
		
		public function cargarCategorias(options:Object,resultCallback:Function,faultCallback:Function):void {
			DEBUG::telesur_api {
				trace("TelesurAPI> Obteniendo lista de categorías:");
			}
			this._llamadaAPI("categoria/",options,resultCallback,faultCallback);
		}
		
		public function cargarTemas(options:Object,resultCallback:Function,faultCallback:Function):void {
			DEBUG::telesur_api {
				trace("TelesurAPI> Obteniendo lista de temas:");
			}
			this._llamadaAPI("tema/",options,resultCallback,faultCallback);
		}
		
		public function cargarRegiones(options:Object,resultCallback:Function,faultCallback:Function):void {
			DEBUG::telesur_api {
				trace("TelesurAPI> Obteniendo lista de regiones:");
			}
			this._llamadaAPI("region/",options,resultCallback,faultCallback);
		}
		
		public function cargarPaises(options:Object,resultCallback:Function,faultCallback:Function):void {
			DEBUG::telesur_api {
				trace("TelesurAPI> Obteniendo lista de paises:");
			}
			this._llamadaAPI("pais/",options,resultCallback,faultCallback);
		}
		
		public function cargarPersonajes(options:Object,resultCallback:Function,faultCallback:Function):void {
			DEBUG::telesur_api {
				trace("TelesurAPI> Obteniendo lista de personajes:");
			}
			this._llamadaAPI("personaje/",options,resultCallback,faultCallback);
		}
		
		public function cargarCorresponsales(options:Object,resultCallback:Function,faultCallback:Function):void {
			DEBUG::telesur_api {
				trace("TelesurAPI> Obteniendo lista de corresponsales:");
			}
			this._llamadaAPI("corresponsal/",options,resultCallback,faultCallback);
		}
		
		public function cargarProgramas(options:Object,resultCallback:Function,faultCallback:Function):void {
			DEBUG::telesur_api {
				trace("TelesurAPI> Obteniendo lista de programas:");
			}
			this._llamadaAPI("programa/",options,resultCallback,faultCallback);
		}
		
		public function cargarVideos(options:Object,resultCallback:Function,faultCallback:Function):void{
			DEBUG::telesur_api {
				trace("TelesurAPI> Obteniendo lista de videos:");
			}
			
			if ( ! options.hasOwnProperty("detalle") ) {
				options["detalle"] = "basico";
			}
			this._llamadaAPI("clip/",options,resultCallback,faultCallback);
		}
		
		public function cargarInformacionVideo(slug:String,options:Object,resultCallback:Function,faultCallback:Function):void{
			DEBUG::telesur_api {
				trace("TelesurAPI> Obteniendo información de video:", slug);
			}
			
			if ( ! options.hasOwnProperty("detalle") ) {
				options["detalle"] = "basico";
			}
			this._llamadaAPI("clip/" + slug+ "/",options,resultCallback,faultCallback);
		}
	}
}
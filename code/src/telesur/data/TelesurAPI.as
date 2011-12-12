package telesur.data
{
	import flash.events.Event;
	
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import telesur.utils.ManejadorRecursos;

	public class TelesurAPI
	{
		private static const APIURL:String = "http://multimedia.tlsur.net/api/";
		
		public static const QUERY_CATEGORIAS:String = "Q_CATEGORIAS";
		public static const QUERY_CLIPSPORCAT:String = "Q_CLIPSPORCAT";
		
		private var _httpService:HTTPService;
		
		private var _active:Boolean = false;
		public function get active():Boolean {
			return this._active;
		}
		
		public function TelesurAPI()
		{
		}
		
		private function _onFinishedCall(event:Event):void {
			DEBUG::telesur_api {
				trace("TelesurAPI> Llamada terminada");
			}
			this._active = false;
		}
		
		private function _llamadaAPI(ruta:String,options:Object,resultCallback:Function,faultCallback:Function):void {
			if ( this.active ) {
				DEBUG::telesur_api {
					trace("TelesurAPI> Hay una petición activa");
				}
				faultCallback(new FaultEvent(FaultEvent.FAULT,false,true,new Fault("REQUESTINPROGRESS","Hay una petición en proceso")));
				return;
			}
			
			this._httpService = new HTTPService();
			this._httpService.resultFormat = "json";
			this._httpService.addEventListener(ResultEvent.RESULT, this._onFinishedCall);
			this._httpService.addEventListener(FaultEvent.FAULT, this._onFinishedCall);
			
			this._active = true;
			
			if ( ! options["key"] ) {
				options["key"] = ManejadorRecursos.configString("teleSURApiKey");
			}
			
			var queryParams:Array = new Array();
			for (var id:String in options) {
				queryParams[queryParams.length] = id + "=" + options[id].toString();
			}
			var queryString:String = queryParams.join("&");
			
			DEBUG::telesur_api {
				trace("TelesurAPI> Obteniendo clips para: ", queryString);
			}
						
			this._httpService.url = TelesurAPI.APIURL + ruta;
			
			this._httpService.addEventListener(ResultEvent.RESULT,resultCallback);
			this._httpService.addEventListener(FaultEvent.FAULT,faultCallback);
					
			this._httpService.send(options);
			
			DEBUG::telesur_api {
				trace("TelesurAPI> Realizando peticion:", this._httpService.url);
			}
		}
		
		public function cancelarActual():void {
			if ( this.active) {
				trace("TelesurAPI> Petición cancelada");
				
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
		
		public function cargarProgramas(options:Object,resultCallback:Function,faultCallback:Function):void {
			DEBUG::telesur_api {
				trace("TelesurAPI> Obteniendo lista de categorías:");
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
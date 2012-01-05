package telesur.data
{
	import flash.net.dns.AAAARecord;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import telesur.utils.ManejadorRecursos;

	internal class TelesurAPIRequest
	{
		private var _url:String;
		private var _options:Object;
		private var _resultCallback:Function;
		private var _faultCallback:Function;
		
		public function TelesurAPIRequest(url:String, options:Object, resultCallback:Function, faultCallback:Function )
		{
			this._url = url;
			this._options = options;
			this._resultCallback = resultCallback;
			this._faultCallback = faultCallback;
		}
		
		internal function Launch(finishedCallback:Function = null):HTTPService {
			var httpService:HTTPService = new HTTPService();
			httpService.resultFormat = "json";
			if ( finishedCallback != null ) {
				httpService.addEventListener(ResultEvent.RESULT, finishedCallback);
				httpService.addEventListener(FaultEvent.FAULT, finishedCallback);
			}
						
			DEBUG::telesur_api {
				var queryParams:Array = new Array();
				for (var id:String in this._options) {
					queryParams[queryParams.length] = id + "=" + this._options[id].toString();
				}
				var queryString:String = queryParams.join("&");
				trace("TelesurAPI> Obteniendo clips para: ", queryString);
			}
			
			httpService.url = this._url;
			
			httpService.addEventListener(ResultEvent.RESULT,this._resultCallback);
			httpService.addEventListener(FaultEvent.FAULT,this._faultCallback);

			httpService.send(this._options);
			
			DEBUG::telesur_api {
				trace("TelesurAPI> Realizando peticion:", httpService.url);
			}
			
			return httpService;
		}
	}
}
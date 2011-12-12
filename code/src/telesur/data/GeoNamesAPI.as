package telesur.data
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.http.SerializationFilter;

	public class GeoNamesAPI
	{
		private var _username:String;
		public function get username():String {
			return this._username;
		}
		public function set username(value:String):void {
			this._username = value;	
		}
		
		public function GeoNamesAPI(username:String)
		{
			this.username = username;
		}
			
		public function getTimezone(latitud:Number,longitud:Number,resultCallback:Function,faultCallback:Function):void {
			var srv:HTTPService = new HTTPService();
			srv.url = "http://api.geonames.org/timezoneJSON";
			srv.resultFormat = "json";
			srv.addEventListener(ResultEvent.RESULT,resultCallback);
			srv.addEventListener(FaultEvent.FAULT,faultCallback);
			
			srv.send({ lat: latitud, lng: longitud, username: this.username });
		}
	}
}
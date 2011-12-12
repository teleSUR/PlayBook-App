package telesur.data
{
	import mx.rpc.http.AbstractOperation;
	import mx.rpc.http.SerializationFilter;
	
	public class JSONSerializationFilter extends SerializationFilter
	{
		public function JSONSerializationFilter()
		{
			super();
		}
		
		override public function deserializeResult(operation:AbstractOperation, result:Object):Object {
			return JSON.parse(result as String);
		}
		
		override public function getRequestContentType(operation:AbstractOperation, obj:Object, contentType:String):String {
			return "text/json";
		}
	}
}
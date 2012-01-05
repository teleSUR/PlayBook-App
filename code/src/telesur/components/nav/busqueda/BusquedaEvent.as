package telesur.components.nav.busqueda
{
	import flash.events.Event;
	
	public class BusquedaEvent extends Event
	{
		public static const BUSCAR:String = "BUSCAR";
		
		private var _searchOptions:Object;
		public function get searchOptions():Object {
			return this._searchOptions;
		}
		
		private var _textOptions:Array;
		public function get textOptions():Array {
			return this._textOptions;
		}
		
		public function BusquedaEvent(type:String, searchOptions:Object, textOptions:Array, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._searchOptions = searchOptions;
			this._textOptions = textOptions;
		}
	}
}
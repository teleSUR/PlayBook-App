package telesur.components.nav.filters
{
	import flash.events.Event;
	
	public class FilterStripEvent extends Event
	{
		public static const SELECT:String = "SELECT";
		
		private var _slug:String;
		public function get slug():String {
			return this._slug;
		}
		
		private var _label:String;
		public function get label():String {
			return this._label;
		}
				
		public function FilterStripEvent(type:String, slug:String, label:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._slug = slug;
			this._label = label;
		}
	}
}
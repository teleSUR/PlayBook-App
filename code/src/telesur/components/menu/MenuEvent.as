package telesur.components.menu
{
	import flash.events.Event;
	
	public class MenuEvent extends Event
	{
		public static const DOACTION:String = "TELESUR_MENUEVENT_DOACTION";
		
		private var _action:String;
		public function get action():String {
			return this._action;
		}
		
		private var _actionargs:Object;
		public function get actionargs():Object {
			return this._actionargs;
		}
		
		public function MenuEvent(type:String, action:String, actionargs:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._action = action;
			this._actionargs = actionargs;
		}
	}
}
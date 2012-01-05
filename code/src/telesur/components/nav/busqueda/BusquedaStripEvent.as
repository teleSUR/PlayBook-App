package telesur.components.nav.busqueda
{
	import flash.events.Event;
	
	public class BusquedaStripEvent extends Event
	{
		public static const BUSQUEDA_NUEVA:String = "NuevaBusqueda";
		public function BusquedaStripEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
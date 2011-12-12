package telesur.components.nav.map
{
	import com.google.maps.LatLng;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	
	public class CorresponsalMapMarker extends Marker
	{
		private var _clipData:Object;
		public function get clipData():Object {
			return this._clipData;
		}
		public function set clipData(value:Object):void {
			this._clipData = value;
		}
		
		public function CorresponsalMapMarker(arg0:LatLng, arg1:MarkerOptions=null)
		{
			super(arg0, arg1);
		}
	}
}
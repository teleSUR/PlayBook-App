package telesur.components.nav.map
{
	import caurina.transitions.Tweener;
	
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.MapType;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;
	import com.google.maps.styles.FillStyle;
	import com.google.maps.styles.StrokeStyle;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import qnx.ui.core.Container;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeMode;
	import qnx.ui.core.SizeUnit;
	
	import telesur.data.TelesurAPI;
	import telesur.utils.ManejadorRecursos;
	
	public class CorresponsalesMap extends Container
	{
		private var _api:TelesurAPI;
		private var _map:Map;
		private var _corresponsalPanel:CorresponsalInfoPanel;
		
		public function CorresponsalesMap(api:TelesurAPI)
		{
			super(100,SizeUnit.PERCENT);
			this.sizeMode = SizeMode.BOTH;
				
			this._api = api;
			this._corresponsalPanel = new CorresponsalInfoPanel();
			this._corresponsalPanel.setSize(320,280),
			this._corresponsalPanel.visible = false;
			this._corresponsalPanel.containment = Containment.UNCONTAINED;
			this._corresponsalPanel.addEventListener(CorresponsalesMapEvent.CLIP_SELECTED, this._onThumbnailSelected)
			
			this.addChild(this._corresponsalPanel);
				
			this._initMap();
		}
		
		private function _onMapReady(event:MapEvent):void {
			this._map.setMapType(MapType.NORMAL_MAP_TYPE);
			this._map.setZoom(3,true);
		}
		
		private function _onMapError(event:MapEvent):void {
			DEBUG::corresponsales {
				trace("CorresponsalesMap> ", event);	
			}
		}

		private function _initMap():void {
			this._map = new Map();
			this._map.key = ManejadorRecursos.configString("GoogleMapsAPIKey");
			this._map.url = "http://code.google.com/apis/maps/";
			this._map.sensor = "false";
			
			this._map.addEventListener(MapEvent.MAP_READY,this._onMapReady);
			this._map.addEventListener(MapEvent.MAP_INITIALIZE_FAILED, this._onMapError);
			
			this.addChild(this._map);
		}
		
		public function actualizarContenido():void {
			if (this._map.isLoaded() ) {
				this._map.clearOverlays();
				this._api.cargarVideos({detalle: "completo", ultimo: 10, tipo: "noticia", corresponsal: "no_es_nulo"},this._onCargaVideosResult,this._onCargaVideosFault);
			} else {
				this._map.addEventListener(MapEvent.MAP_READY, this._onMapAsyncUpdate);
			}
		}
		
		private function _onMapAsyncUpdate(event:MapEvent):void {
			this.actualizarContenido();
			this._map.removeEventListener(MapEvent.MAP_READY, this._onMapAsyncUpdate);
		}
		
		private function _onThumbnailSelected(event:CorresponsalesMapEvent):void {
			this.dispatchEvent(new CorresponsalesMapEvent(CorresponsalesMapEvent.CLIP_SELECTED, event.clipData));
		}
		
		private function _onCargaVideosResult(event:ResultEvent):void {
			var clipArray:Array = event.result as Array;
			for ( var i:Number = 0; i < clipArray.length; i ++ ) {
				var clip:Object = clipArray[i];
				var pieces:Array = String(clip.geotag ? clip.geotag : clip.pais.geotag).split(",",2);
				
				var markerA:CorresponsalMapMarker = new CorresponsalMapMarker(
					new LatLng(pieces[0],pieces[1]),
					new MarkerOptions({
						strokeStyle: new StrokeStyle({color: 0x00CC00}),
						fillStyle: new FillStyle({color: 0xFFFF00}),
						radius: 12,
						hasShadow: true
					}));
				
				markerA.clipData = clip;
				markerA.addEventListener(MapMouseEvent.CLICK, this._onMarkerClick);
				
				this._map.addOverlay(markerA);
				
				if ( i == 0 ) {
					this._activateMarker(markerA);
				}
			}
		}
		
		private function _onCargaVideosFault(event:FaultEvent):void {
			
		}
		
		private function _onMarkerClick(event:MapMouseEvent):void {
			this._activateMarker(event.target as CorresponsalMapMarker);
		}
		
		private function _activateMarker(marker:CorresponsalMapMarker):void {
			this._corresponsalPanel.setMarker(marker);
			marker.openInfoWindow(new InfoWindowOptions({customContent: this._corresponsalPanel}));
			this._corresponsalPanel.visible = true;
		}
		
		override protected function draw():void {
			if ( this._map ) {
				this._map.x = 0;
				this._map.y = 0;
				this._map.setSize(new Point(this.width,this.height));
			}
		}
	}
}
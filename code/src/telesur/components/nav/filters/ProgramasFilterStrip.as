package telesur.components.nav.filters
{
	import flash.events.MouseEvent;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.display.Image;
	import qnx.ui.listClasses.ScrollDirection;
	import qnx.ui.listClasses.ScrollPane;
	import qnx.utils.ImageCache;
	
	import telesur.data.TelesurAPI;
	import telesur.utils.ManejadorRecursos;
	
	public class ProgramasFilterStrip extends FilterStrip
	{
		public static const PREFERRED_HEIGHT:Number = 75;
				
		private var _api:TelesurAPI;
		private var _initialized:Boolean = false;
		private var _delayedSelection:int = -1;
		private var _imageCache:ImageCache;
		
		public function ProgramasFilterStrip(api:TelesurAPI)
		{
			super(PREFERRED_HEIGHT);
			this._api = api;
			this._initialize();
		}
		
		//Inicializa los hijos del control
		private function _initialize():void {
			DEBUG::boxes {
				this.debugColor = 0x0FF000;
			}
					
			this._imageCache = new ImageCache();
		}
		
		override public function cargarOpciones():void {
			DEBUG::filter {
				trace("ProgramasFilter> Cargando programas");
			}
			this._api.cargarProgramas({},this.onCargaProgramasResult,this.onCargaProgramasFault);
		}
		
		override public function seleccionar(index:int):void {
			DEBUG::filter {
				trace("ProgramasFilter> Seleccionando programa", index);
			}
			if ( this._initialized ) {
				super.seleccionar(index);
				this._delayedSelection = -1;
			} else {
				this._delayedSelection = index;
			}
		}
		
		private function onCargaProgramasResult(event:ResultEvent):void {
			var data:Array = event.result as Array;
			
			this._imageCache.cacheSize = data.length;
			
			for ( var i:int = 0; i < data.length; i ++ ) {
				var tmpButton:ProgramaFilterStripButton = new ProgramaFilterStripButton(data[i]["slug"], data[i]["nombre"]);
				tmpButton.imageCache = this._imageCache;
				tmpButton.setSize(170,75);
				tmpButton.setImageURL(data[i]["imagen_url"] as String);
				this.addButton(tmpButton as FilterStripButton);
			}
			
			this._initialized = true;
			
			if ( this._delayedSelection >= 0 ) {
				this.seleccionar(this._delayedSelection);
			}
		}
		
		private function onCargaProgramasFault(event:FaultEvent):void {
			DEBUG::filter {
				trace("ProgramasFilter> Error", event.fault);
			}
		}
	}
}
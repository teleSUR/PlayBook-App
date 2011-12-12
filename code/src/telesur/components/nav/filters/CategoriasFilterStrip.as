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
	
	import telesur.data.TelesurAPI;
	import telesur.utils.ManejadorRecursos;
	
	public class CategoriasFilterStrip extends FilterStrip
	{
		public static const PREFERRED_HEIGHT:Number = 40;
				
		private var _api:TelesurAPI;
		private var _initialized:Boolean = false;
		private var _delayedSelection:int = -1;
		
		public function CategoriasFilterStrip(api:TelesurAPI)
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
		}
		
		override public function cargarOpciones():void {
			DEBUG::filter {
				trace("CategoriasFilter> Cargando categorias");
			}
			this._api.cargarCategorias({},this.onCargaCategoriasResult,this.onCargaCategoriasFault);
		}
		
		override public function seleccionar(index:int):void {
			DEBUG::filter {
				trace("CategoriasFilter> Seleccionando categoria", index);
			}
			if ( this._initialized ) {
				super.seleccionar(index);
				this._delayedSelection = -1;
			} else {
				this._delayedSelection = index;
			}
		}
		
		private function onCargaCategoriasResult(event:ResultEvent):void {
			var data:Array = event.result as Array;
			
			for ( var i:int = 0; i < data.length; i ++ ) {
				var tmpButton:CategoriaFilterStripButton = new CategoriaFilterStripButton(data[i]["slug"], data[i]["nombre"]);
				tmpButton.setSize(170,this.height);
				this.addButton(tmpButton);
			}
			
			this._initialized = true;
			
			if ( this._delayedSelection >= 0 ) {
				this.seleccionar(this._delayedSelection);
			}
		}
		
		private function onCargaCategoriasFault(event:FaultEvent):void {
			DEBUG::filter {
				trace("CategoriasFilter> Error:", event.fault);
			}
		}
	}
}
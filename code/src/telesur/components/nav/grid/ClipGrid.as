package telesur.components.nav.grid
{
	import caurina.transitions.Tweener;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.edit.SelectionManager;
	
	import mx.effects.TweenEffect;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import qnx.ui.buttons.Button;
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeMode;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.data.DataProvider;
	import qnx.ui.events.ListEvent;
	import qnx.ui.listClasses.ListSelectionMode;
	import qnx.ui.listClasses.TileList;
	import qnx.ui.progress.ActivityIndicator;
	import qnx.ui.text.Label;
	
	import telesur.data.TelesurAPI;
	import telesur.events.ClipEvent;

	public class ClipGrid extends Container
	{
		public const PREFERRED_SIZE:Number = 100;
		
		private const START_CLIP_NUMBER:Number = 12;
		private const ADDITIONAL_CLIP_NUMBER:Number = 8;
		private const THUMBNAIL_PADDING:Number = 8;

		private var _api:TelesurAPI;
		
		private var _tileList:TileList;
		
		private var _numClipsCargados:int = 0;
		private var _opcionesQuery:Object = {};
		
		private var _footer:ClipGridFooter;
								
		public function ClipGrid(api:TelesurAPI)
		{
			super(this.PREFERRED_SIZE,SizeUnit.PERCENT);
			this.sizeMode = SizeMode.BOTH; 
			this._api = api;
			
			this.initializeUI();
		}
		
		private function initializeUI():void {
			DEBUG::boxes {
				this.debugColor = 0x0000ff;
			}
			
			this.flow = ContainerFlow.VERTICAL;
			this.align = ContainerAlign.MID;
			this.margins = new <Number>[8,8,8,8];
			
			this._footer = new ClipGridFooter();
			this._footer.addEventListener(ClipGridEvent.CARGARMAS,this.onCargarMas);
			
			this._tileList = new TileList();
			this._tileList.setSkin(ClipCellRenderer);
			this._tileList.containment = Containment.CONTAINED;
			this._tileList.size = 100;
			this._tileList.sizeUnit = SizeUnit.PERCENT;
			this._tileList.cellPadding = this.THUMBNAIL_PADDING;
			this._tileList.rowHeight = 208;
			this._tileList.selectionMode = ListSelectionMode.NONE;			
			this._tileList.dataProvider = new DataProvider();
			this._tileList.footerView = this._footer;
			
			this._tileList.addEventListener(Event.CHANGE,this.onDataChange);
			this._tileList.addEventListener(ListEvent.ITEM_CLICKED,this.onThumbnailClick);
											
			this.addChild(this._tileList);
		}
		
		public function limpiarClips():void {
			this._numClipsCargados = 0;
			this._tileList.dataProvider.removeAll();
		}
		
		public function setQuery(options:Object):void {
			this.clearQuery();
			this.appendQuery(options);
		}
		
		public function appendQuery(options:Object):void {
			for ( var prop:String in options ) {
				this._opcionesQuery[prop] = options[prop];
			}
		}
		
		public function clearQuery():void {
			this._opcionesQuery = {};
		}
		
		public function recargarClips():void {
			DEBUG::clipgrid {
				trace("ClipGrid> Recargando clips");
			}
			
			if ( this._api.active ) {
				this._api.cancelarActual();
			}
			
			this.limpiarClips();
			this.cargarBloqueClips();
		}
		
		public function onThumbnailClick(event:ListEvent):void {
			DEBUG::clipgrid {
				trace("ClipGrid> Clicl on ", event.data.slug);
			}
			this.dispatchEvent(new ClipGridEvent(ClipGridEvent.CLIPSELECTED, event.data));
		}
		
	
		public function onCargarMas(event:ClipGridEvent):void {
			this.cargarBloqueClips();
		}
		
		private function cargarBloqueClips():void {
			this._footer.cambiarEstado(true);
			
			this._opcionesQuery["primero"] = this._numClipsCargados + 1;
			this._opcionesQuery["ultimo"] = this._numClipsCargados + (this._numClipsCargados > 0 ? this.ADDITIONAL_CLIP_NUMBER : this.START_CLIP_NUMBER);
			this._opcionesQuery["detalle"] = 'basico';
			
			this._api.cargarVideos(this._opcionesQuery, this.onCargaClipsResult, this.onCargaClipsFault ); 
		}

		public function onCargaClipsResult(event:ResultEvent):void {
			var data:Array = event.result as Array;
			this._footer.cambiarEstado(false);
			this._numClipsCargados = this._opcionesQuery["ultimo"];			
			this._tileList.dataProvider.addItemsAt(data,this._tileList.dataProvider.length);
		}
		
		public function onCargaClipsFault(event:FaultEvent):void {
			this._footer.cambiarEstado(false);
		}
						
		override protected function draw():void {
			var tmpHorizontal:Boolean = this.width >= this.height;
			var thumbnailWidth:Number;
			var tmpNumColumnas:Number;
			
			if ( tmpHorizontal ) {
				tmpNumColumnas = 4;
			} else {
				tmpNumColumnas = 2;
			}
			
			thumbnailWidth = ( this.width - 16 - (tmpNumColumnas - 1 ) * this.THUMBNAIL_PADDING ) / tmpNumColumnas;
			
			this._tileList.columnWidth = thumbnailWidth;
			this._tileList.columnCount = tmpNumColumnas;
					
			this.layout();
			this._footer.setSize(this._tileList.width, 48);
			this._tileList.footerView = this._footer;
		}
		
		public function onDataChange(event:Event):void {
			//this.layout();
			this._tileList.drawNow();
			this._tileList.footerView = this._footer;
		}
	}
}
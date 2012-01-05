package telesur.components.nav
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	
	import org.osmf.net.StreamType;
	
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.display.TilingBackground;
	
	import telesur.components.Overlay;
	import telesur.components.about.AboutPanel;
	import telesur.components.nav.busqueda.BusquedaEvent;
	import telesur.components.nav.busqueda.BusquedaPanel;
	import telesur.components.nav.busqueda.BusquedaStrip;
	import telesur.components.nav.busqueda.BusquedaStripEvent;
	import telesur.components.nav.filters.CategoriasFilterStrip;
	import telesur.components.nav.filters.FilterStrip;
	import telesur.components.nav.filters.FilterStripEvent;
	import telesur.components.nav.filters.ProgramasFilterStrip;
	import telesur.components.nav.grid.ClipGrid;
	import telesur.components.nav.grid.ClipGridEvent;
	import telesur.components.nav.infopanel.ClipInfoPanel;
	import telesur.components.nav.infopanel.ClipInfoPanelEvent;
	import telesur.components.nav.map.CorresponsalesMap;
	import telesur.components.nav.map.CorresponsalesMapEvent;
	import telesur.components.nav.titlebar.TitleBar;
	import telesur.components.nav.titlebar.TitleBarEvent;
	import telesur.data.TelesurAPI;
	import telesur.enums.ConcurrentRequestStrategy;
	import telesur.enums.DetalleClip;
	import telesur.enums.Vista;
	import telesur.events.ClipEvent;
	import telesur.utils.ManejadorRecursos;
	
	public class Navigation extends Container
	{
		private var _vistaActual:String;
		private var _bg:TilingBackground;
		
		private var _titleBar:TitleBar;
		private var _clipGrid:ClipGrid;
		private var _corresponsalesMap:CorresponsalesMap;
		private var _searchPanel:BusquedaPanel;
		
		private var _panelOverlay:Overlay;
		private var _clipInfoPanel:ClipInfoPanel;
		
		private var _categoriasStrip:CategoriasFilterStrip;
		private var _programasStrip:ProgramasFilterStrip;
		private var _busquedaStrip:BusquedaStrip;
		
		public function Navigation()
		{
			super();
			this._initializeUI();
		}
		
		private function _initializeUI():void {
			DEBUG::boxes {
				this.debugColor = 0x00FF00;
			}
			
			this.align = ContainerAlign.NEAR;
			this.flow = ContainerFlow.VERTICAL;
			
			this._bg = new TilingBackground(); 
			this._bg.bitmapData = Bitmap(ManejadorRecursos.imagen("FondoClip")).bitmapData;
			this._bg.containment = Containment.BACKGROUND;
			
			this._titleBar = new TitleBar();
			
			this._clipGrid = new ClipGrid(new TelesurAPI(ConcurrentRequestStrategy.CANCELAR));
			this._clipGrid.visible = false;
			
			this._corresponsalesMap = new CorresponsalesMap(new TelesurAPI());
			this._corresponsalesMap.visible= false;
			
			var filteringAPI:TelesurAPI = new TelesurAPI(ConcurrentRequestStrategy.ENCOLAR);
			
			this._searchPanel = new BusquedaPanel(filteringAPI);
			this._searchPanel.visible = false;
			this._searchPanel.containment = Containment.UNCONTAINED;
			
			this._panelOverlay = new Overlay();
			this._panelOverlay.containment = Containment.BACKGROUND;
			this._panelOverlay.bitmapData = Bitmap(ManejadorRecursos.imagen("Overlay")).bitmapData;
			this._panelOverlay.visible = false;
			
			this._clipInfoPanel = new ClipInfoPanel(new TelesurAPI(ConcurrentRequestStrategy.CANCELAR));
			this._clipInfoPanel.visible = false;
			this._clipInfoPanel.containment = Containment.UNCONTAINED;
			
			this._categoriasStrip = new CategoriasFilterStrip(filteringAPI);
			this._categoriasStrip.setSize(this.width,CategoriasFilterStrip.PREFERRED_HEIGHT);
			this._categoriasStrip.containment = Containment.UNCONTAINED;
			this._categoriasStrip.visible = false;
			
			this._programasStrip = new ProgramasFilterStrip(filteringAPI);
			this._programasStrip.setSize(this.width,ProgramasFilterStrip.PREFERRED_HEIGHT);
			this._programasStrip.containment = Containment.UNCONTAINED;
			this._programasStrip.visible = false;
			
			this._busquedaStrip = new BusquedaStrip();
			this._busquedaStrip.setSize(this.width, BusquedaStrip.PREFERRED_HEIGHT);
			this._busquedaStrip.size = BusquedaStrip.PREFERRED_HEIGHT;
			this._busquedaStrip.sizeUnit = SizeUnit.PIXELS;
			this._busquedaStrip.containment = Containment.UNCONTAINED;
			this._busquedaStrip.visible = false;
			
			this.addChild(this._bg);
			this.addChild(this._titleBar);
			this.addChild(this._clipGrid);
			this.addChild(this._corresponsalesMap);
			this.addChild(this._categoriasStrip);
			this.addChild(this._programasStrip);
			this.addChild(this._busquedaStrip);
			this.addChild(this._panelOverlay);
			this.addChild(this._searchPanel);
			this.addChild(this._clipInfoPanel);			
			
			// Asignación de eventos
			this._titleBar.addEventListener(TitleBarEvent.PLAY_LIVE,this._onTitleBarPlayLive);
			this._titleBar.addEventListener(TitleBarEvent.REFRESH,this._onTitleBarRefresh);
			this._clipGrid.addEventListener(ClipGridEvent.CLIPSELECTED,this._onClipSelected);
			this._corresponsalesMap.addEventListener(CorresponsalesMapEvent.CLIP_SELECTED, this._onCorresponsalesClipSelected);
			this._searchPanel.addEventListener(BusquedaEvent.BUSCAR, this._onBuscarClips);
			
			this._categoriasStrip.addEventListener(FilterStripEvent.SELECT,this._onCategoriaSelect);
			this._programasStrip.addEventListener(FilterStripEvent.SELECT,this._onProgramaSelect);
			this._busquedaStrip.addEventListener(BusquedaStripEvent.BUSQUEDA_NUEVA, this._onBusquedaNueva);
			this._clipInfoPanel.addEventListener(ClipInfoPanelEvent.PLAY_CLIP, this._onClipPlay);
			this._clipInfoPanel.addEventListener(ClipInfoPanelEvent.CLOSE, this._onClipInfoPanelClose);
			
			// Inicialización de controles
			this._categoriasStrip.cargarOpciones();
			this._programasStrip.cargarOpciones();
		}
		
		public function cambiarVista(nuevaVista:String):void {
			//this.visible = true;
			if ( this._vistaActual == nuevaVista ){
				//La vista nueva es la misma que la actual. Nada que hacer.
				return;
			}
			
			var mostrarCategorias:Boolean = false;
			var mostrarProgramas:Boolean = false;
			var mostrarClipGrid:Boolean = true;
			var mostrarCorresponsalesMap:Boolean = false;
			var mostrarBusqueda:Boolean = false;
			
			this._panelOverlay.visible = false;
			this._clipInfoPanel.visible = false;
			this._searchPanel.visible = false;
			
			switch (nuevaVista){
				/*case Vista.ENVIVO:
					this._titleBar.title = ManejadorRecursos.localizarCadena("EnVivo");
					mostrarCategorias = false;
					mostrarClipGrid = false;
					mostrarCorresponsalesMap = false;
					mostrarProgramas = false;
					
					this.dispatchEvent(new NavigationEvent(NavigationEvent.LIVESELECTED, ManejadorRecursos.configObject("LiveStreaming")));
					break;*/
				case Vista.NOTICIAS:
					mostrarCategorias = true;
					
					this._titleBar.title = ManejadorRecursos.localizarCadena("Noticias");
					this._clipGrid.setQuery({tipo: "noticia"});
					
					break;
				
				case Vista.ENTREVISTAS:
					this._titleBar.title = ManejadorRecursos.localizarCadena("Entrevistas");
					this._clipGrid.setQuery({tipo: "entrevista"});
					
					mostrarCategorias = true;
					
					break;
				case Vista.REPORTAJES:
					this._titleBar.title = ManejadorRecursos.localizarCadena("Reportajes");
					this._clipGrid.setQuery({tipo: "reportaje"});
					
					mostrarCategorias = true;
					break;
				case Vista.PROGRAMAS:
					this._titleBar.title = ManejadorRecursos.localizarCadena("Programas");
					this._clipGrid.setQuery({tipo: "programa"});
					
					mostrarProgramas = true;
					
					break;
				case Vista.DOCUMENTALES:
					
					this._titleBar.title = ManejadorRecursos.localizarCadena("Documentales");
					this._clipGrid.setQuery({tipo: "documental"});
					
					break;
				case Vista.CORRESPONSALES:
					this._titleBar.title = ManejadorRecursos.localizarCadena("Corresponsales");
					
					mostrarClipGrid = false;
					mostrarCorresponsalesMap = true;
					
					this._corresponsalesMap.actualizarContenido();
					break;
				
				case Vista.BUSCAR:
					this._titleBar.title = ManejadorRecursos.localizarCadena("Buscar");
					
					mostrarClipGrid = true;
					mostrarBusqueda = true;
					break;
			}
			
			this._vistaActual = nuevaVista;
			
			this._clipInfoPanel.visible = false;			
			this._clipGrid.visible = mostrarClipGrid;
			this._corresponsalesMap.visible = mostrarCorresponsalesMap;

			this._panelOverlay.visible = mostrarBusqueda;
			this._searchPanel.visible = mostrarBusqueda;
			
			this._estadoStrip(this._categoriasStrip,mostrarCategorias);
			this._estadoStrip(this._programasStrip,mostrarProgramas);
			
			if ( mostrarBusqueda ) {
				this._clipGrid.limpiarClips();
				this._busquedaStrip.containment = Containment.CONTAINED;
				this._busquedaStrip.visible = true;
			} else {
				this._busquedaStrip.containment = Containment.UNCONTAINED;
				this._busquedaStrip.visible = false;
			}
			
			if ( mostrarClipGrid && ! mostrarCategorias && ! mostrarProgramas && ! mostrarBusqueda ) {
				this._clipGrid.recargarClips();
			}
			
			this.layout();
		}
		
		override public function layout():void {
			switch ( this._vistaActual ) {
				case Vista.ENVIVO:
					//TODO:
					break;
				case Vista.POPULARES:
					//TODO:
					break;
				case Vista.NOTICIAS:
					this._categoriasStrip.layout();
					this._clipGrid.layout();
					break;
				case Vista.ENTREVISTAS:
					this._categoriasStrip.layout();
					this._clipGrid.layout();
					break;
				case Vista.BUSCAR:
					this._busquedaStrip.layout();
					this._clipGrid.layout();
					break;
			}
			
			super.layout();
		}
		
		private function _onShowStrip(strip:Container):void {
			strip.containment = Containment.CONTAINED; 
			this.layout();
		}
		
		private function _onHideStrip(strip:Container):void {
			strip.visible = false;
			this.layout();
		}
		
		private function _estadoStrip(strip:FilterStrip,estado:Boolean):void {
			if ( estado ) {
				if ( ! strip.visible ) {
					strip.containment = Containment.UNCONTAINED;
					strip.setPosition(0,this.height);
					strip.visible = true;
					Tweener.addTween(strip,{y: this.height - strip.height, time: 1, onComplete: this._onShowStrip, onCompleteParams: [strip]});
				}
				strip.seleccionar(0);
			} else {
				if ( strip.visible ) {
					strip.containment = Containment.UNCONTAINED;
					this.layout();
					
					Tweener.addTween(strip,{y: this.height, time: 1, onComplete: this._onHideStrip, onCompleteParams: [strip]});
				}
			}
		}

		//------------
		public function _onTitleBarPlayLive(event:TitleBarEvent):void {
			this.dispatchEvent(new NavigationEvent(NavigationEvent.LIVESELECTED, ManejadorRecursos.configObject("LiveStreaming")));
		}
		
		public function _onTitleBarRefresh(event:TitleBarEvent):void {
			this._clipInfoPanel.visible = false;
			if ( this._clipGrid.visible ){
				this._clipGrid.recargarClips();
			} else if ( this._corresponsalesMap.visible ){
				this._corresponsalesMap.actualizarContenido();
			} 
		}
		
		private function _onClipSelected(event:ClipGridEvent):void {
			this._clipInfoPanel.setData(event.clipData, DetalleClip.BASICO);
			this._panelOverlay.visible = true;
			this._clipInfoPanel.visible = true;
			this.draw();
		}
		
		private function _onCorresponsalesClipSelected(event:CorresponsalesMapEvent):void {
			this._clipInfoPanel.setData(event.clipData, DetalleClip.COMPLETO);
			this._panelOverlay.visible = true;
			this._clipInfoPanel.visible = true;
			this.draw();
		}
		
		private function _onClipInfoPanelClose(event:ClipInfoPanelEvent):void {
			this._panelOverlay.visible = false;
			this._clipInfoPanel.visible = false;
		}
		
		private function _onClipPlay(event:ClipInfoPanelEvent):void {
			this.dispatchEvent(new NavigationEvent(NavigationEvent.CLIPSELECTED, event.clipData));
		}
		
		private function _onCategoriaSelect(event:FilterStripEvent):void {
			this._clipGrid.appendQuery( {categoria: event.slug} );
			this._clipGrid.recargarClips();
		}
		
		private function _onProgramaSelect(event:FilterStripEvent):void {
			this._clipGrid.appendQuery( {programa: event.slug} );	
			this._clipGrid.recargarClips();
		}
		
		private function _onBusquedaNueva(event:BusquedaStripEvent):void {
			this._searchPanel.visible = true;
			this._panelOverlay.visible = true;
		}
		
		private function _onBuscarClips(event:BusquedaEvent):void {
			this._clipGrid.visible = true;
			this._panelOverlay.visible = false;
			this._searchPanel.visible = false;
			
			this._clipGrid.setQuery(event.searchOptions);
			this._clipGrid.recargarClips();
			
			this._busquedaStrip.cadenaBusqueda = event.textOptions.join(", ");
			
			this.layout();
		}
		
		override protected function draw():void {
			this._titleBar.width = this.width;
			this._clipGrid.width = this.width;
			this._corresponsalesMap.width = this.width;
			this._categoriasStrip.width = this.width;
			this._programasStrip.width = this.width;
			this._busquedaStrip.width = this.width;
			
			this._clipInfoPanel.setPosition(32,32);
			this._clipInfoPanel.setSize(this.width - 32*2,this.height - 32*2);
			
			this._searchPanel.setPosition(this.width / 8, 16);
			this._searchPanel.setSize(6 * this.width / 8, this.height - 32);
			
			this.layout();

			//super.draw();
		}

		public function show():void {
			this.visible = true;
			//Tweener.addTween(this, { alpha: 1, time: 1, onStart: function():void { this.visible = true; } });
		}
		
		public function hide():void {
			this.visible = false;
			//Tweener.addTween(this, { alpha: 0, time: 1, onComplete: function():void { this.visible = false; } });
		}
	}
}
package
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;
	import mx.rpc.http.SerializationFilter;
	
	import qnx.events.QNXApplicationEvent;
	import qnx.system.QNXApplication;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.display.TilingBackground;
	import qnx.utils.ImageCache;
	
	import spark.components.Application;
	
	import telesur.components.Overlay;
	import telesur.components.menu.Menu;
	import telesur.components.menu.MenuEvent;
	import telesur.components.nav.Navigation;
	import telesur.components.nav.NavigationEvent;
	import telesur.components.about.AboutPanel;
	import telesur.components.nav.filters.CategoriasFilterStrip;
	import telesur.components.nav.filters.FilterStrip;
	import telesur.components.nav.filters.FilterStripEvent;
	import telesur.components.nav.filters.ProgramasFilterStrip;
	import telesur.components.nav.grid.ClipCellRenderer;
	import telesur.components.nav.grid.ClipGrid;
	import telesur.components.nav.titlebar.TitleBar;
	import telesur.components.nav.titlebar.TitleBarEvent;
	import telesur.components.player.ClipPlayer;
	import telesur.components.player.ClipPlayerEvent;
	import telesur.data.JSONSerializationFilter;
	import telesur.data.TelesurAPI;
	import telesur.enums.MenuAction;
	import telesur.enums.TipoClip;
	import telesur.enums.Vista;
	import telesur.events.ClipEvent;
	import telesur.utils.ManejadorRecursos;
	import telesur.utils.ManejadorTiempo;
	
	[SWF(height="600", width="1024", frameRate="30", backgroundColor="#000000")]
	public class TeleSUR extends Sprite
	{
		private var _navegacion:Navigation;
		private var _clipPlayer:ClipPlayer;
		private var _menuOverlay:Overlay;
		private var _menu:Menu;
		private var _aboutPanel:AboutPanel;
		
		public function TeleSUR()
		{
			super();
			
			// Inicialización de Stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE,this._onResize);
			
			//Asignación de filtro para respuestas JSON
			SerializationFilter.registerFilterForResultFormat("json",new JSONSerializationFilter());
			
			//Inicialización de Helpers estáticos			
			ManejadorRecursos.iniciar();
			ManejadorTiempo.iniciar();
			
			ClipCellRenderer.iniciar();
			
			//Inicialización de la IU
			this._initializeUI();
		}
		
		private function _initializeUI():void {
			this._menuOverlay = new Overlay();
			this._menuOverlay.containment = Containment.UNCONTAINED;
			this._menuOverlay.setSize(this.stage.width,this.stage.height);
			this._menuOverlay.bitmapData = Bitmap(ManejadorRecursos.imagen("Overlay")).bitmapData;
			this._menuOverlay.visible = false;
			
			this._menu = new Menu();
			this._menu.containment = Containment.UNCONTAINED;
			this._menu.setSize(this.stage.stageWidth,this._menu.PREFERRED_HEIGHT);
			this._menu.visible = false;
			
			this._navegacion = new Navigation();
			this._navegacion.setSize(this.stage.stageWidth,this.stage.stageHeight);
			this._navegacion.visible = true;
			
			this._clipPlayer = new ClipPlayer();
			this._clipPlayer.setSize(this.stage.stageWidth,this.stage.stageHeight);
			this._clipPlayer.visible = false;
			
			this._aboutPanel = new AboutPanel();
			this._aboutPanel.visible = false;
			this._aboutPanel.setSize(this.stage.stageWidth - 64, this.stage.stageHeight - 64);
			this._aboutPanel.setPosition(32,32);
			this._aboutPanel.visible  = false;
			
			//Eventos
			if ( CONFIG::playbook_deploy) {
				QNXApplication.qnxApplication.addEventListener(QNXApplicationEvent.SWIPE_DOWN,this._onMenuDisplay);
			} else {
				this.addEventListener(MouseEvent.RIGHT_CLICK, this._onMenuDisplay);
			}
			
			this._menuOverlay.addEventListener(MouseEvent.CLICK,this._onOverlayClick);
			
			this._menu.addEventListener(MenuEvent.DOACTION,this._onMenuAction);
			
			this._navegacion.addEventListener(NavigationEvent.LIVESELECTED, this._onLiveSelected);
			this._navegacion.addEventListener(NavigationEvent.CLIPSELECTED, this._onClipSelected);
			
			this._clipPlayer.addEventListener(ClipPlayerEvent.CLOSE, this._onClipPlayerClose);
			
			this._aboutPanel.addEventListener(Event.CLOSE, this._onAboutPanelClose);
			
			this.addChild(this._navegacion);			
			this.addChild(this._clipPlayer);
			this.addChild(this._menuOverlay);
			this.addChild(this._menu);
			this.addChild(this._aboutPanel);
			
			this._menu.seleccionar(0);
		}
		
		private function _onLiveSelected(event:NavigationEvent):void {
			//this._navegacion.hide();
			this._clipPlayer.show();
			this._clipPlayer.playClip(TipoClip.ENVIVO, event.data[ ManejadorRecursos.configString("DefaultStreamingQuality") ]);
		}
		
		private function _onClipSelected(event:NavigationEvent):void {
			//this._navegacion.hide();
			this._clipPlayer.show();
			this._clipPlayer.playClip(TipoClip.CLIP, event.data["metodo_preferido"] == "http" ? event.data["archivo_url"] : event.data["streaming"]["rtmp_server"] + "/" + event.data["streaming"]["rtmp_file"] );
		}
				
		public function _onClipPlayerClose(event:ClipPlayerEvent):void {
			this._clipPlayer.disable();
			this._clipPlayer.hide();
			this._navegacion.show();
		}
		
		private function _onOverlayClick(event:MouseEvent):void {
			this._menuOverlay.hide();
			this._menu.hide();
			this._aboutPanel.visible = false;
		}
		
		private function _onMenuDisplay(event:Event):void {
			DEBUG::root {
				trace("TelesurAPI> OnMenuDisplay");
			}
			if ( this._menu.active ) {
				this._menuOverlay.hide();
				this._menu.hide();	
			} else {
				this._aboutPanel.visible = false;
				this._menuOverlay.show();
				this._menu.show();
			}
		}
		
		private function _onMenuAction(event:MenuEvent):void {	
			DEBUG::root {
				trace("TelesurApp> Ejecutando opción de menú:", event.action, "para", event.actionargs);
			}
			
			this._menuOverlay.hide();
			this._menu.hide();
			
			if ( event.action == MenuAction.VISTA ) {
				this._clipPlayer.hide();
				
				this._navegacion.cambiarVista(event.actionargs["NuevaVista"]);

			} else if ( event.action == MenuAction.ACERCADE ) {
				this._menuOverlay.show();
				this._aboutPanel.visible = true;
			}
		}
		
		private function _onAboutPanelClose(event:Event):void {
			this._menuOverlay.hide();
			this._aboutPanel.visible = false;
		}
				
		public function _onResize(event:Event):void {
			DEBUG::root {
				trace("TelesurApp> Cambiando tamaño");
			}
			this._menu.width = this.stage.stageWidth;
			this._menuOverlay.setSize(this.stage.stageWidth,this.stage.stageHeight);
			this._navegacion.setSize(this.stage.stageWidth,this.stage.stageHeight);
			this._clipPlayer.setSize(this.stage.stageWidth,this.stage.stageHeight);
		}
	}
}


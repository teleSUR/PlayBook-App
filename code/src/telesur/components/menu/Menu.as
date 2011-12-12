package telesur.components.menu
{
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.core.Spacer;
	import qnx.ui.display.Image;
	import qnx.ui.display.TilingBackground;
	
	import telesur.enums.MenuAction;
	import telesur.enums.Vista;
	import telesur.utils.ManejadorRecursos;
	
	public class Menu extends Container
	{
		private var _overlay:TilingBackground;
		private var _buttons:Array = new Array();
		private var _selectedButton:MenuButton;
		
		private var _active:Boolean = false;
		
		public const PREFERRED_HEIGHT:Number = 74;
		
		public function get active():Boolean {
			return this._active;
		}
		
		public function Menu(s:Number=100, su:String="percent")
		{
			super(0);
			DEBUG::boxes {
				this.debugColor = 0xFF0000;
			}
			
			this.initializeUI();
		}
		
		private function initializeUI():void {
			this.flow = ContainerFlow.HORIZONTAL;
			this.align = ContainerAlign.NEAR;	
			
			//Inicialización de componentes
			this._overlay = new TilingBackground();
			this._overlay.containment = Containment.BACKGROUND;
			this._overlay.bitmapData = Bitmap(ManejadorRecursos.imagen("FondoClip")).bitmapData;
			this._overlay.visible = false;
			
			this.addChild(this._overlay);
			
			this.addChild(new Spacer(8,SizeUnit.PIXELS));
			//this.addButton(MenuAction.VISTA, {NuevaVista: Vista.ENVIVO}, ManejadorRecursos.imagen("EnVivoIcono"), ManejadorRecursos.localizarCadena("EnVivo"));
			//this.addChild(new Spacer(8,SizeUnit.PIXELS));
			this.addButton(MenuAction.VISTA, {NuevaVista: Vista.NOTICIAS}, ManejadorRecursos.imagen("NoticiasIcono"), ManejadorRecursos.localizarCadena("Noticias"));
			this.addChild(new Spacer(8,SizeUnit.PIXELS));
			this.addButton(MenuAction.VISTA, {NuevaVista: Vista.ENTREVISTAS}, ManejadorRecursos.imagen("EntrevistasIcono"), ManejadorRecursos.localizarCadena("Entrevistas"));
			this.addChild(new Spacer(8,SizeUnit.PIXELS));
			this.addButton(MenuAction.VISTA, {NuevaVista: Vista.REPORTAJES}, ManejadorRecursos.imagen("ReportajesIcono"), ManejadorRecursos.localizarCadena("Reportajes"));
			this.addChild(new Spacer(8,SizeUnit.PIXELS));
			this.addButton(MenuAction.VISTA, {NuevaVista: Vista.PROGRAMAS}, ManejadorRecursos.imagen("ProgramasIcono"), ManejadorRecursos.localizarCadena("Programas"));
			this.addChild(new Spacer(8,SizeUnit.PIXELS));
			this.addButton(MenuAction.VISTA, {NuevaVista: Vista.DOCUMENTALES}, ManejadorRecursos.imagen("DocumentalesIcono"), ManejadorRecursos.localizarCadena("Documentales"));
			this.addChild(new Spacer(8,SizeUnit.PIXELS));
			this.addButton(MenuAction.VISTA, {NuevaVista: Vista.CORRESPONSALES}, ManejadorRecursos.imagen("CorresponsalesIcono"), ManejadorRecursos.localizarCadena("Corresponsales"));
			//this.addChild(new Spacer(8,SizeUnit.PIXELS));
			//this.addButton(MenuAction.VISTA, {NuevaVista: Vista.BUSCAR}, ManejadorRecursos.imagen("BuscarIcono"),ManejadorRecursos.localizarCadena("Buscar"));
			this.addChild(new Spacer());
			this.addButton(MenuAction.ACERCADE, null, ManejadorRecursos.imagen("AcercaDeIcono"), ManejadorRecursos.localizarCadena("AcercaDe"));
			this.addChild(new Spacer(8, SizeUnit.PIXELS));
		}
		
		private function onActionButtonClick(event:MouseEvent):void {
			DEBUG::menu {
				trace("Menu> Action button clicked");
			}
			
			if ( (event.target as MenuButton).action == MenuAction.VISTA ) {
				if ( this._selectedButton ) {
					this._selectedButton.selected = false;
				}
				
				this._selectedButton = (event.target as MenuButton);
				this._selectedButton.selected = true;
			}
			
			this.dispatchEvent(new MenuEvent(MenuEvent.DOACTION,(event.target as MenuButton).action, (event.target as MenuButton).actionArgs));
		}
		
		private function addButton(action:String, actionArgs:Object, icon:Object, label:String):void {
			var tmpImage:Image = new Image();
			tmpImage.setImage(icon);
			
			var tmpButton:MenuButton;
			tmpButton = new MenuButton();
			tmpButton.setSize(96,72);
			tmpButton.setIcon(icon);
			tmpButton.setLabel(label);
			tmpButton.setAction(action, actionArgs);
			tmpButton.addEventListener(MouseEvent.CLICK,this.onActionButtonClick);
			this.addChild(tmpButton);
			this._buttons.push(tmpButton);
		}
		
		public function seleccionar(index:Number):void {
			DEBUG::menu {
				trace("Menu> Seleccionando botón ", index, "de", this._buttons.length);
			}
			if ( index >= 0 && index < this._buttons.length ) {
				(this._buttons[index] as MenuButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
				
		private function closeApplicationMenu():void {
			this.hide();
		}
		
		public function show():void {
			this._active = true;
			Tweener.addTween(this, {alpha: 1, y: 0, time: 0.2, transition: "linear", onStart: function():void { this.alpha = 0; this.visible = true; this.y = -this.height; } });
		}
		
		public function hide():void {
			this._active = false;
			Tweener.addTween(this, {y: - this.height, time: 0.2, transition: "linear", onComplete: function():void { this.visible = false; } });
		}
		
		override protected function draw():void {
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(this.width, this.height, (Math.PI/180)*90, 0, 0);
			
			this.graphics.clear();
			
			this.graphics.beginGradientFill(GradientType.LINEAR,[0xB33A3A,0xB22F2F,0xA71919,0x681010],[1,1,1,1],[0,127,128,255],matrix);		
			this.graphics.drawRect(0,0,this.width,this.height);
			this.graphics.endFill();
		}
	}
}
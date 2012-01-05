package telesur.components.nav.busqueda
{
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.SizeMode;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.text.Label;
	
	import telesur.utils.ManejadorRecursos;
	
	public class BusquedaStrip extends Container
	{
		public static const PREFERRED_HEIGHT:Number = 44;
		
		private var _labelBusqueda:Label;
		private var _labelCadenaBusqueda:Label;
		private var _buttonNuevaBusqueda:LabelButton;
		
		public function get cadenaBusqueda():String {
			return this._labelCadenaBusqueda.text;
		}
		
		public function set cadenaBusqueda(value:String):void {
			this._labelCadenaBusqueda.text = value;
		}
		
		public function BusquedaStrip()
		{
			this.flow = ContainerFlow.HORIZONTAL;
			this.align = ContainerAlign.NEAR;
			this.sizeMode = SizeMode.BOTH;
			this.margins = Vector.<Number>([8,0,0,0]);
			this.padding = 8;
			
			this._initializeUI();
		}
		
		private function _initializeUI():void {
			
			this._labelCadenaBusqueda = new Label();
			this._labelCadenaBusqueda.size = 100;
			this._labelCadenaBusqueda.sizeUnit = SizeUnit.PERCENT;
			
			this._buttonNuevaBusqueda = new LabelButton();
			this._buttonNuevaBusqueda.label = ManejadorRecursos.localizarCadena("NuevaBusqueda");
			this._buttonNuevaBusqueda.size = 200;
			this._buttonNuevaBusqueda.sizeUnit = SizeUnit.PIXELS;
			
			this.addChild(this._labelCadenaBusqueda);
			this.addChild(this._buttonNuevaBusqueda);
			
			this._buttonNuevaBusqueda.addEventListener(MouseEvent.CLICK, this._onNuevaBusquedaClick);
		}
		
		private function _onNuevaBusquedaClick(event:MouseEvent):void {
			this.dispatchEvent(new BusquedaStripEvent(BusquedaStripEvent.BUSQUEDA_NUEVA));
		}
		
		override protected function draw():void {		
			this.layout();
			this._labelCadenaBusqueda.y += 8;
			
			this.graphics.clear();
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(this.width, this.height, (Math.PI/180)*90, 0, 0);
			
			graphics.beginGradientFill(GradientType.LINEAR,[0xEEEEEE,0xFDFDFD],[1,1],[127,255],matrix);		
			graphics.drawRect(0,0,this.width,this.height);
			graphics.endFill();
		}
	}
}
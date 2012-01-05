package telesur.components.nav.busqueda
{
	import flash.text.TextFormat;
	
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.text.Label;
	
	import telesur.utils.ManejadorGraficos;
	
	internal class BusquedaFilterControl extends Container
	{
		private var _label:Label;
		
		public function set value(value:String):void {
			throw new Error("Este método debe ser sobrecargado");
		}
		
		public function get value():String {
			throw new Error("Este método debe ser sobrecargado");
		}
		
		public function set label(value:String):void {
			this._label.text = value;
		}
		
		public function get label():String {
			return this._label.text;
		}
		
		public function get labelVisible():Boolean{
			return this._label.visible;
		}
		
		public function set labelVisible(value:Boolean):void {
			this._label.visible = value;
		}
		
		protected function get labelControl():Label {
			return this._label;
		}
			
		public function BusquedaFilterControl()
		{
			this.align = ContainerAlign.NEAR;
			this.flow = ContainerFlow.HORIZONTAL;
			
			this._label = new Label();
			this._label.format = new TextFormat(null,null,null,true);
			this._label.size = 30;
			this._label.sizeUnit = SizeUnit.PERCENT;
			
			this.addChild(this._label);
		}
		
		override protected function draw():void {
			this.layout();
		}
		
		
	}
}
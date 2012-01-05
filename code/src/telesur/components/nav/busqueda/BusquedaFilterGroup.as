package telesur.components.nav.busqueda
{
	import flash.text.TextFormat;
	
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.SizeMode;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.core.Spacer;
	import qnx.ui.text.Label;
	
	import telesur.utils.ManejadorGraficos;
	
	public class BusquedaFilterGroup extends Container
	{
		private var _label:Label;
		
		public function get label():String {
			return this._label.text;
		}
		
		public function set label(value:String):void {
			this._label.text = value;
		}
		
		public function BusquedaFilterGroup()
		{
			this.align = ContainerAlign.NEAR;
			this.flow = ContainerFlow.VERTICAL;
			this.sizeMode = SizeMode.BOTH;
			this.padding = 0;
			this.margins = Vector.<Number>([8,4,8,4]);
			
			this._label = new Label();
			this._label.format = new TextFormat(null,this._label.format.size + 2,null,true);
			
			this.addChild(this._label);
			this.addChild(new Spacer(6, SizeUnit.PIXELS));
		}
		
		override protected function draw():void {
			this._label.width = this.width-16;
			this.layout();
			
			this.graphics.clear();
			ManejadorGraficos.AplicarFondoControl( this.graphics, 0, 0, this.width, this.height );
			this.graphics.moveTo(0, this._label.height + 5);
			this.graphics.lineTo(this.width, this._label.height + 5);
		}
	}
}
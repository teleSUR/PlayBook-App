package telesur.components.nav.infopanel
{
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.text.Label;
	
	public class TagPanel extends Container
	{
		private var _etiquetas:Array;
		public function get etiquetas():Array {
			return this._etiquetas;
		}
		public function set etiquetas(value:Array):void {
			this._etiquetas = value;
			this._actualizarInformacion();
		}
		
		private var _etiquetasLabel:Label;
		
		public function TagPanel()
		{
			super();

			this.size = 32 + 16;
			this.sizeUnit = SizeUnit.PIXELS;
			
			this.align = ContainerAlign.NEAR;
			this.margins = new <Number>[8,8,8,8];
			this._etiquetasLabel = new Label();
			this.addChild(this._etiquetasLabel);
		}
		
		private function _actualizarInformacion():void {
			this._etiquetasLabel.text = this._etiquetas.join(", ");
		}
		
		override protected function draw():void {
			this._etiquetasLabel.height = 32;
			this._etiquetasLabel.width = this.width - 16; 
				
			this.graphics.clear();
			
			this.graphics.beginFill(0xFFFFFF,1);
			this.graphics.lineStyle(2,0xDDDDDD);
			this.graphics.drawRoundRect(0,0,this.width,this.height,24);
			this.graphics.endFill();
		}
	}
}
package telesur.components.nav.filters
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import qnx.ui.buttons.Button;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.display.Image;
	import qnx.ui.text.Label;
	
	internal class FilterStripButton extends Button
	{
		private var _slug:String;
		public function get slug():String {
			return this._slug;
		}
		
		public function set slug(value:String):void {
			this._slug = value;
		}
		
		private var _label:Label;
		public function get label():String {
			return this._label.text;
		}
		
		public function set label(value:String):void {
			this._label.text = value;
		}
		
		protected function get labelComponent():Label {
			return this._label;
		}

		public function FilterStripButton(slug:String, label:String)
		{
			super();
			
			this._label = new Label();
			this._label.format = new TextFormat(null,20);
			this._label.format.align = TextFormatAlign.CENTER;
			this._label.format.bold = true;
			
			this.slug = slug;
			this.label = label;
			this.containment = Containment.CONTAINED;
			
			this.addChild(this._label);
		}
				
		override protected function draw():void {
			super.draw();
			this._label.width = this._label.textWidth < this.width ? this._label.textWidth+4: this.width;
			this._label.x = (this.width - this._label.width) / 2;  
			this._label.y = (this.height - this._label.height) / 2;
		}
	}
}
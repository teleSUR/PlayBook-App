package telesur.components.buttons
{
	import flash.display.Bitmap;
	
	import qnx.ui.buttons.Button;
	import qnx.ui.display.Image;
	import qnx.ui.text.Label;
	
	public class CompositeButton extends Button
	{
		private var _label:Label;
		private var _icon:Image;
		
		public function get label():String {
			return this._label.text;
		}
		
		public function set label(value:String):void {
			this._label.text = value;
		}
		
		public function setIcon(image:Object):void {
			this._icon.setImage(image);
		}
			
		public function CompositeButton()
		{
			super();
			this._label = new Label();
			this._icon = new Image();
			
			this.addChild(this._icon);
			this.addChild(this._label);
		}
		
		override protected function draw():void {
			super.draw();
			//this.height  = this._icon.height + 8;
			//this.width = this._icon.width + this._label.width + 12;
			this._icon.setPosition(6,6);
			this._label.setPosition(this._icon.width + 12, 6);
		}
	}
}
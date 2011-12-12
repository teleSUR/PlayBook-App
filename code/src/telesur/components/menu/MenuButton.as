package telesur.components.menu
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import qnx.ui.buttons.Button;
	import qnx.ui.display.Image;
	import qnx.ui.text.Label;
	
	internal class MenuButton extends Button
	{
		private var _icon:Image;
		private var _label:Label;
		
		private var _action:String;
		public function get action():String {
			return this._action;
		}
		
		private var _actionArgs:Object;
		public function get actionArgs():Object {
			return this._actionArgs;
		}
		
		public function MenuButton()
		{
			super();

			this._icon = new Image();
			this._label = new Label();
			this._label.format = new TextFormat(null,13);
			
			this.addChild(this._icon);
			this.addChild(this._label);
		}
		
		public function setIcon(icon:Object):void {
			this._icon.setImage(icon);
		}
		
		public function setLabel(label:String):void {
			this._label.text = label;
		}
		
		public function setAction(action:String, args:Object):void {
			this._action = action;
			this._actionArgs = args;
		}
		
		override protected function draw():void {
			super.draw();
			this._icon.setPosition((this.width - this._icon.width)/2,(this.height - this._icon.height)/3);
			this._label.width = this._label.textWidth > this.width - 4 ? this.width - 4 : this._label.textWidth + 4;
			this._label.setPosition((this.width - this._label.width) / 2,this.height - this._label.height);
		}
	}
}
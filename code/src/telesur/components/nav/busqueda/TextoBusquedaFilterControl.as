package telesur.components.nav.busqueda
{
	import qnx.ui.core.SizeUnit;
	import qnx.ui.text.Label;
	import qnx.ui.text.TextInput;
	
	import telesur.data.TelesurAPI;

	internal class TextoBusquedaFilterControl extends BusquedaFilterControl
	{
		private var _input:TextInput;
		
		override public function set value(value:String):void {
			this._input.text = value;
		}
		
		override public function get value():String {
			return this._input.text;
		}
		
		public function TextoBusquedaFilterControl()
		{
			super();
			this._input = new TextInput();
			this._input.size = 100;
			this._input.sizeUnit = SizeUnit.PERCENT;
			this.addChild(this._input);
		}
		
		override public function toString():String {
			return (this.label + ": " + this._input.text ); 
		}
	}
}
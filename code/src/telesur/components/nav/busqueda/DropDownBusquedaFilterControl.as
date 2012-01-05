package telesur.components.nav.busqueda
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.net.dns.AAAARecord;
	
	import qnx.ui.core.SizeUnit;
	import qnx.ui.data.DataProvider;
	import qnx.ui.listClasses.DropDown;

	public class DropDownBusquedaFilterControl extends BusquedaFilterControl
	{
		private var _input:DropDown;
		
		override public function set enabled(val:Boolean):void {
			this._input.enabled = val;
		}
		
		override public function set value(value:String):void {
			for (var i:Number = 0; i < this._input.dataProvider.data.length; i+= 1) {
				if ( this._input.dataProvider.data[i].slug == value ) {
					this._input.selectedIndex = i;
					return;
				}
			}
			this._input.selectedIndex = -1;
		}
		
		override public function get value():String {
			return (this._input.selectedItem != null ? this._input.selectedItem.slug : null);
		}
		
		public function get dropDownParent():DisplayObjectContainer {
			return this._input.dropDownParent;
		}
		
		public function set dropDownParent(value:DisplayObjectContainer):void {
			this._input.dropDownParent = value;
		}
		
		public function DropDownBusquedaFilterControl()
		{
			super();
			this._input = new DropDown();
			this._input.setListSkin(FilterDropDownCellRenderer);
			this._input.size = 100;
			this._input.sizeUnit = SizeUnit.PERCENT;
			this._input.addEventListener(Event.SELECT, this._onSelect);
			
			this.addChild(this._input);
		}
		
		public function populate(data:Array):void {
			this._input.selectedIndex = -1;
			this._input.dataProvider = new DataProvider(data);
		}
		
		private function _onSelect(event:Event):void {
			this.dispatchEvent( new Event(event.type) );
		}
				
		override public function toString():String {
			return ( this._input.selectedItem != null ? (this.label + ": " + this._input.selectedItem.nombre ) : ""); 
		}
	}
}
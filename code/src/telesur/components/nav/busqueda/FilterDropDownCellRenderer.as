package telesur.components.nav.busqueda
{
	import qnx.ui.listClasses.DropDownCellRenderer;
	
	public class FilterDropDownCellRenderer extends DropDownCellRenderer
	{
		public function FilterDropDownCellRenderer()
		{
			super();
		}
		
		override public function set data(data:Object):void {
			data['label'] = data['nombre'];
			super.data = data;
		}
	}
}
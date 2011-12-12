package telesur.components.nav.grid
{
	import flash.events.MouseEvent;
	
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeMode;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.progress.ActivityIndicator;
	
	
	internal class ClipGridFooter extends Container
	{
		private var _buttonMas:LabelButton;
		private var _activityIndicator:ActivityIndicator; 
		
		public function ClipGridFooter()
		{
			super(100,SizeUnit.PERCENT);
			
			this._initializeUI();
		}
		
		private function _initializeUI():void {
			this.align = ContainerAlign.MID;
			this.flow = ContainerFlow.VERTICAL;
			
			this._activityIndicator = new ActivityIndicator();
			
			this._buttonMas = new LabelButton();
			this._buttonMas.label = "Más...";
			
			this._buttonMas.size = 100;
			this._buttonMas.sizeUnit = SizeUnit.PERCENT;
			
			this._buttonMas.addEventListener(MouseEvent.CLICK, this._onButtonMasClick);
			
			this.cambiarEstado(true);
			
			this.addChild(this._activityIndicator);
			this.addChild(this._buttonMas);
		}
		
		public function cambiarEstado(esperar:Boolean):void  {
			this._buttonMas.visible = ! esperar;
			this._activityIndicator.visible = esperar;
			this._activityIndicator.animate(esperar);
		}
		
		private function _onButtonMasClick(event:MouseEvent):void { 
			this.dispatchEvent(new ClipGridEvent(ClipGridEvent.CARGARMAS)); 
		}
		
		override protected function draw():void {
			this._buttonMas.setSize(this.width,this.height);
			this.layout();
		}
	}
}
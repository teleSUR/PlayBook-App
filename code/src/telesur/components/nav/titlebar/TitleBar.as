package telesur.components.nav.titlebar
{
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import qnx.ui.buttons.Button;
	import qnx.ui.buttons.IconButton;
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeMode;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.core.Spacer;
	import qnx.ui.display.Image;
	import qnx.ui.text.Label;
	
	import telesur.components.buttons.CompositeButton;
	import telesur.events.ClipEvent;
	import telesur.utils.ManejadorRecursos;
	
	public class TitleBar extends Container
	{
		public const PREFERRED_HEIGHT:Number = 48;
		
		private var _titleLabel:Label;
		
		public function get title():String {
			return this._titleLabel.text;
		}
		
		public function set title(value:String):void {
			this._titleLabel.text = value;
		}
		
		private var _enVivoButton:CompositeButton;
		private var _actualizarButton:CompositeButton;
		
		public function TitleBar()
		{
			super(this.PREFERRED_HEIGHT, SizeUnit.PIXELS);
			this._initializeUI();
		}
		
		private function _initializeUI():void {
			DEBUG::boxes {
				this.debugColor = 0xFF0000;
			}
			
			this.align = ContainerAlign.NEAR;
			this.flow = ContainerFlow.HORIZONTAL;
			this.sizeMode = SizeMode.BOTH;
			this.margins = Vector.<Number>([4,2,4,2]);
		
			this._titleLabel = new Label();
			this._titleLabel.format = new TextFormat(null,28,0xEEEEEE,false);
			this._titleLabel.size = 100;
			this._titleLabel.sizeUnit = SizeUnit.PERCENT;
			this._titleLabel.containment = Containment.CONTAINED;
			this._titleLabel.sizeMode = SizeMode.BOTH;
			this._titleLabel.autoSize = TextFieldAutoSize.CENTER;
				
			this._actualizarButton = new CompositeButton();
			this._actualizarButton.setIcon(ManejadorRecursos.imagen("ActualizarIcono"));
			this._actualizarButton.label = ManejadorRecursos.localizarCadena("Actualizar");
			this._actualizarButton.addEventListener(MouseEvent.CLICK, this._onActualizarIconoButtonClick);
			this._actualizarButton.width = 152;
				
			this._enVivoButton = new CompositeButton();
			this._enVivoButton.setIcon(ManejadorRecursos.imagen("EnVivoIcono"));
			this._enVivoButton.label = ManejadorRecursos.localizarCadena("EnVivo");
			this._enVivoButton.addEventListener(MouseEvent.CLICK, this._onEnVivoButtonClick);
			this._enVivoButton.width = 128;
			
			this.addChild(ManejadorRecursos.imagen("TeleSURIcono") as Bitmap);
			this.addChild(new Spacer(8, SizeUnit.PIXELS));
			this.addChild(this._titleLabel);
			this.addChild(new Spacer());
			this.addChild(this._actualizarButton);
			this.addChild(new Spacer(16, SizeUnit.PIXELS));
			this.addChild(this._enVivoButton);
			
			
			this.draw();
		}
		
		override protected function draw():void {
			this._enVivoButton.drawNow();
			this._titleLabel.drawNow();
			this.layout();
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(this.width, this.height, (Math.PI/180)*90, 0, 0);
			
			this.graphics.clear();
			
			this.graphics.beginGradientFill(GradientType.LINEAR,[0xB33A3A,0xB22F2F,0xA71919,0x681010],[1,1,1,1],[0,127,128,255],matrix);		
			this.graphics.drawRect(0,0,this.width,this.height);
			this.graphics.endFill();
		}
		
		private function _onEnVivoButtonClick(event:MouseEvent):void {
			this.dispatchEvent(new TitleBarEvent(TitleBarEvent.PLAY_LIVE)); 
		}
		
		private function _onActualizarIconoButtonClick(event:MouseEvent):void {
			this.dispatchEvent(new TitleBarEvent(TitleBarEvent.REFRESH));
		}
	}
}
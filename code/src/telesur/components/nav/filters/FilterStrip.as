package telesur.components.nav.filters
{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeMode;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.display.Image;
	import qnx.ui.listClasses.ScrollDirection;
	import qnx.ui.listClasses.ScrollPane;
	
	import telesur.data.TelesurAPI;
	
	public class FilterStrip extends Container
	{	
		private var _buttons:Array = new Array();
		protected function get buttons():Array {
			return buttons;
		}
		
		private var _scroller:ScrollPane;
		private var _scrollerContent:Container;
		protected function get scrollerContent():Container {
			return this._scrollerContent;
		}
		private var _clickedButton:FilterStripButton;
		
		public function FilterStrip(preferredHeight:Number)
		{
			super(preferredHeight, SizeUnit.PIXELS);	
			this.flow = ContainerFlow.HORIZONTAL;
			this.align = ContainerAlign.NEAR;
			this.sizeMode = SizeMode.BOTH;
			
			this._initialize();
		}
		
		//Inicializa los hijos del control
		private function _initialize():void {		
			this._scrollerContent = new Container();			
			DEBUG::boxes {
				this._scrollerContent.debugColor = 0x00FFFF;
			}
			this._scrollerContent.flow = ContainerFlow.HORIZONTAL;
			this._scrollerContent.align = ContainerAlign.MID;
			
			this._scroller = new ScrollPane();
			this._scroller.scrollDirection = ScrollDirection.HORIZONTAL;
			this._scroller.containment = Containment.CONTAINED;
			this._scroller.size = 100;
			this._scroller.sizeUnit = SizeUnit.PERCENT;
			this._scroller.setScrollContent(this._scrollerContent);

			this.addChild(this._scroller);
		}
		
		public function cargarOpciones():void {
			throw new Error("Este método debe ser sobrecargado");
		}
		
		public function seleccionar(index:int):void {
			if ( this._buttons.length > index ) {
				(this._buttons[index] as FilterStripButton).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
		
		public function addButton(button:*):void {
			button.addEventListener(MouseEvent.CLICK,this.onFilterButtonClick);
			
			this._scrollerContent.width += button.width;
			this._scrollerContent.addChild(button);
			this._buttons.push(button);
			this.draw();
		}
		
		private function onFilterButtonClick(event:MouseEvent):void {
			var tmpButton:FilterStripButton = (event.target as FilterStripButton);
			
			if ( this._clickedButton ) {
				this._clickedButton.selected = false;
			}
			
			this._clickedButton = tmpButton;
			this._clickedButton.selected = true;
			
			DEBUG::filter {
				trace("Filter> Filtrando", tmpButton.slug);	
			}
			
			this.dispatchEvent(new FilterStripEvent(FilterStripEvent.SELECT, tmpButton.slug, tmpButton.label));
		}
		
		//Ajusta el tamaño de los hijos en caso de un cambio de tamaño del componente
		override protected function draw():void {
			this._scroller.setSize(this.width,this.height);
			this._scrollerContent.height = this._scroller.height;
			this._scrollerContent.layout();
			this._scroller.update();
			
			if ( this._scroller.width >= this._scrollerContent.width ) {
				this._scroller.scrollX = 0;
				this._scroller.scrollY = 0;
			}
			
			this.layout();
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(this.width, this.height, (Math.PI/180)*90, 0, 0);
			
			this.graphics.clear();
			
			this.graphics.beginGradientFill(GradientType.LINEAR,[0xB33A3A,0xB22F2F,0xA71919,0x681010],[1,1,1,1],[0,127,128,255],matrix);		
			this.graphics.drawRect(0,0,this.width,this.height);
			this.graphics.endFill();
		}
	}
}
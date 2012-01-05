package telesur.components.nav.infopanel
{
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.SizeMode;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.text.Label;
	
	import telesur.utils.ManejadorGraficos;
	import telesur.utils.ManejadorRecursos;
	
	public class RelatedClipsPanel extends Container
	{
		private var _relacionadosLabel:Label;
		private var _clipContainer:Container;
		private var _clipData:Array; 
		
		public function RelatedClipsPanel(s:Number=100, su:String="percent")
		{
			super(s, su);
			
			this.flow = ContainerFlow.VERTICAL;
			this.align = ContainerAlign.NEAR;
			
			this.margins = new <Number>[8,8,8,8];
			
			this._relacionadosLabel = new Label();
			this._relacionadosLabel.text = ManejadorRecursos.localizarCadena("VideosRelacionados");
			this._relacionadosLabel.sizeMode = SizeMode.BOTH;
			this._relacionadosLabel.format = new TextFormat(null,null,null,true);
			
			this.addChild(this._relacionadosLabel);
		}
		
		public function setClipData(data:Array):void {
			this._clipData = data;
			this._actualizarInformacion();
		}
		
		private function _actualizarInformacion():void {
			if ( this._clipContainer != null ) {
				this.removeChild(this._clipContainer);
			}
			
			this._clipContainer = new Container();
			this._clipContainer.align = ContainerAlign.MID;
			this._clipContainer.flow = ContainerFlow.HORIZONTAL;
			this._clipContainer.padding = 8;
			
			
			for (var i:Number = 0; i < this._clipData.length; i ++) {
				var clip:RelatedClipUnit = new RelatedClipUnit();
				clip.setData(this._clipData[i]);
				clip.size = 20;
				clip.sizeUnit = SizeUnit.PERCENT;
				clip.addEventListener(MouseEvent.CLICK, this._onClipSelected);
				
				this._clipContainer.addChild(clip);
			}
			this.addChild(this._clipContainer);
			this.draw();
		}
		
		private function _onClipSelected(event:MouseEvent):void {
			var clip:RelatedClipUnit = (event.currentTarget as RelatedClipUnit);
			this.dispatchEvent(new RelatedClipsPanelEvent(RelatedClipsPanelEvent.CLIP_SELECTED, clip.data));
		}
		
		override protected function draw():void {
			this._relacionadosLabel.width = this.width - 16;
			
			this.layout();
			if( this._clipContainer ) {
				this._clipContainer.layout();
			}
			
			this.graphics.clear();
			
			ManejadorGraficos.AplicarFondoControl(this.graphics,0,0,this.width,this.height);
			
		}
	}
}
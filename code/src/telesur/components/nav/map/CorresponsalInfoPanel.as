package telesur.components.nav.map
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import qnx.events.ImageCacheEvent;
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.core.Container;
	import qnx.ui.display.Image;
	import qnx.ui.text.Label;
	
	import telesur.components.nav.grid.ClipCellRenderer;
	import telesur.utils.ManejadorRecursos;
	
	public class CorresponsalInfoPanel extends Container
	{
		private var  _marker:CorresponsalMapMarker;
		private var _nombreLabel:Label;
		private var _twitterLabel:Label;
		private var _paisLabel:Label;
		
		private var _tituloLabel:Label;
		
		private var _closeButton:LabelButton;
		
		private var _thumbnailBG:Image;
		
		private var _thumbnailImageURL:String;
		private var _thumbnailImage:Image;
		private var _thumbnailImageStatus:Boolean = true;
		
		public function CorresponsalInfoPanel(s:Number=100, su:String="percent")
		{
			super(s, su);
			
			this._nombreLabel = new Label();
			
			this._twitterLabel = new Label();
			
			this._paisLabel = new Label();
			
			this._tituloLabel = new Label();
			
			this._thumbnailBG = new Image();
			this._thumbnailBG.setImage(ManejadorRecursos.imagen("ClipSinImagen"));
			
			this._thumbnailImage = new Image();
			this._thumbnailImage.cache = ClipCellRenderer.thumbnailCache;
			this._thumbnailImage.addEventListener(MouseEvent.CLICK, this._onThumbnailClick);
				
			this._closeButton = new LabelButton();
			this._closeButton.label = ManejadorRecursos.localizarCadena("CerrarCorresponsalInfo");
			this._closeButton.addEventListener(MouseEvent.CLICK, this._onCloseButtonClick);
			
			this.addChild(this._nombreLabel);
			this.addChild(this._tituloLabel);
			this.addChild(this._thumbnailBG);
			this.addChild(this._thumbnailImage);
			this.addChild(this._closeButton);
		}
		
		private function _onCloseButtonClick(event:MouseEvent):void {
			this.visible = false;
			this._marker.closeInfoWindow();
		}
		
		public function setMarker(marker:CorresponsalMapMarker):void {
			this._marker = marker;
			this._nombreLabel.text = marker.clipData.corresponsal.nombre;
			this._paisLabel.text = marker.clipData.pais.nombre;
			
			this._tituloLabel.text = marker.clipData.titulo;
			this._tituloLabel.wordWrap = true;
			this._tituloLabel.format = new TextFormat(null,20,null,true);
				
			this.setImage(marker.clipData.thumbnail_mediano);
		}
		
		public function setImage(url:String):void {
			this._thumbnailImageURL = url;
			this._thumbnailImage.visible = false;
			var data:BitmapData = this._thumbnailImage.cache.getImage(url,true);
			if ( data ) {
				if ( this._thumbnailImageStatus == false ) {
					this._thumbnailImage.cache.removeEventListener(ImageCacheEvent.IMAGE_LOADED, this._onCacheImageLoaded);
				}
				
				this._thumbnailImageStatus = true;
				this._thumbnailImage.setImage(data);
				this._thumbnailImage.visible = true;
				this.draw();
			} else {
				this._thumbnailImageStatus = false;
				this._thumbnailImage.cache.addEventListener(ImageCacheEvent.IMAGE_LOADED, this._onCacheImageLoaded);
			}
		}
		
		private function _onCacheImageLoaded(event:ImageCacheEvent):void {
			if ( event.url == this._thumbnailImageURL ) {
				this.setImage(event.url);
			}
		}
		
		private function _onThumbnailClick(event:MouseEvent):void {
			this.dispatchEvent(new CorresponsalesMapEvent(CorresponsalesMapEvent.CLIP_SELECTED, this._marker.clipData));
		}
		
		override protected function draw():void {
			this._tituloLabel.setPosition(8,8);
			this._tituloLabel.width = this.width - 16;
			this._tituloLabel.height = 56;
			
			this._thumbnailBG.setPosition(8, this._tituloLabel.y + this._tituloLabel.height + 4);
			this._thumbnailBG.setSize(this.width - 16, 120);
				
			this._thumbnailImage.setPosition(8, this._tituloLabel.y + this._tituloLabel.height + 4);
			this._thumbnailImage.setSize(this.width - 16, 120);
			
			this._nombreLabel.setPosition(8,this._thumbnailBG.y + this._thumbnailImage.height +  0);
			this._nombreLabel.width = this.width - 16;
							
			this._closeButton.y = this._nombreLabel.y + this._nombreLabel.height + 0;
				
			this.graphics.clear();
			
			this.graphics.beginFill(0xFFFFFF,1);
			this.graphics.lineStyle(2,0xDDDDDD);
			this.graphics.drawRoundRect(0,0,this.width,this.height,24);
			this.graphics.endFill();
		}
	}
}
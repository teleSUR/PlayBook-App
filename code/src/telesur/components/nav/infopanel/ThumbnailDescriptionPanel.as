package telesur.components.nav.infopanel
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	
	import qnx.events.ImageCacheEvent;
	import qnx.ui.core.Container;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.display.Image;
	import qnx.ui.text.Label;
	
	import telesur.components.nav.grid.ClipCellRenderer;
	import telesur.utils.ManejadorRecursos;
	
	internal class ThumbnailDescriptionPanel extends Container
	{
		private var _thumbnailImageURL:String;
		private var _thumbnailImage:Image;
		private var _thumbnailImageStatus:Boolean = true;
		
		private var _thumbnailBG:Image;
		private var _thumbnailFG:Image;
		private var _descripcionCortaLabel:Label;
		
		public function get descripcionCorta():String {
			return this._descripcionCortaLabel.text;
		}
		public function set descripcionCorta(value:String):void {
			this._descripcionCortaLabel.text = value;;
		}
		
		private var _descripcionLargaLabel:Label;
		public function get descripcionLarga():String {
			return this._descripcionLargaLabel.text;
		}
		public function set descripcionLarga(value:String):void {
			this._descripcionLargaLabel.text = value;;
		}
		
		private var _lugarFechaLabel:Label;
		public function get lugarFecha():String {
			return this._lugarFechaLabel.text;
		}
		public function set lugarFecha(value:String):void {
			this._lugarFechaLabel.text = value;
		}
		
		private const THUMBNAIL_WIDTH:Number = 238;
		private const THUMBNAIL_HEIGHT:Number = 136;
		
		public function ThumbnailDescriptionPanel(s:Number=100, su:String="percent")
		{
			super(136 + 16 * 2, SizeUnit.PIXELS );
			this._initializeUI();
		}
		
		private function _initializeUI():void {
			this._descripcionCortaLabel = new Label();
			this._descripcionCortaLabel.format = new TextFormat(null,null,null,true);
			
			this._descripcionLargaLabel = new Label();
			this._descripcionLargaLabel.wordWrap = true;
			
			this._lugarFechaLabel  = new Label;
			
			this._thumbnailBG = new Image();
			this._thumbnailBG.setImage(ManejadorRecursos.imagen("ClipSinImagen"));
			
			this._thumbnailImage = new Image();
			this._thumbnailImage.cache = ClipCellRenderer.thumbnailCache;
			
			this._thumbnailFG = new Image();
			this._thumbnailFG.setImage(ManejadorRecursos.imagen("ClipPlayOverlay"));
			this._thumbnailFG.setSize(128,128);
			this._thumbnailFG.alpha = 0.5;
			
			this._thumbnailFG.addEventListener(MouseEvent.CLICK, this._onThumbnailClick);
			
			this.addChild(this._descripcionCortaLabel);
			this.addChild(this._descripcionLargaLabel);
			this.addChild(this._lugarFechaLabel);
			
			this.addChild(this._thumbnailBG);
			this.addChild(this._thumbnailImage);
			this.addChild(this._thumbnailFG);
		}
		
		public function limpiar():void {
			
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
			this.dispatchEvent(new ThumbnailDescriptionPanelEvent(ThumbnailDescriptionPanelEvent.THUMBNAIL_CLICK));
		}
		
		override protected function draw():void {
			this._thumbnailBG.setPosition(16,16);
			this._thumbnailBG.setSize(this.THUMBNAIL_WIDTH,this.THUMBNAIL_HEIGHT);
				
			this._thumbnailImage.setPosition(16,16);
			this._thumbnailImage.setSize(this.THUMBNAIL_WIDTH,this.THUMBNAIL_HEIGHT);
			
			var fgx:Number = (this.THUMBNAIL_WIDTH - this._thumbnailFG.width) / 2;
			var fgy:Number = (this.THUMBNAIL_HEIGHT - this._thumbnailFG.height) / 2;
			
			this._thumbnailFG.setPosition(this._thumbnailBG.x + fgx, this._thumbnailBG.y + fgy);

			this._descripcionCortaLabel.setPosition(this.THUMBNAIL_WIDTH + 32,8);
			this._descripcionCortaLabel.width = this.width - this._descripcionCortaLabel.x - 16;
			
			this._descripcionLargaLabel.setPosition(this.THUMBNAIL_WIDTH + 32, 16 + this._descripcionCortaLabel.height);
			this._descripcionLargaLabel.width = this.width - this._descripcionLargaLabel.x - 16;
			this._descripcionLargaLabel.height = (16 + this.THUMBNAIL_HEIGHT) - this._descripcionLargaLabel.y -this._lugarFechaLabel.height + 6;
			
			this._lugarFechaLabel.setPosition(this.THUMBNAIL_WIDTH + 32, 22 + this.THUMBNAIL_HEIGHT - this._lugarFechaLabel.height);
			this._lugarFechaLabel.width = this._descripcionLargaLabel.width = this.width - this._descripcionLargaLabel.x - 16;
			
			this.graphics.clear();

			this.graphics.beginFill(0xFFFFFF,1);
			this.graphics.lineStyle(2,0xDDDDDD);
			this.graphics.drawRoundRect(0,0,this.width,this.height,24);
			this.graphics.endFill();
		}
	}
}
package telesur.components.nav.infopanel
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import qnx.events.ImageCacheEvent;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.display.Image;
	import qnx.ui.text.Label;
	
	import telesur.components.nav.grid.ClipCellRenderer;
	import telesur.utils.ManejadorRecursos;
	import telesur.utils.ManejadorTiempo;
	
	public class RelatedClipUnit extends Container
	{
		private var _data:Object;
		public function get data():Object {
			return this._data;
		}
		
		private var _thumbnailImage:Image;
		private var _thumbnailImageURL:String;
		private var _thumbnailImageStatus:Boolean = true;
		private var _thumbnailBG:Image;
		private var _tituloLabel:Label;
		private var _duracionLabel:Label;
		private var _timestampLabel:Label;
		
		public function RelatedClipUnit()
		{
			super();
		
			this._thumbnailBG = new Image();
			this._thumbnailBG.setImage(ManejadorRecursos.imagen("ClipSinImagen"));
			
			this._thumbnailImage = new Image();
			this._thumbnailImage.cache = ClipCellRenderer.thumbnailCache;
			
			this._tituloLabel = new Label();
			this._tituloLabel.format = new TextFormat(null,16,0x000000,true);
			
			this._duracionLabel = new Label();
			this._duracionLabel.format = new TextFormat(null,16,0x444444,false);
			
			this._timestampLabel = new Label();
			this._timestampLabel.format = new TextFormat(null,14,0x770000);
			
			this.addChild(this._thumbnailBG);
			this.addChild(this._thumbnailImage);
			this.addChild(this._tituloLabel);
			this.addChild(this._duracionLabel);
			this.addChild(this._timestampLabel);
		}
		
		public function setData(data:Object):void {
			this._data = data;
			
			this.setImage(this._data.thumbnail_mediano);
			this._tituloLabel.text = this._data.titulo;
			this._duracionLabel.text = ManejadorTiempo.Duracion(this._data.duracion);
			this._timestampLabel.text = ManejadorTiempo.Timestamp(this._data.fecha);
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
			this._thumbnailBG.setPosition(0,0);
			this._thumbnailBG.setSize(this.width, 100);
			
			this._thumbnailImage.setPosition(0,0);
			this._thumbnailImage.setSize(this.width,100);
			
			this._tituloLabel.width = this.width;
			this._tituloLabel.x = 0;
			this._tituloLabel.y = 100;
			
			this._duracionLabel.width = (this.width)/2;
			this._duracionLabel.x = 0;
			this._duracionLabel.y = 100 +this._tituloLabel.height;
			
			this._timestampLabel.width = this._duracionLabel.width;
			this._timestampLabel.y = 100 +this._tituloLabel.height;
			this._timestampLabel.x = this.width / 2;
		}
			
	}
}
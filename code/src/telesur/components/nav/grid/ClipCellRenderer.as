package telesur.components.nav.grid
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	import mx.states.OverrideBase;
	
	import qnx.events.ImageCacheEvent;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.display.Image;
	import qnx.ui.listClasses.AlternatingCellRenderer;
	import qnx.ui.listClasses.TileList;
	import qnx.ui.text.Label;
	import qnx.utils.ImageCache;
	
	import telesur.utils.ManejadorRecursos;
	import telesur.utils.ManejadorTiempo;
	
	public class ClipCellRenderer extends AlternatingCellRenderer
	{
		private var _thumbnailBG:Image;
		private var _thumbnailImageURL:String;
		private var _thumbnailImageStatus:Boolean = true;
		private var _thumbnailImage:Image;
		private var _descriptionLabel:Label;
		private var _durationLabel:Label;
		private var _timestampLabel:Label;
		
		private var _initialized:Boolean = false;
			
		private static var _thumbnailCache:ImageCache;
		public static function get thumbnailCache():ImageCache {
			return _thumbnailCache;
		}
			
		private const THUMBNAIL_WIDTH:Number = 238;
		private const THUMBNAIL_HEIGHT:Number = 136;
				
		override public function set data (value:Object):void {
			super.data = value;
			if (value){
				this.changeThumbnail(value["thumbnail_mediano"]);
				this._descriptionLabel.text = value["titulo"];
				this._durationLabel.text= ManejadorTiempo.Duracion(value["duracion"]);
				this._timestampLabel.text = ManejadorTiempo.Timestamp( value["fecha"]);
				this.draw();
			}
		}
		
		public function ClipCellRenderer()
		{
			super();
			this._initializeUI();
		}
		
		private function _initializeUI():void{
			this._thumbnailImage = new Image();
			this._thumbnailImage.cache = ClipCellRenderer._thumbnailCache;
			this._thumbnailImage.x = 4;
			this._thumbnailImage.y = 4;
			this._thumbnailImage.width = 138;
			this._thumbnailImage.height = 136;
			
			this._descriptionLabel = new Label();
			this._descriptionLabel.x = 4;
			this._descriptionLabel.y = 145;
			this._descriptionLabel.height = 60;
			this._descriptionLabel.wordWrap = true;
			this._descriptionLabel.format = new TextFormat(null,16,0x000000,true);
			
			this._durationLabel = new Label();
			this._durationLabel.x = 4;
			this._durationLabel.y = 185;
			this._durationLabel.wordWrap = true;
			this._durationLabel.format = new TextFormat(null,16,0x444444,false);
			
			this._timestampLabel = new Label();
			this._timestampLabel.x = 125;
			this._timestampLabel.y = 185;
			this._timestampLabel.wordWrap = false;
			this._timestampLabel.format = new TextFormat(null,14,0x770000);
			
			this._thumbnailBG = new Image();
			this._thumbnailBG.setImage( ManejadorRecursos.imagen("ClipSinImagen") );
			this._thumbnailBG.x = 4;
			this._thumbnailBG.y = 4;
			this._thumbnailBG.height = 143;
			
			this.addChild(this._thumbnailBG);
			this.addChild(this._thumbnailImage);
			this.addChild(this._descriptionLabel);			
			this.addChild(this._durationLabel);
			this.addChild(this._timestampLabel);
			
			this._initialized = true;
			
			this.draw();
		}
		
		override protected function draw():void {
			
			if ( this._initialized ) {
				this._thumbnailBG.setSize(this.THUMBNAIL_WIDTH,this.THUMBNAIL_HEIGHT);
				this._thumbnailBG.x = (this.width - this._thumbnailBG.width)/2; 
				
				this._thumbnailImage.setSize(this.THUMBNAIL_WIDTH,this.THUMBNAIL_HEIGHT);
				this._thumbnailImage.x = (this.width - this._thumbnailBG.width)/2;
				
				this._descriptionLabel.width = this.width - 8;
				this._durationLabel.width = (this.width - 8)/2;
				this._timestampLabel.width = (this.width - 8)/2;
			}
			super.draw();
		}
		
		protected function changeThumbnail(url:String):void {
			this._thumbnailImageURL = url;
			this._thumbnailImage.visible = false;
			var data:BitmapData = ClipCellRenderer._thumbnailCache.getImage(url,true);
			if ( data ) {
				if ( this._thumbnailImageStatus == false ) {
					ClipCellRenderer._thumbnailCache.removeEventListener(ImageCacheEvent.IMAGE_LOADED, this._onCacheImageLoaded);
				}
				
				this._thumbnailImageStatus = true;
				this._thumbnailImage.setImage(data);
				this._thumbnailImage.visible = true;
				this.draw();
			} else {
				this._thumbnailImageStatus = false;
				ClipCellRenderer._thumbnailCache.addEventListener(ImageCacheEvent.IMAGE_LOADED, this._onCacheImageLoaded);
			}
		}
		
		private function _onCacheImageLoaded(event:ImageCacheEvent):void {
			if ( event.url == this._thumbnailImageURL ) {
				this.changeThumbnail(event.url);
			}
		}
				
		public static function iniciar():void {
			ClipCellRenderer._thumbnailCache = new ImageCache();
			ClipCellRenderer._thumbnailCache.cacheSize = 100;
		}
	}
}
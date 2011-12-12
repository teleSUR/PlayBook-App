package telesur.components.nav.filters
{
	import flash.display.BitmapData;
	
	import qnx.events.ImageCacheEvent;
	import qnx.ui.display.Image;
	import qnx.utils.ImageCache;

	public class ProgramaFilterStripButton extends FilterStripButton
	{
		private var _imageURL:String;
		private var _imageLoading:Boolean = false;
		
		private var _image:Image;
		protected function get image():Image {
			return this._image;
		}
		
		public function get imageCache():ImageCache {
			return this.image.cache;
		}
		
		public function set imageCache(value:ImageCache):void {
			this.image.cache = value;
		}
		
		public function ProgramaFilterStripButton(slug:String, label:String)
		{
			super(slug, label);
			this._initializeUI();
		}		
		
		private function _initializeUI():void {
			this.labelComponent.visible = false;
			
			this._image = new Image();
		
			this.addChild(this._image);
		}
			
		public function setImageURL(url:String):void {
			this._imageURL = url;
			this._image.visible = false;
			var data:BitmapData = this._image.cache.getImage(url,true);
			if ( data ) {
				this._imageLoading = false;
				this._image.setImage(data);
				this.draw();
				this._image.visible = true;
			} else {
				this._imageLoading = true;
				this._image.cache.addEventListener(ImageCacheEvent.IMAGE_LOADED, this._onCacheImageLoader);
			}
		}
		
		private function _onCacheImageLoader(event:ImageCacheEvent):void {
			if ( event.url == this._imageURL ) {
				this._image.cache.removeEventListener(ImageCacheEvent.IMAGE_LOADED, this._onCacheImageLoader);
				this.setImageURL(event.url);
			}
		}
		
		override protected function draw():void {
			this._image.setSize( this.width, this._image.height * this.width / this._image.width);
			super.draw();
		}
	}
}
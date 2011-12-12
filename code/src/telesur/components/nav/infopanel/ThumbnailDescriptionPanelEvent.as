package telesur.components.nav.infopanel
{
	import flash.events.Event;
	
	internal class ThumbnailDescriptionPanelEvent extends Event
	{
		public static const THUMBNAIL_CLICK:String = "ThumbnailClick";
		
		/*public static const TAG_CLICK:String = "TagClick";
		public static const RELATED_CLIP_CLICK:String = "RelatedClipClick";
		public static const SHARE_CLICK:String = "ShareClick";
		public static const DOWNLOAD_CLICK:String = "DownloadClick";*/
		
		private var _clipData:Object;
		public function get clipData():Object {
			return this.clipData;
		}
		
		public function get tagName():Object {
			return this._tagName;
		}
		
		private var _tagName:String;
		
		public function ThumbnailDescriptionPanelEvent(type:String, clipData:Object=null, tagName:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._clipData = clipData;
			this._tagName = tagName;
		}
	}
}
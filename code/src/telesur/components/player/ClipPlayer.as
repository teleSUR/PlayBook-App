package telesur.components.player
{
	import caurina.transitions.Tweener;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.elements.F4MElement;
	import org.osmf.elements.VideoElement;
	import org.osmf.events.BufferEvent;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.MediaPlayerCapabilityChangeEvent;
	import org.osmf.events.MediaPlayerStateChangeEvent;
	import org.osmf.events.PlayEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.DefaultMediaFactory;
	import org.osmf.media.MediaFactory;
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.MediaPlayerState;
	import org.osmf.media.MediaType;
	import org.osmf.media.URLResource;
	import org.osmf.net.DynamicStreamingItem;
	import org.osmf.net.DynamicStreamingResource;
	import org.osmf.net.NetLoader;
	import org.osmf.net.StreamType;
	import org.osmf.net.StreamingURLResource;
	import org.osmf.traits.PlayState;
	
	import qnx.dialog.AlertDialog;
	import qnx.dialog.DialogSize;
	import qnx.display.IowWindow;
	import qnx.events.MediaPlayerEvent;
	import qnx.media.MediaPlayer;
	import qnx.media.VideoDisplay;
	import qnx.ui.buttons.BackButton;
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.Containment;
	import qnx.ui.core.SizeMode;
	import qnx.ui.core.SizeUnit;
	import qnx.ui.events.MediaControlEvent;
	import qnx.ui.media.MediaControl;
	import qnx.ui.media.MediaControlOption;
	import qnx.ui.media.MediaControlProperty;
	import qnx.ui.media.MediaControlState;
	
	import telesur.enums.TipoClip;
	import telesur.utils.ManejadorRecursos;
	
	public class ClipPlayer extends Container
	{
		private var _mediaControl:MediaControl;
		private var _buttonBack:BackButton;
		private var _buttonInfo:LabelButton;
		
		private var _videoElement:VideoElement;
		private var _mediaContainer:MediaPlayerSprite;
		
		private var _controls:Container;
		
		private var _timer:Timer;
				
		private var _alertDialog:AlertDialog;
		
		public function ClipPlayer(s:Number=100, su:String="percent")
		{
			super(s, su);
			this.initializeUI();
		}
		
		private function initializeUI():void {
			this.flow = ContainerFlow.VERTICAL;
			this.align = ContainerAlign.MID;
			
			this._timer = new Timer(5000);
			this._timer.addEventListener(TimerEvent.TIMER, this._onTimerTick);
			
			this._mediaContainer = new MediaPlayerSprite();
			
			CONFIG::playbook_deploy {
				this._mediaControl = new MediaControl();
				this._mediaControl.buttonMode = true;
				this._mediaControl.width = 900;			
				
				//this._mediaControl.setOption( MediaControlOption.VOLUME, true );
				this._mediaControl.setOption( MediaControlOption.PLAY_PAUSE, true );
				//this._mediaControl.setOption( MediaControlOption.NEXT, true );
				//this._mediaControl.setOption( MediaControlOption.PREVIOUS, true );
				this._mediaControl.setOption( MediaControlOption.STOP, true );
				this._mediaControl.setOption( MediaControlOption.SEEKBAR, true );
				//this._mediaControl.setOption( MediaControlOption.DURATION, true );
				//this._mediaControl.setOption( MediaControlOption.POSITION, true );
				this._mediaControl.setOption( MediaControlOption.BACKGROUND, true);
				//this._mediaControl.setProperty( MediaControlProperty.VOLUME, 80 );
				
				this._mediaControl.addEventListener(MediaControlEvent.STATE_CHANGE, this.onControlStateChanged);
			}

			this._buttonBack = new BackButton();
			this._buttonBack.label = ManejadorRecursos.localizarCadena("Volver");
						
			this._controls = new Container(80,SizeUnit.PIXELS);
			this._controls.flow =  ContainerFlow.HORIZONTAL;
			this._controls.align = ContainerAlign.MID;
			this._controls.containment = Containment.UNCONTAINED;
			
			this._controls.setSize(this.width,80);
			
			this._controls.addChild(this._buttonBack);
			CONFIG::playbook_deploy {
				this._controls.addChild(this._mediaControl);
			}
			this._controls.drawNow();
			
			this._buttonBack.addEventListener(MouseEvent.CLICK, this._onBackButtonClick);
			this._buttonBack.addEventListener(MouseEvent.CLICK, this._onBackButtonClick);
			
			//this._mediaContainer.addEventListener(MouseEvent.CLICK, this._onMediaContainerClick);
			this.addEventListener(MouseEvent.CLICK, this._onMediaContainerClick);
			
			this._mediaContainer.mediaPlayer.addEventListener(BufferEvent.BUFFER_TIME_CHANGE, this._onBufferTimeChange);
			this._mediaContainer.mediaPlayer.addEventListener(BufferEvent.BUFFERING_CHANGE, this._onBufferingChange);
			this._mediaContainer.mediaPlayer.addEventListener(MediaErrorEvent.MEDIA_ERROR, this._onMediaError);
			this._mediaContainer.mediaPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, this._onMediaPlayerStateChange);
			this._mediaContainer.mediaPlayer.addEventListener(TimeEvent.DURATION_CHANGE, this._onDurationChange);
			this._mediaContainer.mediaPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.HAS_AUDIO_CHANGE, this._onTestEvent);
			this._mediaContainer.mediaPlayer.addEventListener(PlayEvent.PLAY_STATE_CHANGE, this._onPlayStateChange);
			this._mediaContainer.mediaPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, this._onCurrentTimeChange);
				
			this.addChild(this._mediaContainer);
			this.addChild(this._controls);
			
			this.draw();
		}
				
		public function playClip(tipo:String, url:String):void {
			DEBUG::player {
				trace("ClipPlayer> Playing:", tipo, url);
			}
			
			if ( tipo == TipoClip.ENVIVO ) {
				var media:F4MElement = new F4MElement();
				media.resource = new URLResource(url);
				this._mediaContainer.media = media;
			} else {
				var resource:StreamingURLResource = new StreamingURLResource(url, StreamType.RECORDED);
				this._videoElement = new VideoElement();
				this._videoElement.resource = resource;
				
				this._mediaContainer.media = this._videoElement;
			}
			
			this._mediaContainer.media.addEventListener(MediaElementEvent.METADATA_ADD, this._onTestEvent);
			this._mediaContainer.media.addEventListener(MediaElementEvent.METADATA_ADD, this._onTestEvent);
			this._mediaContainer.media.addEventListener(MediaElementEvent.TRAIT_ADD, this._onTraitAdd);
			this._mediaContainer.media.addEventListener(MediaElementEvent.TRAIT_REMOVE, this._onTestEvent);
			
			this._mediaContainer.width = this.width;
			this._mediaContainer.height = this.height;
			this._mediaContainer.x = 0;
			this._mediaContainer.y = 0;
			
			CONFIG::playbook_deploy {
				this._mediaControl.setState(MediaControlState.PLAY);
			}
			
			this._timer.reset();
			this._timer.start();
			
			DEBUG::player {
				trace ("ClipPlayer> HasAudio?", this._mediaContainer.mediaPlayer.hasAudio );
			}
		}
		
		private function _onTraitAdd(event:MediaElementEvent):void {
			DEBUG::player {
				trace("ClipPlayer> Trait add:", event.traitType);
			}
		}
		
		private function _onBufferTimeChange(event:BufferEvent):void {
			DEBUG::player {
				trace("ClipPlayer> Buffer time change:", event.bufferTime);
			}
		}
		
		private function _onBufferingChange(event:BufferEvent):void {
			DEBUG::player {
				trace("ClipPlayer> Buffering change:", event.buffering);
			}
		}
		
		private function _onMediaPlayerStateChange(event:MediaPlayerStateChangeEvent):void {
			DEBUG::player {
				trace("ClipPlayer> MP State Changed:", event.state);
			}
		}
		
		private function _onPlayStateChange(event:PlayEvent):void {
			DEBUG::player {
				trace("ClipPlayer> PlayStateChange", event.playState);
			}
			
			CONFIG::playbook_deploy {
				if ( event.playState == PlayState.PLAYING ) {
					this._mediaControl.setState(MediaControlState.PLAY);
				} else if ( event.playState == PlayState.PAUSED ) {
					this._mediaControl.setState(MediaControlState.PAUSE);
				} else if ( event.playState == PlayState.STOPPED ) {
						this._mediaControl.setState(MediaControlState.STOP);
				}
			}
		}
		
		private function _onMediaError(event:MediaErrorEvent):void {
			CONFIG::playbook_deploy {
				this._alertDialog = new AlertDialog();
				this._alertDialog.title = ManejadorRecursos.localizarCadena("TituloError");
				this._alertDialog.message = ManejadorRecursos.localizarCadena("ErrorReproduccion");
				this._alertDialog.addButton(ManejadorRecursos.localizarCadena("Cerrar"));
				this._alertDialog.dialogSize= DialogSize.SIZE_MEDIUM;
				this._alertDialog.show(IowWindow.getAirWindow().group);
				
				this._alertDialog.addEventListener(Event.SELECT, this._onAlertButtonClick);
			}
		}
		
		private function _onAlertButtonClick(event:Event):void {
			this._alertDialog.cancel();
			this.dispatchEvent(new ClipPlayerEvent(ClipPlayerEvent.CLOSE));
		}
		
		private function _onCurrentTimeChange(event:TimeEvent):void {
			CONFIG::playbook_deploy {
				this._mediaControl.setProperty(MediaControlProperty.POSITION, event.time);
			}
		}
		
		private function _onDurationChange(event:TimeEvent):void {
			CONFIG::playbook_deploy {
				this._mediaControl.setProperty(MediaControlProperty.DURATION, event.time);
			}
		}
		
		private function _onTestEvent(event:Event):void {
			DEBUG::player {
				trace("ClipPlayer>", event);
			
				if ( event.type == MediaPlayerCapabilityChangeEvent.HAS_AUDIO_CHANGE ) {
					trace ("NowHasAudio?", this._mediaContainer.mediaPlayer.hasAudio );	
				}
			}
		}
		
		private function _onMediaContainerClick(event:MouseEvent):void {
			this._controls.visible = ! this._controls.visible;
			if ( this._controls.visible ) {
				this._timer.reset();
				this._timer.start();
			}
		}
				
		private function _onVideoDisplayStateChange(event:MediaPlayerStateChangeEvent):void {
			DEBUG::player {
				trace("ClipPlayer> State: ", event.state);
			}
		}
		
		private function onControlStateChanged(event:MediaControlEvent):void {
			switch (event.property) {
				case MediaControlState.PLAY:
					if ( ! this._mediaContainer.mediaPlayer.playing ) {
						this._mediaContainer.mediaPlayer.play();
					}
					break;
				case MediaControlState.PAUSE:
					this._mediaContainer.mediaPlayer.pause();
					break;
				case MediaControlState.STOP:
					this._mediaContainer.mediaPlayer.stop();
					break;
			}
			
			this._timer.reset();
			this._timer.start();
			
			DEBUG::player {
				trace ("ClipPlayer>", event);
			}
		}
		
		private function _onBackButtonClick(event:MouseEvent):void {
			this.dispatchEvent(new ClipPlayerEvent(ClipPlayerEvent.CLOSE));
		}
						
		override protected function draw():void {
			this._controls.setSize(this.width,80);
			
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0,0,this.width,this.height);
			this.graphics.endFill();
			
			this._mediaContainer.width = this.width;
			this._mediaContainer.height = this.height;
			
			this._controls.setPosition(0, this.height - 4 - this._controls.height);
			this.layout();
		}
		
		private function _onTimerTick(event:TimerEvent):void {
			this._controls.visible = false;
			this._timer.stop();
		}
		
		public function disable():void {
			this._mediaContainer.media = null;
		}
		
		public function show():void {
			this.visible = true;
		}
		
		public function hide():void {
			this.disable();
			this.visible = false;
		}
	}
}
package telesur.components.nav.infopanel
{
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.core.Container;
	import qnx.ui.core.ContainerAlign;
	import qnx.ui.core.ContainerFlow;
	import qnx.ui.core.SizeMode;
	import qnx.ui.core.SizeUnit;
	
	import telesur.data.TelesurAPI;
	import telesur.enums.DetalleClip;
	import telesur.utils.ManejadorGraficos;
	import telesur.utils.ManejadorRecursos;
	import telesur.utils.ManejadorTiempo;
	
	public class ClipInfoPanel extends Container
	{		
		private var _api:TelesurAPI;
		private var thumbnailDescritionPanel:ThumbnailDescriptionPanel;
		private var thumbnailPanel:Container;
		private var descripcionCortaPanel:Container;
		private var descripcionLargaPanel:Container;
		private var etiquetasPanel:TagPanel;
		private var compartirPanel:Container;
		private var videosRelacionadosPanel:RelatedClipsPanel;
		private var _buttonClose:LabelButton;
		
		private var _data:Object;
		
		private const NUMCLIPSRELACIONADOS:Number = 4;
		
		public function get data():Object {
			return this._data;
		}
		
		private var _relacionadosData:Array;
		
		public function ClipInfoPanel(api:TelesurAPI)
		{
			super();
			this._api = api;
			this._initializeUI();
		}
		
		private function _initializeUI():void {
			DEBUG::boxes {
				this.debugColor = 0xFF0000;
			}
			
			this.align = ContainerAlign.MID;
			this.flow = ContainerFlow.VERTICAL;
			this.margins = new <Number>[8,8,8,8];
			this.padding = 8;
			
			this.thumbnailDescritionPanel = new ThumbnailDescriptionPanel();
			this.thumbnailDescritionPanel.addEventListener(ThumbnailDescriptionPanelEvent.THUMBNAIL_CLICK, this._onThumbnailClick);
			
			this.etiquetasPanel = new TagPanel();
			
			this.compartirPanel = new Container();
			this.videosRelacionadosPanel = new RelatedClipsPanel();
			this.videosRelacionadosPanel.addEventListener(RelatedClipsPanelEvent.CLIP_SELECTED, this._onRelatedClipSelected);
			
			this._buttonClose = new LabelButton();
			this._buttonClose.label = ManejadorRecursos.localizarCadena("CerrarInformacionClip");
			this._buttonClose.addEventListener(MouseEvent.CLICK, this._onButtonCloseClick)
			
			this.addChild(this.thumbnailDescritionPanel);
			this.addChild(this.etiquetasPanel);
			//this.addChild(this.compartirPanel);
			this.addChild(this.videosRelacionadosPanel);
			this.addChild(this._buttonClose);
		}
		
		public function setData(data:Object, detalle:Number=0):void {
			if ( detalle <= DetalleClip.COMPLETO ) {
				this._data = data;
				
				this.thumbnailDescritionPanel.limpiar();
				this.thumbnailDescritionPanel.setImage( this.data.thumbnail_mediano );
				this.thumbnailDescritionPanel.descripcionCorta = this.data.titulo; 
				this.thumbnailDescritionPanel.descripcionLarga = this.data.descripcion;
				this.thumbnailDescritionPanel.lugarFecha = ManejadorTiempo.Fecha(this.data.fecha);
				
				this.etiquetasPanel.etiquetas = [];
				this.videosRelacionadosPanel.setClipData([]);
				
				if ( detalle != DetalleClip.COMPLETO ) {
					this._api.cancelarActual();
					this._api.cargarInformacionVideo(this.data.slug, {detalle: "completo"},this._onCargarDetalleCompletoResult,this._onCargarDetalleCompletoFault);
				}
			}
				
			if ( detalle == DetalleClip.COMPLETO ) {
				DEBUG::infopanel {
					trace("ClipInfoPanel> Ciudad:", this.data.ciudad, " / Pais:", this.data.pais);
				}
				
				if ( this.data.ciudad && this.data.pais ) {
					this.thumbnailDescritionPanel.lugarFecha =  ManejadorRecursos.localizarCadena("LugarFecha").replace("<Ciudad>", this.data.ciudad).replace("<Pais>", this.data.pais.nombre).replace("<Fecha>", ManejadorTiempo.Fecha(this.data.fecha));
				}
				
				DEBUG::infopanel {
					trace("ClipInfoPanel> Tags:", this.data.tags );
				}
				
				// TODO: 
				//    Los tags son más bien meta-información, preferible antes mostrar Corresponal (si hay) y Tema (si hay)
				//        Ejemplo:
				//            if (this.data.corresponsal) this.etiquetasPanel.etiquetas += "Correpsonsal: " + this.data.corresponsal.nombre;
				//            if (this.data.tema) this.etiquetasPanel.etiquetas += "Tema: " + this.data.tema.nombre;
				//    Si se trata de una entrevista, sería mucho mejor poner entrevistado y entrevistador:
				//        Ejemplo:
				//            if (this.data.tipo.slug == "entrevista") {
				//                if (this.data.entrevistado) this.etiquetasPanel.etiquetas += "Entrevistado: " + this.data.entrevistado.nombre;
				//                if (this.data.entrevistador) this.etiquetasPanel.etiquetas += "Entrevistador: " + this.data.entrevistador.nombre;
				//            }
				if ( this.data.tags ) {
					this.etiquetasPanel.etiquetas = (this.data.tags as String).split(", ");
				} else {
					//TODO: Temporal hasta cambiar por Botones
					this.etiquetasPanel.etiquetas = [ ManejadorRecursos.localizarCadena("SinEtiquetas") ];
				}
				
				this._api.cargarVideos({relacionados: this.data.slug, detalle: "basico", ultimo: this.NUMCLIPSRELACIONADOS},this._onCargarRelacionadosResult,this._onCargarRelacionadosFault);
			}
			
			if ( detalle == DetalleClip.RELACIONADOS ) {
				this._relacionadosData = (data as Array);
				this.videosRelacionadosPanel.setClipData(this._relacionadosData);
			}
		}
		
		private function _onCargarDetalleCompletoResult(event:ResultEvent):void {
			this.setData(event.result, DetalleClip.COMPLETO);
		}
		
		private function _onCargarDetalleCompletoFault(event:FaultEvent):void {
			DEBUG::infopanel {
				trace("ClipInfoPanel> Error al cargar detalle:", event.fault);
			}
		}
		
		private function _onCargarRelacionadosResult(event:ResultEvent):void {
			this.setData(event.result, DetalleClip.RELACIONADOS);
		}
		
		private function _onCargarRelacionadosFault(event:FaultEvent):void {
			DEBUG::infopanel {
				trace("ClipInfoPanel> Error al cargar relacionados:", event.fault);
			}
		}
		
		private function _onRelatedClipSelected(event:RelatedClipsPanelEvent):void {
			this.setData(event.clipData, DetalleClip.BASICO);
		}
		
		private function _onThumbnailClick(event:ThumbnailDescriptionPanelEvent):void {
			this.dispatchEvent(new ClipInfoPanelEvent(ClipInfoPanelEvent.PLAY_CLIP, this.data));
		}
			
		private function _onButtonCloseClick(event:MouseEvent):void {
			this._api.cancelarActual();
			this.dispatchEvent(new ClipInfoPanelEvent(ClipInfoPanelEvent.CLOSE,null));
		}
		
		override protected function draw():void {
			this.layout();
			
			this.graphics.clear();
			ManejadorGraficos.AplicarFondoPanel(this.graphics, 0, 0, this.width, this.height);
			
			this.thumbnailDescritionPanel.drawNow();
		}
	}
}
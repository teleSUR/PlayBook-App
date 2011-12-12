package telesur.components.about
{
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import qnx.ui.buttons.LabelButton;
	import qnx.ui.core.Container;
	import qnx.ui.core.SizeMode;
	import qnx.ui.display.Image;
	import qnx.ui.text.Label;
	
	import telesur.utils.ManejadorRecursos;
	
	public class AboutPanel extends Container
	{
		private var _quienesSomosLabel:Label;
		
		private var _nuestraVisionLabel:Label;
		private var _nuestraVisionTextLabel:Label;
		
		private var _nuestraMisionLabel:Label;
		private var _nuestraMisionTextLabel:Label;
		
		private var _contactenosLabel:Label;
		
		private var _paginaWebLabel:Label;
		private var _paginaWebTextLabel:Label;
		
		private var _emailLabel:Label;
		private var _emailInfoLabel:Label;
		private var _emailIcon:Image;
		private var _emailTextLabel:Label;
		
		private var _telefonoLabel:Label;
		private var _telefonoTextLabel:Label;
		
		private var _direccionLabel:Label;
		private var _direccionTextLabel:Label;
		
		private var _redesSocialesLabel:Label;
		private var _twitterImage:Image;
		private var _facebookImage:Image;
		private var _youtubeImage:Image;
		
		private var _closeButton:LabelButton;
		
		public function AboutPanel()
		{
			super();
			this._closeButton = new LabelButton();
			this._closeButton.label = ManejadorRecursos.localizarCadena("Cerrar");
			
			this._closeButton.addEventListener(MouseEvent.CLICK, this._onBotonCerrarClick);
						
			var titleFormat:TextFormat = new TextFormat(null,24,null,true);
			var sectionFormat:TextFormat = new TextFormat(null,21,null,true);
			var textFormat:TextFormat = new TextFormat(null,18,null,false);
			var linkFormat:TextFormat = new TextFormat(null,18,0x0000FF,null,null,true);
			
			var tmpLabel:Label = new Label();
			
			this._quienesSomosLabel = new Label();
			this._quienesSomosLabel.format = titleFormat;
			this._quienesSomosLabel.text = ManejadorRecursos.localizarCadena("QuienesSomos");
			this.addChild(this._quienesSomosLabel);
			
			this._nuestraVisionLabel = new Label();
			this._nuestraVisionLabel.format = sectionFormat;
			this._nuestraVisionLabel.text = ManejadorRecursos.localizarCadena("NuestraVisionTitulo");
			this.addChild(this._nuestraVisionLabel);
			
			this._nuestraVisionTextLabel = new Label();
			this._nuestraVisionTextLabel.format = textFormat;
			this._nuestraVisionTextLabel.wordWrap = true;
			this._nuestraVisionTextLabel.multiline = true;
			this._nuestraVisionTextLabel.text = ManejadorRecursos.localizarCadena("NuestraVisionTexto");
			this.addChild(this._nuestraVisionTextLabel);
			
			this._nuestraMisionLabel = new Label();
			this._nuestraMisionLabel.format = sectionFormat;
			this._nuestraMisionLabel.text = ManejadorRecursos.localizarCadena("NuestraMisionTitulo");
			this.addChild(this._nuestraMisionLabel);
			
			this._nuestraMisionTextLabel = new Label();
			this._nuestraMisionTextLabel.format = textFormat;
			this._nuestraMisionTextLabel.wordWrap = true;
			this._nuestraMisionTextLabel.multiline = true;
			this._nuestraMisionTextLabel.text = ManejadorRecursos.localizarCadena("NuestraMisionTexto");
			this.addChild(this._nuestraMisionTextLabel);
						
			this._contactenosLabel = new Label();
			this._contactenosLabel.format = titleFormat;
			this._contactenosLabel.text = ManejadorRecursos.localizarCadena("Contactenos");
			this.addChild(this._contactenosLabel);
			
			this._paginaWebLabel = new Label();
			this._paginaWebLabel.format = sectionFormat;
			this._paginaWebLabel.text = ManejadorRecursos.localizarCadena("SitioWeb");
			this.addChild(this._paginaWebLabel);
			
			this._paginaWebTextLabel = new Label();
			this._paginaWebTextLabel.format = linkFormat;
			this._paginaWebTextLabel.text = ManejadorRecursos.localizarCadena("SitioWebTexto");
			this._paginaWebTextLabel.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void { navigateToURL(new URLRequest( ManejadorRecursos.configString("PaginaWebURL") )); });
			this.addChild(this._paginaWebTextLabel);
			
			this._emailLabel = new Label();
			this._emailLabel.format = sectionFormat;
			this._emailLabel.text = ManejadorRecursos.localizarCadena("CorreoElectronico");
			this.addChild(this._emailLabel);
			
			this._emailInfoLabel = new Label();
			this._emailInfoLabel.wordWrap = true;
			this._emailInfoLabel.format = textFormat;
			this._emailInfoLabel.text = ManejadorRecursos.localizarCadena("CorreoElectronicoInfo");
			this.addChild(this._emailInfoLabel);
			
			this._emailIcon = new Image();
			this._emailIcon.setImage( ManejadorRecursos.imagen("MailLogo"));
			this._emailIcon.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void { navigateToURL(new URLRequest( ManejadorRecursos.configString("CorreoElectronicoURL") )); });
			this.addChild(this._emailIcon);
			
			this._emailTextLabel = new Label();
			this._emailTextLabel.format = linkFormat;
			this._emailTextLabel.text = ManejadorRecursos.localizarCadena("CorreoElectronicoTexto");
			this._emailTextLabel.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void { navigateToURL(new URLRequest( ManejadorRecursos.configString("CorreoElectronicoURL") )); });
			this.addChild(this._emailTextLabel);
			
			this._telefonoLabel = new Label();
			this._telefonoLabel.format = sectionFormat;
			this._telefonoLabel.text = ManejadorRecursos.localizarCadena("Telefono");
			this.addChild(this._telefonoLabel);
			
			this._telefonoTextLabel = new Label();
			this._telefonoTextLabel.format = textFormat;
			this._telefonoTextLabel.text = ManejadorRecursos.localizarCadena("TelefonoTexto");
			this.addChild(this._telefonoTextLabel);
			
			this._direccionLabel = new Label();
			this._direccionLabel.format = sectionFormat;
			this._direccionLabel.text = ManejadorRecursos.localizarCadena("DireccionPostal");
			this.addChild(this._direccionLabel);
			
			this._direccionTextLabel = new Label();
			this._direccionTextLabel.wordWrap = true;
			this._direccionTextLabel.format = textFormat;
			this._direccionTextLabel.text = ManejadorRecursos.localizarCadena("DireccionPostalTexto");		
			this.addChild(this._direccionTextLabel);
			
			this._redesSocialesLabel = new Label();
			this._redesSocialesLabel.format = sectionFormat;
			this._redesSocialesLabel.text = ManejadorRecursos.localizarCadena("RedesSociales");
			this.addChild(this._redesSocialesLabel);
			
			this._facebookImage = new Image();
			this._facebookImage.setImage( ManejadorRecursos.imagen("FacebookLogo") );
			this._facebookImage.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void { navigateToURL(new URLRequest( ManejadorRecursos.configString("FacebookURL") )); });
			this.addChild(this._facebookImage);
			
			this._twitterImage = new Image();
			this._twitterImage.setImage( ManejadorRecursos.imagen("TwitterLogo") );
			this._twitterImage.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void { navigateToURL(new URLRequest( ManejadorRecursos.configString("TwitterURL") )); });
			this.addChild(this._twitterImage);
						
			this._youtubeImage = new Image();
			this._youtubeImage.setImage( ManejadorRecursos.imagen("YouTubeLogo"));
			this._youtubeImage.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void { navigateToURL(new URLRequest( ManejadorRecursos.configString("YouTubeURL") )); });
			this.addChild(this._youtubeImage);
			
			this.addChild(this._closeButton);
		}
		
		private function _onBotonCerrarClick(event:MouseEvent):void {
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		override protected function draw():void {
			var leftColumnX:Number = 16;
			var rightColumnX:Number = this.width / 2 + 8;
			var columnWidth:Number = (this.width - 16 * 3) / 2;
			
			this._quienesSomosLabel.setPosition(leftColumnX, 8);
			this._quienesSomosLabel.setSize(columnWidth, 40);
			
			this._nuestraVisionLabel.setPosition(leftColumnX, 48);
			this._nuestraVisionLabel.setSize(columnWidth, 32);
			
			this._nuestraVisionTextLabel.setPosition(leftColumnX, 76);
			this._nuestraVisionTextLabel.setSize(columnWidth, 300);
			
			this._nuestraMisionLabel.setPosition(leftColumnX, 224 );
			this._nuestraMisionLabel.setSize(columnWidth, 32);
	
			this._nuestraMisionTextLabel.setPosition(leftColumnX, 252);
			this._nuestraMisionTextLabel.setSize(columnWidth, 300);
			
			// //this.width / 2 + 8
			
			this._contactenosLabel.setPosition(rightColumnX, 8);
			this._contactenosLabel.setSize(columnWidth, 30);
			
			this._paginaWebLabel.setPosition(rightColumnX, 48);
			this._paginaWebLabel.setSize(columnWidth, 30);
			
			this._paginaWebTextLabel.setPosition(rightColumnX, 76);
			this._paginaWebTextLabel.setSize(columnWidth, 30);
			
			this._emailLabel.setPosition(rightColumnX, 114);
			this._emailLabel.setSize(columnWidth, 30);
			
			this._emailInfoLabel.setPosition(rightColumnX,142);
			this._emailInfoLabel.setSize(columnWidth, 60);
			
			this._emailIcon.setPosition(rightColumnX, 194);
			
			this._emailTextLabel.setPosition(rightColumnX + 40,194);
			this._emailTextLabel.setSize(columnWidth, 30);
			
			this._telefonoLabel.setPosition(rightColumnX,230);
			this._telefonoLabel.setSize(columnWidth, 30);
			
			this._telefonoTextLabel.setPosition(rightColumnX,258);
			this._telefonoTextLabel.setSize(columnWidth, 30);
			
			this._direccionLabel.setPosition(rightColumnX,290);
			this._direccionLabel.setSize(columnWidth, 30);
			
			this._direccionTextLabel.setPosition(rightColumnX,318);
			this._direccionTextLabel.setSize(columnWidth, 120);
			
			this._redesSocialesLabel.setPosition(rightColumnX,416);
			this._redesSocialesLabel.setSize(columnWidth,30);
			
			this._facebookImage.setPosition(rightColumnX + 40, 448);
			
			this._twitterImage.setPosition(rightColumnX + 130, 448);
			
			this._youtubeImage.setPosition(rightColumnX + 220, 448);
			
			this._closeButton.setPosition(leftColumnX,468);
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(this.width, this.height, (Math.PI/180)*90, 0, 0);
			
			this.graphics.clear();
			
			this.graphics.beginGradientFill(GradientType.LINEAR,[0xCCCCCC,0xFDFDFD],[1,1],[0,255],matrix);		
			this.graphics.drawRoundRect(0,0,this.width,this.height,24);			
			this.graphics.endFill();
		}
	}
}
package telesur.components.nav.busqueda
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import qnx.ui.core.Container;
	import qnx.ui.core.Spacer;
	import qnx.ui.data.DataProvider;
	import qnx.ui.listClasses.DropDown;
	import qnx.ui.text.Label;
	import qnx.ui.text.TextInput;
	
	import telesur.components.buttons.CompositeButton;
	import telesur.data.TelesurAPI;
	import telesur.utils.ManejadorGraficos;
	import telesur.utils.ManejadorRecursos;
	
	public class BusquedaPanel extends Container
	{
		//API utilizada para cargar las listas para los filtros
		private var _api:TelesurAPI;
		
		//Grupos
		private var _textoFilterGroup:BusquedaFilterGroup;
		private var _clasificacionFilterGroup:BusquedaFilterGroup;
		private var _ubicacionFilterGroup:BusquedaFilterGroup;
		private var _personasFilterGroup:BusquedaFilterGroup;
		
		private var _textoFilterControl:TextoBusquedaFilterControl;
		
		private var _categoriaFilterControl:DropDownBusquedaFilterControl;
		private var _temaFilterControl:DropDownBusquedaFilterControl;
		private var _regionFilterControl:DropDownBusquedaFilterControl;
		private var _paisFilterControl:DropDownBusquedaFilterControl;
		private var _personajeFilterControl:DropDownBusquedaFilterControl;
		private var _corresponsalFilterControl:DropDownBusquedaFilterControl;
				
		private var _buscarButton:CompositeButton;
		
		public function BusquedaPanel(api:TelesurAPI)
		{
			this._api = api;
			this._initializeUI();
		}
		
		//Inicializa la interfaz gráfica
		private function _initializeUI():void {
			//Grupo Texto
			this._textoFilterGroup = new BusquedaFilterGroup();
			this._textoFilterGroup.label = ManejadorRecursos.localizarCadena("Texto");
			
			this._textoFilterControl = new TextoBusquedaFilterControl();
			this._textoFilterControl.label = ManejadorRecursos.localizarCadena("Texto");
			this._textoFilterControl.labelVisible = false;
			this._textoFilterGroup.addChild(this._textoFilterControl);
			
			this.addChild(this._textoFilterGroup);
			
			//Grupo Clasificación
			this._clasificacionFilterGroup = new BusquedaFilterGroup();
			this._clasificacionFilterGroup.label = ManejadorRecursos.localizarCadena("Clasificacion");
			
			this._categoriaFilterControl = new DropDownBusquedaFilterControl();
			this._categoriaFilterControl.label = ManejadorRecursos.localizarCadena("Categoria");
			this._categoriaFilterControl.dropDownParent = this;
			
			this._temaFilterControl = new DropDownBusquedaFilterControl();
			this._temaFilterControl.label = ManejadorRecursos.localizarCadena("Tema");
			this._temaFilterControl.dropDownParent = this;
			
			this._clasificacionFilterGroup.addChild(this._categoriaFilterControl);
			//this._clasificacionFilterGroup.addChild(new Spacer(8,"pixels"));
			this._clasificacionFilterGroup.addChild(this._temaFilterControl);
			
			this.addChild( this._clasificacionFilterGroup);
			
			//Grupo Ubicación
			this._ubicacionFilterGroup = new BusquedaFilterGroup();
			this._ubicacionFilterGroup.label = ManejadorRecursos.localizarCadena("Ubicacion");
			
			this._regionFilterControl = new DropDownBusquedaFilterControl();
			this._regionFilterControl.label = ManejadorRecursos.localizarCadena("Region");
			this._regionFilterControl.dropDownParent = this;
			
			this._paisFilterControl = new DropDownBusquedaFilterControl();
			this._paisFilterControl.label = ManejadorRecursos.localizarCadena("Pais");
			this._paisFilterControl.dropDownParent = this;
				
			this._ubicacionFilterGroup.addChild(this._regionFilterControl);
			this._ubicacionFilterGroup.addChild(this._paisFilterControl);
			
			this.addChild(this._ubicacionFilterGroup);
			
			//Grupo Personas
			this._personasFilterGroup = new BusquedaFilterGroup();
			this._personasFilterGroup.label = ManejadorRecursos.localizarCadena("Personas");
			
			this._personajeFilterControl = new DropDownBusquedaFilterControl();
			this._personajeFilterControl.label = ManejadorRecursos.localizarCadena("Personaje");
			this._personajeFilterControl.dropDownParent = this;
			
			this._corresponsalFilterControl = new DropDownBusquedaFilterControl();
			this._corresponsalFilterControl.label = ManejadorRecursos.localizarCadena("Corresponsal");
			this._corresponsalFilterControl.dropDownParent = this;
			
			this._personasFilterGroup.addChild(this._personajeFilterControl);
			this._personasFilterGroup.addChild(this._corresponsalFilterControl);
			
			this.addChild(this._personasFilterGroup);
			
			//
			this._buscarButton = new CompositeButton();
			this._buscarButton.setIcon(ManejadorRecursos.imagen("BuscarIcono"));
			this._buscarButton.label = ManejadorRecursos.localizarCadena("Buscar");
			
			this.addChild(this._buscarButton);
			
			this._llenarCategorias();
			this._llenarTemas();			
			this._llenarRegiones();
			this._llenarPaises();
			this._llenarPersonajes();
			this._llenarCorresponsales();
			
			this._regionFilterControl.addEventListener(Event.SELECT, this._onCambiarRegion);
			this._buscarButton.addEventListener(MouseEvent.CLICK, this._onBuscarButtonClick);
		}
		
		private function _llenarCategorias():void {
			this._categoriaFilterControl.enabled = false;
			
			this._api.cargarCategorias({}, this._onCargarCategoriasResult, this._onCargarCategoriasFault);
		}
		
		private function _llenarTemas():void {
			this._temaFilterControl.enabled = false;
			this._api.cargarTemas({}, this._onCargarTemasResult, this._onCargarTemasFault);
		}
		
		private function _llenarRegiones():void {
			this._regionFilterControl.enabled = false;
						
			//Workaround para prevenir que el DropDown no seleccione el primer elemento por default
			var timer:Timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, this._onCargarRegionesResult);
			timer.start();
		}
		
		private function _llenarPaises():void {
			var region:String = this._regionFilterControl.value;
			var options:Object = {};
			
			if ( region != null && region != "-" ) {
				options.ubicacion = region;
			}
			
			this._paisFilterControl.enabled = false;
			this._api.cargarPaises(options, this._onCargarPaisesResult, this._onCargarPaisesFault);
		}
		
		private function _llenarPersonajes():void {
			this._personajeFilterControl.enabled = false;
			this._api.cargarPersonajes({}, this._onCargarPersonajesResult, this._onCargarPersonajesFault);
		}
		
		private function _llenarCorresponsales():void {
			this._corresponsalFilterControl.enabled = false;
			this._api.cargarCorresponsales({}, this._onCargarCorresponsalesResult, this._onCargarCorresponsalesFault);
		}
		
		private function _onCambiarRegion(event:Event):void {
			this._llenarPaises();
		}
		
		private function _onCargarCategoriasResult(event:ResultEvent):void {
			var categoriasList:Array = (event.result as Array);
			categoriasList.unshift(ManejadorRecursos.configObject("CategoriaCualquiera"));
			this._categoriaFilterControl.populate(categoriasList);
			this._categoriaFilterControl.enabled = true
		}
		
		private function _onCargarCategoriasFault(event:FaultEvent):void {
			
		}
		
		private function _onCargarTemasResult(event:ResultEvent):void {
			var temasList:Array = (event.result as Array);
			temasList.unshift(ManejadorRecursos.configObject("TemaCualquiera"));
			this._temaFilterControl.populate(temasList);
			this._temaFilterControl.enabled = true;
		}
		
		private function _onCargarTemasFault(event:FaultEvent):void {
			
		}
		
		private function _onCargarRegionesResult(event:TimerEvent):void {
			(event.target as Timer).stop();
			
			var regionesData:Array = ManejadorRecursos.configObject("Regiones") as Array;
			this._regionFilterControl.populate(regionesData);
			this._regionFilterControl.enabled = true;
		}
		
		private function _onCargarPaisesResult(event:ResultEvent):void {
			var paisesList:Array = (event.result as Array);
			paisesList.unshift(ManejadorRecursos.configObject("PaisTodos"));
			this._paisFilterControl.populate(paisesList);
			this._paisFilterControl.enabled = true;
		}
		
		private function _onCargarPaisesFault(event:FaultEvent):void {
			
		}
		
		private function _onCargarPersonajesResult(event:ResultEvent):void {
			var personajesList:Array = (event.result as Array);
			personajesList.unshift(ManejadorRecursos.configObject("PersonajeTodos"));
			this._personajeFilterControl.populate(personajesList);
			this._personajeFilterControl.enabled = true;
		}
		
		private function _onCargarPersonajesFault(event:FaultEvent):void {
			
		}
		
		private function _onCargarCorresponsalesResult(event:ResultEvent):void {
			var corresponsalesList:Array = (event.result as Array);
			corresponsalesList.unshift(ManejadorRecursos.configObject("CorresponsalTodos"));
			this._corresponsalFilterControl.populate(corresponsalesList);
			this._corresponsalFilterControl.enabled = true;
		}
		
		private function _onCargarCorresponsalesFault(event:FaultEvent):void {
			
		}
		
		private function _onBuscarButtonClick(event:MouseEvent):void {
			var options:Object = {};
			var text_options:Array = new Array();
			
			if ( this._textoFilterControl.value != "" ) {
				options.texto = this._textoFilterControl.value;
				text_options.push( this._textoFilterControl.toString() );
			}
			
			if ( this._categoriaFilterControl.value != null && this._categoriaFilterControl.value != "-" ) {
				options.categoria = this._categoriaFilterControl.value;
				text_options.push( this._categoriaFilterControl.toString() );
			}
			
			if ( this._temaFilterControl.value != null && this._temaFilterControl.value != "-" ) {
				options.tema = this._temaFilterControl.value;
				text_options.push( this._temaFilterControl.toString() );
			}
			
			if ( this._regionFilterControl.value != null && this._regionFilterControl.value != "-" ) {
				options.region = this._regionFilterControl.value;
				text_options.push( this._regionFilterControl.toString() );
			}
			
			if ( this._paisFilterControl.value != null && this._paisFilterControl.value != "-" ) {
				options.pais = this._paisFilterControl.value;
				text_options.push( this._paisFilterControl.toString() );
			}
			
			if ( this._personajeFilterControl.value && this._personajeFilterControl.value != "-" ) {
				options.personaje = this._personajeFilterControl.value;
				text_options.push( this._personajeFilterControl.toString() );
			}
			
			if ( this._corresponsalFilterControl.value != null && this._corresponsalFilterControl.value != "-" ) {
				options.corresponsal = this._corresponsalFilterControl.value;
				text_options.push( this._corresponsalFilterControl.toString() );
			}
			
			this.dispatchEvent(new BusquedaEvent(BusquedaEvent.BUSCAR,options,text_options));
		}
		
		override protected function draw():void {
			this._textoFilterGroup.setPosition(8,8);
			this._textoFilterGroup.setSize(this.width - 16, 80);
			
			this._clasificacionFilterGroup.setPosition(8, this._textoFilterGroup.y + this._textoFilterGroup.height + 8);
			this._clasificacionFilterGroup.setSize(this.width - 16, 134);
			
			this._ubicacionFilterGroup.setPosition(8, this._clasificacionFilterGroup.y + this._clasificacionFilterGroup.height + 8);
			this._ubicacionFilterGroup.setSize(this.width - 16, 134);
			
			this._personasFilterGroup.setPosition(8, this._ubicacionFilterGroup.y + this._ubicacionFilterGroup.height + 8);
			this._personasFilterGroup.setSize(this.width - 16, 134);
			
			this._buscarButton.setPosition((this.width - this._buscarButton.width) / 2, this._personasFilterGroup.y + this._personasFilterGroup.height + 5);
						
			this.graphics.clear()
			ManejadorGraficos.AplicarFondoPanel(this.graphics, 0, 0, this.width, this.height);
		}
	}
}
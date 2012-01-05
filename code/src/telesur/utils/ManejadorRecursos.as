package telesur.utils
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[ResourceBundle("Configuration")]
	[ResourceBundle("Strings")]
	[ResourceBundle("Images")]
	
	public class ManejadorRecursos
	{
		public function ManejadorRecursos()
		{
			
		}
		
		public static function iniciar():void {
			var rm:IResourceManager = ResourceManager.getInstance();
			rm.localeChain = ["es_ES"]; //TODO: Revisar como se asignará la cadena de locales
		}
		
		public static function localizarCadena(clave:String):String {
			var result:String = ResourceManager.getInstance().getString("Strings",clave);
			if ( ! result ) {
				result = clave;
				DEBUG::locale {
					trace("ManejadorRecursos> No existe la cadena: ", clave);
					result += "?";
				}
			}
			return result;
		}
		
		public static function imagen(clave:String):Object {
			//TODO:
			var result:Class = ResourceManager.getInstance().getClass("Images",clave);
			if ( ! result ) {
				DEBUG::locale {
					trace("ManejadorRecursos> No existe la imagen: ", clave);
				}
				result = Bitmap;
			}
			return new result();
		}
		
		public static function configObject(clave:String):Object {
			var result:Object = JSON.parse( ResourceManager.getInstance().getObject("Configuration",clave) );
			if ( ! result ) {
				DEBUG::locale {
					trace("ManejadorRecursos> No existe la configuración de objeto: ", clave);
				}
				result = {};
			}
			return result;
		}
		
		public static function configString(clave:String):String {
			var result:String = ResourceManager.getInstance().getString("Configuration",clave);
			if ( ! result ) {
				DEBUG::configuration {
					trace("ManejadorRecursos> No existe la configuración de cadena: ", clave);
				}
				result = "";
			}
			return result;
		}
		
		public static function configNumber(clave:String):Number {
			var result:Number = ResourceManager.getInstance().getNumber("Configuration",clave);
			if ( ! result ) {
				DEBUG::configuration {
					trace("ManejadorRecursos> No existe la configuración numérica: ", clave);
				}
				result = 0;
			}
			return result;
		}
	}
}
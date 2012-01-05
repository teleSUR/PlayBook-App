package telesur.utils
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;

	public class ManejadorGraficos
	{
		public function ManejadorGraficos()
		{
			
		}
		
		public static function AplicarFondoPanel(graphics:Graphics, x:Number, y:Number, width:Number, height:Number):void {
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(width, height, (Math.PI/180)*90, 0, 0);
			
			graphics.beginGradientFill(GradientType.LINEAR,[0xEEEEEE,0xFDFDFD],[1,1],[127,255],matrix);		
			graphics.drawRoundRect(x,y,width,height,24);
			graphics.endFill();
		}
		
		public static function AplicarFondoControl(graphics:Graphics,x:Number,y:Number,width:Number,height:Number):void {
			graphics.beginFill(0xFFFFFF,1);
			graphics.lineStyle(2,0xDDDDDD);
			graphics.drawRoundRect(x,y,width,height,24);
			graphics.endFill();
		}
	}
}
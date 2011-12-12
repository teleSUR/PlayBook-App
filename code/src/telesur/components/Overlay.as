package telesur.components
{
	import caurina.transitions.Tweener;
	
	import qnx.ui.core.Containment;
	import qnx.ui.display.TilingBackground;
	
	public class Overlay extends TilingBackground
	{
		public function Overlay()
		{
			super();
			this.alpha = 0.7;
		}
		
		public function show(time:Number = 1):void {
			this.visible = true;
			//Tweener.addTween(this, {alpha: 1, time: time, onStart: function():void {this.alpha = 0; this.visible = true;} });
		}
		
		public function hide(time:Number = 1):void {
			this.visible = false;
			//Tweener.addTween(this, {alpha: 0, time: time, onComplete: function():void { this.visible = false; }});
		}
	}
}
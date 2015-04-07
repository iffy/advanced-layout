package layout;

import layout.area.Area;
import layout.area.StageArea;
import layout.Direction;
import flash.events.Event;
import flash.Lib;

#if openfl
import openfl.system.Capabilities;
#end

/**
 * When you set a "simple" size for an object (as opposed to a relative
 * size), that value will be multiplied by either Scale.x or Scale.y. For
 * instance, setting simpleWidth(128) when Scale.x is 2 will result in a
 * width of 256. All margins are also scaled by these values.
 * 
 * Each Layout can have its own Scale, but by default a Scale is shared
 * between nested layouts.
 * 
 * The primary Scale is Layout.stageLayout.scale.
 * 
 * For instance, you might want an object to be 100x100 pixels on an
 * 800x600 stage. But on a 5120x2880 stage, that wouldn't be enough, so
 * this class will tell you how much to scale it up.
 * 
 * One possibility is to scale the width and height independently:
 * multiply width by 6.4, and multiply height by 4.8. However, this will
 * cause images to be distorted, which often won't look good. Call
 * Scale.stretch() if you want to enable this.
 * 
 * This class offers options to preserve the aspect ratio, but none of
 * them are perfect. A 5120x2880 stage is proportionately wider than the
 * 800x600 "base" stage, so there's no way to get an exact fit while
 * keeping the aspect ratio.
 * 
 * Choosing a scale of 4.8 would make the height fit exactly
 * (600 * 4.8 == 2880), but the width would fall short: 800 * 4.8 is only
 * 3840. You'd end up with blank space horizontally. This is done by
 * default.
 * 
 * If you went with a scale of 6.4, the width would now match, but the
 * converted height would be more than the stage height, and some objects
 * might get cut off. Call Scale.aspectRatioWithCropping() to enable this.
 * @author Joseph Cloutier
 */
@:allow(layout.ScaleBehavior)
@:allow(layout.Layout)
class Scale {
	public var x(default, null):Float = 1;
	public var y(default, null):Float = 1;
	
	public var baseStageWidth:Int;
	public var baseStageHeight:Int;
	
	/**
	 * @param	baseStageWidth The stage width you're using for testing.
	 * @param	baseStageHeight The stage height you're using for testing.
	 * @param	area If you want to use something besides the stage
	 * boundaries to calculate scale, specify it here. In most cases this
	 * won't be necessary.
	 */
	public function new(baseStageWidth:Int = 800, baseStageHeight:Int = 600,
						?area:Area) {
		this.baseStageWidth = baseStageWidth;
		this.baseStageHeight = baseStageHeight;
		this.area = area != null ? area : StageArea.instance;
		
		aspectRatio();
	}
	
	/**
	 * The behavior updates Scale.x and Scale.y whenever the stage size
	 * changes.
	 */
	private var behavior(null, set):ScaleBehavior;
	private function set_behavior(value:ScaleBehavior):ScaleBehavior {
		if(behavior == null && value != null) {
			area.addEventListener(Event.CHANGE, onResize);
		} else if(behavior != null && value == null) {
			area.removeEventListener(Event.CHANGE, onResize);
		}
		
		behavior = value;
		
		onResize(null);
		
		return behavior;
	}
	private function onResize(?e:Event):Void {
		behavior.onResize(Std.int(area.width), Std.int(area.height), this);
	}
	
	/**
	 * Do not scale anything.
	 */
	public inline function noScale():Void {
		behavior = null;
		x = 1;
		y = 1;
	}
	/**
	 * Fills the stage. Does not maintain aspect ratio. This is the
	 * default behavior.
	 */
	public inline function stretch():Void {
		behavior = new ExactFitScale();
	}
	/**
	 * Makes everything as large as possible while maintaining aspect
	 * ratio and fitting onstage. Some space may be left empty.
	 */
	public inline function aspectRatio():Void {
		behavior = new ShowAllScale();
	}
	/**
	 * Maintains aspect ratio and fills the stage. Some items may extend
	 * offscreen, and there is additional danger of overlap.
	 */
	public inline function aspectRatioWithCropping():Void {
		behavior = new NoBorderScale();
	}
	
	#if (openfl && !flash)
		/**
		 * Scale based on the screen's PPI. This requires OpenFL and
		 * doesn't work in Flash.
		 * @param	basePPI The PPI of the device you're testing on.
		 */
		public function screenPPI(?basePPI:Int = 72):Void {
			behavior = new PPIScale(basePPI);
			area.dispatchEvent(new Event(Event.CHANGE));
		}
	#end
	
	private var area(default, set):Area;
	private function set_area(value:Area):Area {
		if(value == null) {
			area = StageArea.instance;
		} else {
			area = value;
		}
		
		if(behavior != null) {
			onResize(null);
		}
		
		return area;
	}
}

private class ScaleBehavior {
	public function new() {
	}
	
	public function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = 1;
		scale.y = 1;
	}
}

/**
 * Scale based only on the stage width, maintaining aspect ratio.
 */
private class WidthScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = stageWidth / scale.baseStageWidth;
		scale.y = scale.x;
	}
}

/**
 * Scale based only on the stage height, maintaining aspect ratio.
 */
class HeightScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = stageHeight / scale.baseStageHeight;
		scale.y = scale.x;
	}
}

//The following are all named after Flash's StageScaleMode constants.
class ExactFitScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = stageWidth / scale.baseStageWidth;
		scale.y = stageHeight / scale.baseStageHeight;
	}
}

class ShowAllScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = Math.min(stageWidth / scale.baseStageWidth,
							stageHeight / scale.baseStageHeight);
		scale.y = scale.x;
	}
}

class NoBorderScale extends ScaleBehavior {
	public function new() {
		super();
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = Math.max(stageWidth / scale.baseStageWidth,
							stageHeight / scale.baseStageHeight);
		scale.y = scale.x;
	}
}

#if (openfl && !flash)
class PPIScale extends ScaleBehavior {
	private var basePPI:Float;
	
	public function new(basePPI:Float) {
		super();
		
		this.basePPI = basePPI;
	}
	
	public override function onResize(stageWidth:Int, stageHeight:Int, scale:Scale):Void {
		scale.x = Capabilities.screenDPI / basePPI;
		scale.y = scale.x;
	}
}
#end

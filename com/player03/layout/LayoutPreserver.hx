package com.player03.layout;

import com.player03.layout.area.Area;
import com.player03.layout.item.Position;
import com.player03.layout.item.Size;
import flash.display.DisplayObjectContainer;

/**
 * Use this class if you positioned your objects beforehand, and all you need is
 * to make everything scale. If you still need to position your objects,
 * consider using LayoutCreator to save a step.
 * 
 * Use this class as a static extension.
 * 
 * Example: consider an object that you've placed at the bottom of the stage.
 * When the stage scales, you want to update the object's y coordinate so that
 * it stays at the bottom. To do this, call stickToBottom().
 * 
 * All "stickTo" functions remember how far the object was from the edge (or
 * center). So if the sample object starts five pixels above the bottom, it will
 * remain about five pixels above the bottom as the stage scales. This
 * five-pixel margin will increase as the stage gets bigger, and it will
 * decrease as the stage gets smaller.
 * 
 * If you want this class to guess how an object should scale, use the
 * preserve() function.
 * 
 * @author Joseph Cloutier
 */
class LayoutPreserver {
	private static inline function check(layout:Layout):Layout {
		if(layout == null) {
			return Layout.currentLayout;
		} else {
			return layout;
		}
	}
	
	//Position objects near an edge, and scale them normally
	//======================================================
	
	public static inline function stickToLeft(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.rigidSimpleWidth(object.baseWidth));
			layout.add(object, Position.rigidInside(object.x, LEFT));
		} else {
			layout.add(object, Size.simpleWidth());
			layout.add(object, Position.inside(object.x, LEFT));
		}
	}
	public static inline function stickToRight(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.rigidSimpleWidth(object.baseWidth));
			layout.add(object, Position.rigidInside(layout.scale.baseWidth - object.right, RIGHT));
		} else {
			layout.add(object, Size.simpleWidth());
			layout.add(object, Position.inside(layout.scale.baseWidth - object.right, RIGHT));
		}
	}
	public static inline function stickToTop(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.rigidSimpleHeight(object.baseHeight));
			layout.add(object, Position.rigidInside(object.y, TOP));
		} else {
			layout.add(object, Size.simpleHeight());
			layout.add(object, Position.inside(object.y, TOP));
		}
	}
	public static inline function stickToBottom(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.rigidSimpleHeight(object.baseHeight));
			layout.add(object, Position.rigidInside(layout.scale.baseHeight - object.bottom, BOTTOM));
		} else {
			layout.add(object, Size.simpleHeight());
			layout.add(object, Position.inside(layout.scale.baseHeight - object.bottom, BOTTOM));
		}
	}
	public static inline function stickToCenterX(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.rigidSimpleWidth(object.baseWidth));
		} else {
			layout.add(object, Size.simpleWidth());
		}
		layout.add(object, Position.offsetFromCenterX(object.x + object.baseWidth / 2 - layout.scale.baseWidth / 2));
	}
	public static inline function stickToCenterY(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.rigidSimpleHeight(object.baseHeight));
		} else {
			layout.add(object, Size.simpleHeight());
		}
		layout.add(object, Position.offsetFromCenterY(object.y + object.baseHeight / 2 - layout.scale.baseHeight / 2));
	}
	
	public static inline function stickToTopLeft(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToLeft(object, rigid, layout);
		stickToTop(object, rigid, layout);
	}
	public static inline function stickToTopRight(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToRight(object, rigid, layout);
		stickToTop(object, rigid, layout);
	}
	public static inline function stickToBottomLeft(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToLeft(object, rigid, layout);
		stickToBottom(object, rigid, layout);
	}
	public static inline function stickToBottomRight(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToRight(object, rigid, layout);
		stickToBottom(object, rigid, layout);
	}
	public static inline function stickToLeftCenter(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToLeft(object, rigid, layout);
		stickToCenterY(object, rigid, layout);
	}
	public static inline function stickToRightCenter(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToRight(object, rigid, layout);
		stickToCenterY(object, rigid, layout);
	}
	public static inline function stickToTopCenter(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToCenterX(object, rigid, layout);
		stickToTop(object, rigid, layout);
	}
	public static inline function stickToBottomCenter(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToCenterX(object, rigid, layout);
		stickToBottom(object, rigid, layout);
	}
	public static inline function stickToCenter(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToCenterX(object, rigid, layout);
		stickToCenterY(object, rigid, layout);
	}
	
	//Stretch objects to fill the stage (minus any margins)
	//=====================================================
	
	public static function stickToLeftAndRight(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.clampedWidthMinus(layout.scale.baseWidth - object.width, object.baseWidth));
			layout.add(object, Position.rigidInside(object.x, LEFT));
		} else {
			layout.add(object, Size.widthMinus(layout.scale.baseWidth - object.width));
			layout.add(object, Position.inside(object.x, LEFT));
		}
	}
	public static inline function stickToTopAndBottom(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		if(rigid) {
			layout.add(object, Size.clampedHeightMinus(layout.scale.baseHeight - object.height, object.baseHeight));
			layout.add(object, Position.rigidInside(object.y, TOP));
		} else {
			layout.add(object, Size.heightMinus(layout.scale.baseHeight - object.height));
			layout.add(object, Position.inside(object.y, TOP));
		}
	}
	public static inline function stickToAllSides(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		stickToLeftAndRight(object, rigid, layout);
		stickToTopAndBottom(object, rigid, layout);
	}
	
	//Intelligent (?) positioning
	//===========================
	
	/**
	 * Guess which edges the object should stick to, or if it should stick to
	 * the center, or if it should stretch to fill the stage.
	 */
	public static function preserve(object:Resizable, ?rigid:Bool = false, ?layout:Layout):Void {
		layout = check(layout);
		
		if(object.baseWidth > layout.scale.baseWidth / 2) {
			stickToLeftAndRight(object, rigid, layout);
		} else {
			var leftMargin:Float = object.left;
			var rightMargin:Float = layout.scale.baseWidth - object.right;
			var centerDifferenceX:Float = Math.abs(object.centerX - layout.scale.baseWidth / 2);
			
			if(centerDifferenceX < leftMargin && centerDifferenceX < rightMargin) {
				stickToCenterX(object, rigid, layout);
			} else if(leftMargin < rightMargin) {
				stickToLeft(object, rigid, layout);
			} else {
				stickToRight(object, rigid, layout);
			}
		}
		
		if(object.baseHeight > layout.scale.baseHeight / 2) {
			stickToTopAndBottom(object, rigid, layout);
		} else {
			var topMargin:Float = object.top;
			var bottomMargin:Float = layout.scale.baseHeight - object.bottom;
			var centerDifferenceY:Float = Math.abs(object.centerY - layout.scale.baseHeight / 2);
			
			if(centerDifferenceY < topMargin && centerDifferenceY < bottomMargin) {
				stickToCenterY(object, rigid, layout);
			} else if(topMargin < bottomMargin) {
				stickToTop(object, rigid, layout);
			} else {
				stickToBottom(object, rigid, layout);
			}
		}
	}
	
	/**
	 * Guess how to scale all children of the given object.
	 */
	public static inline function preserveChildren(parent:DisplayObjectContainer, ?rigid:Bool = false, ?layout:Layout):Void {
		for(i in 0...parent.numChildren) {
			preserve(parent.getChildAt(i), rigid, layout);
		}
	}
}

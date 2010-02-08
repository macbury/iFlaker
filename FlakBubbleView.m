//
//  FlakBubbleView.m
//  iFlaker
//
//  Created by MacBury on 10-02-08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlakBubbleView.h"

@implementation FlakBubbleView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		flakBubbleImage = [NSImage imageNamed: @"flakEntryBubble"];
        // Initialization code here.
		
		leftWidth = 24; 
		topHeight = 101;
		
		rightWidth = [flakBubbleImage size].width - (leftWidth + 1);
		bottomHeight = [flakBubbleImage size].height - (topHeight + 1);
		
		// Create rectangles in the current image's coordinate system using the measurements in preparation for NSDrawNinePartImage
		topLeftRect = NSMakeRect(0, [flakBubbleImage size].height - topHeight, leftWidth, topHeight);
		topEdgeRect = NSMakeRect(leftWidth, [flakBubbleImage size].height - topHeight, 1, topHeight);
		topRightRect = NSMakeRect([flakBubbleImage size].width - rightWidth, [flakBubbleImage size].height - topHeight, rightWidth, topHeight);
		leftEdgeRect = NSMakeRect(0, bottomHeight, leftWidth, 1);
		centerRect = NSMakeRect(leftWidth, bottomHeight, 1, 1);
		rightEdgeRect = NSMakeRect([flakBubbleImage size].width - rightWidth, bottomHeight, rightWidth, 1);
		bottomLeftRect = NSMakeRect(0, 0, leftWidth, bottomHeight);
		bottomEdgeRect = NSMakeRect(leftWidth, 0, 1, bottomHeight);
		bottomRightRect = NSMakeRect([flakBubbleImage size].width - rightWidth, 0, rightWidth, bottomHeight);
		
		// Create rects for the 9 cropped images
		topLeftTileRect = NSMakeRect(0, 0, topLeftRect.size.width, topLeftRect.size.height);
		topEdgeTileRect = NSMakeRect(0, 0, topEdgeRect.size.width, topEdgeRect.size.height);
		topRightTileRect = NSMakeRect(0, 0, topRightRect.size.width, topRightRect.size.height);
		leftEdgeTileRect = NSMakeRect(0, 0, leftEdgeRect.size.width, leftEdgeRect.size.height);
		centerTileRect = NSMakeRect(0, 0, centerRect.size.width, centerRect.size.height);
		rightEdgeTileRect = NSMakeRect(0, 0, rightEdgeRect.size.width, rightEdgeRect.size.height);
		bottomLeftTileRect = NSMakeRect(0, 0, bottomLeftRect.size.width, bottomLeftRect.size.height);
		bottomEdgeTileRect = NSMakeRect(0, 0, bottomEdgeRect.size.width, bottomEdgeRect.size.height);
		bottomRightTileRect = NSMakeRect(0, 0, bottomRightRect.size.width, bottomRightRect.size.height);
		
		// Create 9 NSImages
		topLeftCorner = [[NSImage alloc] initWithSize:topLeftTileRect.size];
		topEdge = [[NSImage alloc] initWithSize:topEdgeTileRect.size];
		topRightCorner = [[NSImage alloc] initWithSize:topRightTileRect.size];
		leftEdge = [[NSImage alloc] initWithSize:leftEdgeTileRect.size];
		center = [[NSImage alloc] initWithSize:centerTileRect.size];
		rightEdge = [[NSImage alloc] initWithSize:rightEdgeTileRect.size];
		bottomLeftCorner = [[NSImage alloc] initWithSize:bottomLeftTileRect.size];
		bottomEdge = [[NSImage alloc] initWithSize:bottomEdgeTileRect.size];
		bottomRightCorner = [[NSImage alloc] initWithSize:bottomRightTileRect.size];
		
    }
    return self;
}

- (void) dealloc
{
	[topLeftCorner release];
	[topEdge release];
	[topRightCorner release];
	[leftEdge release];
	[center release];
	[rightEdge release];
	[bottomLeftCorner release];
	[bottomEdge release];
	[bottomRightCorner release];
	[super dealloc];
}

- (void)drawRect:(NSRect)fuckThisRect {
	NSRect rect = [self bounds];
	
	[topLeftCorner lockFocus];
	[flakBubbleImage drawInRect:topLeftTileRect
			 fromRect:topLeftRect
			operation:NSCompositeCopy fraction:1.0];
	[topLeftCorner unlockFocus];

	[topEdge lockFocus];
	[flakBubbleImage drawInRect:topEdgeTileRect
			 fromRect:topEdgeRect
			operation:NSCompositeCopy fraction:1.0];
	[topEdge unlockFocus];
	
	[topRightCorner lockFocus];
	[flakBubbleImage drawInRect:topRightTileRect
			 fromRect:topRightRect
			operation:NSCompositeCopy fraction:1.0];
	[topRightCorner unlockFocus];
	
	[leftEdge lockFocus];
	[flakBubbleImage drawInRect:leftEdgeTileRect
			 fromRect:leftEdgeRect
			operation:NSCompositeCopy fraction:1.0];
	[leftEdge unlockFocus];
	
	[center lockFocus];
	[flakBubbleImage drawInRect:centerTileRect
			 fromRect:centerRect
			operation:NSCompositeCopy fraction:1.0];
	[center unlockFocus];
	
	[rightEdge lockFocus];
	[flakBubbleImage drawInRect:rightEdgeTileRect
			 fromRect:rightEdgeRect
			operation:NSCompositeCopy fraction:1.0];
	[rightEdge unlockFocus];

	[bottomLeftCorner lockFocus];
	[flakBubbleImage drawInRect:bottomLeftTileRect
			 fromRect:bottomLeftRect
			operation:NSCompositeCopy fraction:1.0];
	[bottomLeftCorner unlockFocus];

	[bottomEdge lockFocus];
	[flakBubbleImage drawInRect:bottomEdgeTileRect
			 fromRect:bottomEdgeRect
			operation:NSCompositeCopy fraction:1.0];
	[bottomEdge unlockFocus];

	[bottomRightCorner lockFocus];
	[flakBubbleImage drawInRect:bottomRightTileRect
			 fromRect:bottomRightRect
			operation:NSCompositeCopy fraction:1.0];
	[bottomRightCorner unlockFocus];
	
	// Draw with NSDrawNinePartImage
	NSDrawNinePartImage(rect,
						topLeftCorner, topEdge, topRightCorner,
						leftEdge, center, rightEdge,
						bottomLeftCorner, bottomEdge, bottomRightCorner,
						NSCompositeSourceOver, 1.0, NO);

}

@end

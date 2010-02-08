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
        // Initialization code here.
    }
    return self;
}

- (void)drawImage:(NSImage*)image inRect:(NSRect)rect leftCapWidth:(NSInteger)leftWidth topCapHeight:(NSInteger)topHeight
{
	// Calculate the right cap width and the bottom cap height based on the calculation in the iPhone docs
	NSInteger rightWidth = [image size].width - (leftWidth + 1);
	NSInteger bottomHeight = [image size].height - (topHeight + 1);
	
	// Create rectangles in the current image's coordinate system using the measurements in preparation for NSDrawNinePartImage
	NSRect topLeftRect = NSMakeRect(0, [image size].height - topHeight, leftWidth, topHeight);
	NSRect topEdgeRect = NSMakeRect(leftWidth, [image size].height - topHeight, 1, topHeight);
	NSRect topRightRect = NSMakeRect([image size].width - rightWidth, [image size].height - topHeight, rightWidth, topHeight);
	NSRect leftEdgeRect = NSMakeRect(0, bottomHeight, leftWidth, 1);
	NSRect centerRect = NSMakeRect(leftWidth, bottomHeight, 1, 1);
	NSRect rightEdgeRect = NSMakeRect([image size].width - rightWidth, bottomHeight, rightWidth, 1);
	NSRect bottomLeftRect = NSMakeRect(0, 0, leftWidth, bottomHeight);
	NSRect bottomEdgeRect = NSMakeRect(leftWidth, 0, 1, bottomHeight);
	NSRect bottomRightRect = NSMakeRect([image size].width - rightWidth, 0, rightWidth, bottomHeight);
	
	// Create rects for the 9 cropped images
	NSRect topLeftTileRect = NSMakeRect(0, 0, topLeftRect.size.width, topLeftRect.size.height);
	NSRect topEdgeTileRect = NSMakeRect(0, 0, topEdgeRect.size.width, topEdgeRect.size.height);
	NSRect topRightTileRect = NSMakeRect(0, 0, topRightRect.size.width, topRightRect.size.height);
	NSRect leftEdgeTileRect = NSMakeRect(0, 0, leftEdgeRect.size.width, leftEdgeRect.size.height);
	NSRect centerTileRect = NSMakeRect(0, 0, centerRect.size.width, centerRect.size.height);
	NSRect rightEdgeTileRect = NSMakeRect(0, 0, rightEdgeRect.size.width, rightEdgeRect.size.height);
	NSRect bottomLeftTileRect = NSMakeRect(0, 0, bottomLeftRect.size.width, bottomLeftRect.size.height);
	NSRect bottomEdgeTileRect = NSMakeRect(0, 0, bottomEdgeRect.size.width, bottomEdgeRect.size.height);
	NSRect bottomRightTileRect = NSMakeRect(0, 0, bottomRightRect.size.width, bottomRightRect.size.height);
	
	// Create 9 NSImages and draw them into the tile rects
	NSImage *topLeftCorner = [[NSImage alloc] initWithSize:topLeftTileRect.size];
	[topLeftCorner lockFocus];
	[image drawInRect:topLeftTileRect
			 fromRect:topLeftRect
			operation:NSCompositeCopy fraction:1.0];
	[topLeftCorner unlockFocus];
	
	NSImage *topEdge = [[NSImage alloc] initWithSize:topEdgeTileRect.size];
	[topEdge lockFocus];
	[image drawInRect:topEdgeTileRect
			 fromRect:topEdgeRect
			operation:NSCompositeCopy fraction:1.0];
	[topEdge unlockFocus];
	
	NSImage *topRightCorner = [[NSImage alloc] initWithSize:topRightTileRect.size];
	[topRightCorner lockFocus];
	[image drawInRect:topRightTileRect
			 fromRect:topRightRect
			operation:NSCompositeCopy fraction:1.0];
	[topRightCorner unlockFocus];
	
	NSImage *leftEdge = [[NSImage alloc] initWithSize:leftEdgeTileRect.size];
	[leftEdge lockFocus];
	[image drawInRect:leftEdgeTileRect
			 fromRect:leftEdgeRect
			operation:NSCompositeCopy fraction:1.0];
	[leftEdge unlockFocus];
	
	NSImage *center = [[NSImage alloc] initWithSize:centerTileRect.size];
	[center lockFocus];
	[image drawInRect:centerTileRect
			 fromRect:centerRect
			operation:NSCompositeCopy fraction:1.0];
	[center unlockFocus];
	
	NSImage *rightEdge = [[NSImage alloc] initWithSize:rightEdgeTileRect.size];
	[rightEdge lockFocus];
	[image drawInRect:rightEdgeTileRect
			 fromRect:rightEdgeRect
			operation:NSCompositeCopy fraction:1.0];
	[rightEdge unlockFocus];
	
	NSImage *bottomLeftCorner = [[NSImage alloc] initWithSize:bottomLeftTileRect.size];
	[bottomLeftCorner lockFocus];
	[image drawInRect:bottomLeftTileRect
			 fromRect:bottomLeftRect
			operation:NSCompositeCopy fraction:1.0];
	[bottomLeftCorner unlockFocus];
	
	NSImage *bottomEdge = [[NSImage alloc] initWithSize:bottomEdgeTileRect.size];
	[bottomEdge lockFocus];
	[image drawInRect:bottomEdgeTileRect
			 fromRect:bottomEdgeRect
			operation:NSCompositeCopy fraction:1.0];
	[bottomEdge unlockFocus];
	
	NSImage *bottomRightCorner = [[NSImage alloc] initWithSize:bottomRightTileRect.size];
	[bottomRightCorner lockFocus];
	[image drawInRect:bottomRightTileRect
			 fromRect:bottomRightRect
			operation:NSCompositeCopy fraction:1.0];
	[bottomRightCorner unlockFocus];
	
	// Draw with NSDrawNinePartImage
	NSDrawNinePartImage(rect,
						topLeftCorner, topEdge, topRightCorner,
						leftEdge, center, rightEdge,
						bottomLeftCorner, bottomEdge, bottomRightCorner,
						NSCompositeSourceOver, 1.0, NO);
	
	[topLeftCorner release];
	[topEdge release];
	[topRightCorner release];
	[leftEdge release];
	[center release];
	[rightEdge release];
	[bottomLeftCorner release];
	[bottomEdge release];
	[bottomRightCorner release];
}

- (NSImage *) flakBubbleImage {
	if (flakBubbleImage == nil) {
		flakBubbleImage = [NSImage imageNamed: @"flakBubble"];
	}
	
	return flakBubbleImage;
} 

- (void)drawRect:(NSRect)rect {
    [self drawImage: [self flakBubbleImage] inRect: [self bounds] leftCapWidth:21 topCapHeight:12];
}

@end

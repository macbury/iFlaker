//
//  FlakBubbleView.h
//  iFlaker
//
//  Created by MacBury on 10-02-08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FlakBubbleView : NSView {
	NSImage * flakBubbleImage;
	
	NSInteger rightWidth;
	NSInteger bottomHeight;
	
	NSInteger leftWidth; 
	NSInteger topHeight;
	
	// Create rectangles in the current image's coordinate system using the measurements in preparation for NSDrawNinePartImage
	NSRect topLeftRect;
	NSRect topEdgeRect;
	NSRect topRightRect;
	NSRect leftEdgeRect;
	NSRect centerRect;
	NSRect rightEdgeRect;
	NSRect bottomLeftRect;
	NSRect bottomEdgeRect;
	NSRect bottomRightRect;
	
	
	// Create rects for the 9 cropped images
	NSRect topLeftTileRect;
	NSRect topEdgeTileRect;
	NSRect topRightTileRect;
	NSRect leftEdgeTileRect;
	NSRect centerTileRect;
	NSRect rightEdgeTileRect;
	NSRect bottomLeftTileRect;
	NSRect bottomEdgeTileRect;
	NSRect bottomRightTileRect;
	
	NSImage *topLeftCorner;
	NSImage *topEdge;
	NSImage *topRightCorner;
	NSImage *leftEdge;
	NSImage *center;
	NSImage *rightEdge;
	NSImage *bottomLeftCorner;
	NSImage *bottomEdge;
	NSImage *bottomRightCorner;
}

@end

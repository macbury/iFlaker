//
//  FlakController.m
//  iFlaker
//
//  Created by MacBury on 10-02-07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlakController.h"

@implementation FlakController

@synthesize flak;

- (id) initWithFlak:(Flak*)newFlak {
	self = [super init];
	if (self != nil) {
		[self setFlak:newFlak];
		if (![NSBundle loadNibNamed: @"flakCell" owner: self]) {
            [self release];
            self = nil;
        }
		
	}
	return self;
}

-(void) resizeToFitBody {
	NSSize size = [bodyTextField frame].size;
	NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithAttributedString:[bodyTextField attributedStringValue]]autorelease];
	NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(size.width, FLT_MAX)] autorelease];
	NSLayoutManager *layoutManager = [[[NSLayoutManager alloc]init] autorelease];
	
	[layoutManager addTextContainer:textContainer];
	[textStorage addLayoutManager:layoutManager];

	[textContainer setLineFragmentPadding:2.0];
	[layoutManager glyphRangeForTextContainer:textContainer];
	
	// Body Text
	CGFloat textHeight = [layoutManager usedRectForTextContainer:textContainer].size.height;
	
	// Bubble Height 
	float bubbleVerticalPadding = 13.0;
	
	CGFloat bubbleHeight = textHeight + (bubbleVerticalPadding * 2) + 17;
	bubbleHeight = MAX(bubbleHeight, 80.0);
	
	// View Height
	float viewVerticalPadding = 10.0;
	NSSize viewBoxSize = [subview frame].size;
	
	viewBoxSize.height = bubbleHeight + (viewVerticalPadding * 2);
	[subview setFrameSize: viewBoxSize];
}

- (void) awakeFromNib {
	[loginTextField setStringValue: flak.login];
	[bodyTextField setStringValue: flak.body];
	[self resizeToFitBody];
}

- (void) dealloc
{
    [subview release];
    [flak release];
    [super dealloc];
}

- (NSView *) view {
    return subview;
}

@end

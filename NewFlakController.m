//
//  NewFlakController.m
//  iFlaker
//
//  Created by MacBury on 10-02-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewFlakController.h"


@implementation NewFlakController

@synthesize window;

- (id) init {
	self = [super init];
	if (self != nil) {
		if (![NSBundle loadNibNamed: @"NewFlak" owner: self]) {
            [self release];
            self = nil;
        }
	}
	return self;
}

- (void) awakeFromNib {
	[contentView setBoxType: NSBoxCustom];
	[contentView setBorderType:  NSLineBorder];
	[contentView setCornerRadius: 3.0];
	[contentView setFillColor: [NSColor windowBackgroundColor]];
}

- (void)windowDidExpose:(NSNotification *)notification {
	NSLog(@"Pokazanie okna tworzenia nowego flaka...");
	[contentTextView setTextColor: [NSColor whiteColor]];
	[contentTextView setString: @""];
}

- (IBAction) postMessage:(id)sender {
	
}

@end

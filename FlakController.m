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

- (void) awakeFromNib {
	[loginTextField setStringValue: flak.login];
	[bodyTextField setStringValue: flak.body];
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

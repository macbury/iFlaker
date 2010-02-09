//
//  AuthController.m
//  iFlaker
//
//  Created by MacBury on 10-02-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AuthController.h"

@implementation AuthController

@synthesize view, flaker;

- (id) init {
	self = [super init];
	if (self != nil) {
		if (![NSBundle loadNibNamed: @"AuthController" owner: self]) {
            [self release];
            self = nil;
        }
		
	}
	return self;
}

- (void) setControllState:(BOOL)enabled {
	[openFlakerPageButton setEnabled: enabled];
	[validatePinButton setEnabled: enabled];
	[pinTextField setEnabled: enabled];
	
	if (enabled) {
		[progressIndicator stopAnimation: self];
	}else{
		[progressIndicator startAnimation: self];
	}
}

- (IBAction) openFlakerPage:(id)sender {
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://flaker.pl/oauth/authorize?oauth_token=%@", flaker.requestToken.key]];
	
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction) validatePin:(id)sender {
	[self setControllState: NO];
}

- (void) dealloc
{
	[flaker release];
	[super dealloc];
}


@end

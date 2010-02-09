//
//  AuthController.m
//  iFlaker
//
//  Created by MacBury on 10-02-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AuthController.h"

@implementation AuthController

@synthesize view;

- (id) initWithFlaker:(Flaker *) flaker {
	self = [super init];
	if (self != nil) {
		pinVerificator = [[FlakerOAuthPinVerificator alloc] initWithAuthFlaker: flaker];
		[pinVerificator setDelegate: self];
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
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://flaker.pl/oauth/authorize?oauth_token=%@", pinVerificator.flaker.requestToken.key]];
	
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction) validatePin:(id)sender {
	if ([pinTextField stringValue] != @"") {
		[self setControllState: NO];
		[pinVerificator authorizeFlakerTokenWithVerifier: [pinTextField stringValue]];
	}

}

- (IBAction) closeSheet:(id)sender {
	[NSApp endSheet:[self view]];
	exit(0);
}

- (void) oAuthPinVerificationSuccessful:(OAToken *)accessToken {
	[accessToken storeInDefaultKeychainWithAppName:@"iFlaker"
                               serviceProviderName:@"flaker.pl"];
	[NSApp endSheet:[self view]];
	[pinVerificator.flaker refreshFriends];
}

- (void) oAuthPinVerificationFail {
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText:@"iFlaker"];
	[alert setInformativeText:@"Kod pin jest nieprawidłowy!"];
	[alert setAlertStyle:NSWarningAlertStyle];
	
	[alert runModal];
	
	[self setControllState: YES];
}


- (void) dealloc {
	[pinVerificator release];
	[super dealloc];
}


@end

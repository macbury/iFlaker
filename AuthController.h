//
//  AuthController.h
//  iFlaker
//
//  Created by MacBury on 10-02-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Flaker.h"
#import "FlakerOAuthPinVerificator.h"

@interface AuthController : NSObject <FlakerOAuthPinVerificatorDelegate> {
	IBOutlet NSWindow * view;
	IBOutlet NSButton * openFlakerPageButton;
	IBOutlet NSButton * validatePinButton;
	IBOutlet NSTextField * pinTextField;
	IBOutlet NSProgressIndicator * progressIndicator;
	
	FlakerOAuthPinVerificator * pinVerificator;
}

@property (retain) NSWindow * view;

- (id) initWithFlaker:(Flaker *) flaker;

- (IBAction) openFlakerPage:(id)sender;
- (IBAction) validatePin:(id)sender;
- (IBAction) closeSheet:(id)sender;

- (void) setControllState:(BOOL)enabled;

@end

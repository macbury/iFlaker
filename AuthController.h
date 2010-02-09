//
//  AuthController.h
//  iFlaker
//
//  Created by MacBury on 10-02-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Flaker.h"

@interface AuthController : NSObject {
	IBOutlet NSWindow * view;
	IBOutlet NSButton * openFlakerPageButton;
	IBOutlet NSButton * validatePinButton;
	IBOutlet NSTextField * pinTextField;
	IBOutlet NSProgressIndicator * progressIndicator;
	
	Flaker * flaker;
}

@property (retain) NSWindow * view;
@property (retain) Flaker * flaker;

- (IBAction) openFlakerPage:(id)sender;
- (IBAction) validatePin:(id)sender;

- (void) setControllState:(BOOL)enabled;

@end

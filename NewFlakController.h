//
//  NewFlakController.h
//  iFlaker
//
//  Created by MacBury on 10-02-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlakerPost.h"

@interface NewFlakController : NSObject <FlakerPostDelegate> {
	IBOutlet NSTextView * contentTextView;
	IBOutlet NSProgressIndicator * progressIndicator;
	IBOutlet NSButton * flaknijButton;
	IBOutlet NSButton * attachPhotoButton;
	
	FlakerPost * flakerPost;
}

- (void) setFlaker:(Flaker *) newFlaker;
- (IBAction) postMessage:(id)sender;

@end

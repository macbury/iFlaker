//
//  NewFlakController.h
//  iFlaker
//
//  Created by MacBury on 10-02-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NewFlakController : NSObject {
	IBOutlet NSWindow * window;
	IBOutlet NSBox * contentView;
	IBOutlet NSTextView * contentTextView;
	IBOutlet NSProgressIndicator * progressIndicator;
}

@property (retain) NSWindow * window;

- (IBAction) postMessage:(id)sender;

@end

//
//  SubviewController.h
//  SubviewTableViewTester
//
//  Created by Joar Wingfors on Tue Dec 02 2003.
//  Copyright (c) 2003 joar.com. All rights reserved.
//

/*****************************************************************************

SubviewController

Overview:

The SubviewController is a very simple class. It is the controller object for
the custom views used in the table. It provides the view, and answers to
actions methods from the view or the table view controller.

*****************************************************************************/

#import <AppKit/AppKit.h>
#import "Flak.h"

@interface SubviewController : NSObject {
    Flak * flak;
	
	IBOutlet NSView *subview;
	IBOutlet NSTextField * loginTextField;
	IBOutlet NSTextField * bodyTextField;
	IBOutlet NSBox * contentBox;
}

@property (retain) Flak * flak;
// Convenience factory method
+ (id) controller;

// The view displayed in the table view
- (NSView *) view;

@end

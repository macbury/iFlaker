//
//  controller.h
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "flaker.h"

@interface Controller : NSObject <FlakerDelegate> {
	IBOutlet NSTableView * flakiTableView;
	IBOutlet NSProgressIndicator * progressIndicator;
	
	Flaker * flaker;
}

- (IBAction) refresh:(id)sender;

@end

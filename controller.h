//
//  controller.h
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "flaker.h"
#import "FlakCell.h"

@interface Controller : NSObject <FlakerDelegate> {
	IBOutlet NSTableView * flakiTableView;
	IBOutlet NSProgressIndicator * progressIndicator;
	IBOutlet NSTableColumn * flakiTableColumn;
	IBOutlet NSButton * refreshButton;
	IBOutlet NSPopUpButton * typePopUpButton;
	
	Flaker * flaker;
	
	NSNumber * refreshRate;
	NSTimer * updateTimer;
}

@property (retain) NSNumber * refreshRate;

- (IBAction) refresh:(id)sender;
- (IBAction) typeChange:(id)sender;

@end

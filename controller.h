//
//  controller.h
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>
#import "flaker.h"

#import "FlakController.h"
#import "SubviewTableViewController.h"
#import "FileStore.h"

@interface Controller : NSObject <FlakerDelegate, GrowlApplicationBridgeDelegate, SubviewTableViewControllerDataSourceProtocol> {
	IBOutlet NSWindow * mainWindow;
	IBOutlet NSButton * refreshButton;
	IBOutlet NSPopUpButton * typePopUpButton;
	
	IBOutlet NSTableView * flakiTableView;
	IBOutlet NSTableColumn * flakTableColumn;
	
	SubviewTableViewController *flakiTableViewController;
	
	Flaker * flaker;
	NSMutableArray * flakiArray;
	NSSound * otrzymaneFlakiSound;
	
	NSNumber * refreshRate;
	NSNumber * flakInListLimit;
	NSTimer * updateTimer;
}

@property (retain) NSNumber * refreshRate;
@property (retain) NSNumber * flakInListLimit;
@property (retain) NSMutableArray * flakiArray;

- (IBAction) refresh:(id)sender;
- (IBAction) typeChange:(id)sender;
- (void) afterCompleteFetch;
- (void)growlAboutFlak:(Flak *)flak;

@end

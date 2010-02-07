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
#import <Growl/Growl.h>

@interface Controller : NSObject <FlakerDelegate, GrowlApplicationBridgeDelegate> {
	IBOutlet NSCollectionView * flakiCollectionView;
	IBOutlet NSArrayController * flakiArrayController;
	
	IBOutlet NSWindow * mainWindow;
	
	IBOutlet NSButton * refreshButton;
	IBOutlet NSPopUpButton * typePopUpButton;
	
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

//
//  controller.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import "controller.h"

@implementation Controller

@synthesize refreshRate, flakiArray;

- (id) init {
	self = [super init];
	if (self != nil) {
		flakiArray = [[NSMutableArray alloc] init];
		
		flaker = [[Flaker alloc] initWithLogin:@"bury"];
		[self setRefreshRate: [[NSNumber alloc] initWithInt:10]];
		[flaker setDelegate: self];
		[GrowlApplicationBridge setGrowlDelegate:self];
	}
	return self;
}

- (void) awakeFromNib {
	NSSize size = NSMakeSize([mainWindow frame].size.width - 16, 80);
	[flakiCollectionView setMinItemSize:size];
	[flakiCollectionView setMaxItemSize:size];
	
	[flaker refreshFriends];
}

- (void) dealloc {
	[flakiArray release];
	[refreshRate release];
	[flaker release];
	[updateTimer release];
	[super dealloc];
}

// Growl Delegate

- (void) growlNotificationWasClicked:(id)clickContext {
	//[self activateIgnoringOtherApps:YES];
	//[mainWindow 
	NSLog(@"Kliknięto na dymek!");
}

- (NSDictionary *) registrationDictionaryForGrowl {
	NSArray *notifications = [NSArray arrayWithObject: @"NoweFlaki"];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
												notifications, GROWL_NOTIFICATIONS_ALL,
												notifications, GROWL_NOTIFICATIONS_DEFAULT, nil];
	
	return dict;
}

- (void)growlAboutFlak:(Flak *)flak {
	[GrowlApplicationBridge notifyWithTitle: flak.login
															description: flak.body
												 notificationName:@"NoweFlaki"
																 iconData: nil //[NSBundle bundleWithIdentifier: "avatarDefault"]
																 priority:1
																 isSticky:NO
														 clickContext:@"test"];
}

// NSWindow Delegate

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
	
	NSSize size = NSMakeSize(frameSize.width - 16, 80);
	[flakiCollectionView setMinItemSize:size];
	[flakiCollectionView setMaxItemSize:size];
	
	return frameSize;
}

// Flaker Api delegate 

- (void)startFetchingFromFlaker {
	[updateTimer release];
	updateTimer = nil;
	[refreshButton setEnabled: NO];
	[typePopUpButton setEnabled: NO];

}

- (void)afterCompleteFetch {
	[refreshButton setEnabled: YES];
	[typePopUpButton setEnabled: YES];
	
	[flakiCollectionView scrollPageUp: self];
	
	updateTimer = [NSTimer scheduledTimerWithTimeInterval: [self.refreshRate doubleValue]
																								 target: self 
																							 selector: @selector(refresh:) 
																							 userInfo: nil 
																								repeats: NO];
}

- (void)completeFetchingFromFlaker:(NSArray *) flaki {
	
	for(int i = 0; i < [flaki count]; i++) {
		Flak * flak = [flaki objectAtIndex: i];
		
		[flakiArrayController insertObject: flak atArrangedObjectIndex: 0];
		
		if (i <= 5) { [self growlAboutFlak: flak]; }
	}
	
	if ([flaki count] > 5) {
	
		[GrowlApplicationBridge notifyWithTitle: @"iFlaker"
																description: [NSString stringWithFormat: @"Zostało jeszcze %@ flaków", [NSNumber numberWithInt:[flaki count] - 5]]
													 notificationName:@"NoweFlaki"
																	 iconData: nil //[NSBundle bundleWithIdentifier: "avatarDefault"]
																	 priority:1
																	 isSticky:NO
															 clickContext:@"test"];
	}
	
	[self afterCompleteFetch];
}

- (void)errorOnFetchFromFlaker:(NSError *)error {
	[self afterCompleteFetch];
}

// Actions

- (IBAction) refresh:(id)sender {
	[flaker refreshFriends];
	
}

- (IBAction) typeChange:(id)sender {
	NSLog(@"Wybrano opcje:");
}

@end

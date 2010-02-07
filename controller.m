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
		[self setRefreshRate: [[NSNumber alloc] initWithInt:20]];
		[flaker setDelegate: self];
	}
	return self;
}

- (void) awakeFromNib {
	NSSize size = NSMakeSize(250, 80);
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

// Flaker Api delegate 

- (void)startFetchingFromFlaker {
	[updateTimer release];
	updateTimer = nil;
	[refreshButton setEnabled: NO];
	[typePopUpButton setEnabled: NO];

}

- (void)completeFetchingFromFlaker:(NSArray *) flaki {
	[refreshButton setEnabled: YES];
	[typePopUpButton setEnabled: YES];
	
	for(Flak * flak in flaki) {
		[flakiArrayController addObject: flak];
	}
	
	//NSInteger numberOfRows = [flakiTableView numberOfRows];
	
	//if (numberOfRows > 0) {
	//	[flakiTableView scrollRowToVisible:numberOfRows - 1];
	//}
	
	updateTimer = [NSTimer scheduledTimerWithTimeInterval: [self.refreshRate doubleValue]
																								 target: self 
																							 selector: @selector(refresh:) 
																							 userInfo: nil 
																								repeats: NO];
}

- (void)errorOnFetchFromFlaker:(NSError *)error {
	// coś z panelem
}

// Actions

- (IBAction) refresh:(id)sender {
	[flaker refreshFriends];
	
}

- (IBAction) typeChange:(id)sender {
	NSLog(@"Wybrano opcje:");
}

@end

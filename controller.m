//
//  controller.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import "controller.h"

@implementation Controller

@synthesize refreshRate;

- (id) init {
	self = [super init];
	if (self != nil) {
		flaker = [[Flaker alloc] initWithLogin:@"bury"];
		[self setRefreshRate: [[NSNumber alloc] initWithInt:20]];
		[flaker setDelegate: self];
	}
	return self;
}

- (void) awakeFromNib {
	FlakCell * flakCell = [[FlakCell alloc] init];
	[flakiTableColumn setDataCell:flakCell];
	
	[flaker refreshFriends];
}

- (void) dealloc {
	[refreshRate release];
	[flaker release];
	[updateTimer release];
	[super dealloc];
}

// Table Delegate

- (int) numberOfRowsInTableView:(NSTableView *)tableView {
	return [[flaker flaki] count];
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
	return NO;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	return 60;
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex {	
	aCell = (FlakCell *)aCell;
	[aCell setFlak: [[flaker flaki] objectAtIndex:rowIndex]];
}

// Flaker Api delegate 

- (void)startFetchingFromFlaker {
	[updateTimer release];
	updateTimer = nil;
	[refreshButton setEnabled: NO];
	[typePopUpButton setEnabled: NO];
	//[progressIndicator startAnimation: self];
}

- (void)completeFetchingFromFlaker {
	[refreshButton setEnabled: YES];
	[typePopUpButton setEnabled: YES];
	//[progressIndicator stopAnimation: self];
	[flakiTableView reloadData];
	
	NSInteger numberOfRows = [flakiTableView numberOfRows];
	
	if (numberOfRows > 0) {
		[flakiTableView scrollRowToVisible:numberOfRows - 1];
	}
	
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

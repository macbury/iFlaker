//
//  controller.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import "controller.h"

@implementation Controller

- (id) init {
	self = [super init];
	if (self != nil) {
		flaker = [[Flaker alloc] initWithLogin:@"bury"];
		[flaker setDelegate: self];
	}
	return self;
}

- (void) awakeFromNib {
}

- (void) dealloc {
	[flaker release];
	[super dealloc];
}

// Table Delegate

- (int) numberOfRowsInTableView:(NSTableView *)tableView {
	return [[flaker flaki] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row {
	Flak * flak = [[flaker flaki] objectAtIndex:row];
	
	if ([[tableColumn identifier] isEqual: @"login"]) {
		return [flak login];
	}else{
		return [flak body];
	}
	
}

// Flaker Api delegate 

- (void)startFetchingFromFlaker {
	[progressIndicator startAnimation: self];
}

- (void)completeFetchingFromFlaker {
	[progressIndicator stopAnimation: self];
	[flakiTableView reloadData];
}

- (void)errorOnFetch:(NSError *)error {
	// coś z panelem
}

// Actions

- (IBAction) refresh:(id)sender {
	[flaker refreshFriends];
	
}

@end

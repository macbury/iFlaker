//
//  controller.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "controller.h"


@implementation Controller

- (id) init {
	self = [super init];
	if (self != nil) {
		flaki = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) awakeFromNib {
	[flakiTableView reloadData];
}

- (void) dealloc {
	for (int i = 0; i < [flaki count]; i++) {
		[[flaki objectAtIndex: i] release];
	}
	[flaki release];
	[super dealloc];
}

- (int) numberOfRowsInTableView:(NSTableView *)tableView {
	return [flaki count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row {
	Flak * flak = [flaki objectAtIndex:row];
	
	if ([[tableColumn identifier] isEqual: @"login"]) {
		return [flak login];
	}else{
		return [flak body];
	}
	
}

- (IBAction) refresh:(id)sender {
	Flak * flak = [[Flak alloc] initWithLogin:@"Macbury" body:@"Wpis testowy!"];
	[flaki addObject: flak];
	[flakiTableView reloadData];
}

@end

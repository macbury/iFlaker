//
//  NewFlakController.m
//  iFlaker
//
//  Created by MacBury on 10-02-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewFlakController.h"


@implementation NewFlakController

- (void) setFlaker:(Flaker *) newFlaker {
	if (flakerPost == nil){
		flakerPost = [[FlakerPost alloc] initWithFlaker: newFlaker];
		[flakerPost setDelegate: self];
	}
	[flakerPost setFlaker: newFlaker];
}

- (void) dealloc {
	[flakerPost release];
	[super dealloc];
}

- (void) setControlsEnabled:(BOOL)enabled {
	[contentTextView setEditable: enabled];
	[flaknijButton setEnabled: enabled];
	[attachPhotoButton setEnabled: enabled];
}

- (void) awakeFromNib {
	[contentTextView setString: @""];
}


- (void) flakHaveBeenPostedToFlaker {
	[contentTextView setString: @""];
	[self setControlsEnabled: YES];
}

- (void) flakHaventBeenPostedToFlaker:(NSError *)error {
	[NSAlert alertWithError: error];
	[self setControlsEnabled: YES];
}

- (IBAction) postMessage:(id)sender {
	if ([[contentTextView string] isEqualToString: @""]) {
		NSAlert *alert = [[[NSAlert alloc] init] autorelease];
		[alert addButtonWithTitle:@"OK"];
		[alert setMessageText:@"iFlaker"];
		[alert setInformativeText:@"Nie można dodać pustego flaka!"];
		[alert setAlertStyle:NSWarningAlertStyle];
		
		[alert runModal];
	} else {
		[self setControlsEnabled: NO];
		[flakerPost postFlak: [contentTextView string] link:nil images: nil];
	}
}

@end

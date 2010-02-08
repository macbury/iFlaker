//
//  controller.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import "controller.h"

@implementation Controller

@synthesize refreshRate, flakiArray, flakInListLimit;

- (id) init {
	self = [super init];
	if (self != nil) {
		flakiArray = [[NSMutableArray alloc] init];
		
		flaker = [[Flaker alloc] initWithLogin:@"bury"];
		[self setRefreshRate: [[NSNumber alloc] initWithInt:10]];
		[self setFlakInListLimit: [NSNumber numberWithInt: 20]];
		
		[flaker setDelegate: self];
		[GrowlApplicationBridge setGrowlDelegate:self];
		
		NSString* soundFile = [[NSBundle mainBundle] pathForResource:@"otrzymanoFlaki" ofType:@"mp3"];
		otrzymaneFlakiSound = [[NSSound alloc] initWithContentsOfFile:soundFile byReference:YES];
	}
	return self;
}

- (void) awakeFromNib {
	flakiTableViewController = [[SubviewTableViewController controllerWithViewColumn: flakTableColumn] retain];
	[flakiTableViewController setDelegate: self];
	
	[flaker refreshFriends];
}

- (void) dealloc {
	[flakiTableViewController release];
	[otrzymaneFlakiSound release];
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

// Flaker Api delegate 

- (void)startFetchingFromFlaker {
	if (updateTimer != nil) {
		[updateTimer release];
		updateTimer = nil;
	}
	[refreshButton setEnabled: NO];
	[typePopUpButton setEnabled: NO];

}

- (void)afterCompleteFetch {
	[refreshButton setEnabled: YES];
	[typePopUpButton setEnabled: YES];
	[flakiTableViewController reloadTableView];
	//[flakiCollectionView scrollPageUp: self];
	
	updateTimer = [NSTimer scheduledTimerWithTimeInterval: [self.refreshRate doubleValue]
																								 target: self 
																							 selector: @selector(refresh:) 
																							 userInfo: nil 
																								repeats: NO];
}

- (void)completeFetchingFromFlaker:(NSArray *) flaki {
	
	if ([flaki count] > 0) {
		[otrzymaneFlakiSound play];
	}
	
	for(int i = 0; i < [flaki count]; i++) {
		Flak * flak = [flaki objectAtIndex: i];
		
		FlakController * fc = [[[FlakController alloc] initWithFlak: flak] autorelease];
		[flakiArray insertObject:fc atIndex:i];
		
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
	

	if ([flakiArray count] > [flakInListLimit integerValue]) {
		NSLog(@"Jest ponad %@ flaków... Usuwam zbyteczne...", flakInListLimit);
		
		int flakToRemoveIndex = [flakiArray count] - [flakInListLimit intValue];
		
		for (int i=0; i < flakToRemoveIndex; i++) {
			[flakiArray removeLastObject];
		}
	}
	
	[self afterCompleteFetch];
}

- (void)errorOnFetchFromFlaker:(NSError *)error {
	[self afterCompleteFetch];
}

// NSTable Delegate Methods

- (void) tableViewColumnDidResize {
	NSMutableIndexSet * indexSet = [[[NSMutableIndexSet alloc] init] autorelease];
	
	for(int i=0; i < [flakiTableView numberOfRows]; i++) {
		[indexSet addIndex: i];
	}
	
	[flakiTableView noteHeightOfRowsWithIndexesChanged:indexSet]; // Wie ktoś jak to zoptymalizować?
}

- (NSView *) tableView:(NSTableView *) tableView viewForRow:(int) row {
	return [[flakiArray objectAtIndex: row] view];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	FlakController * flakController = [flakiArray objectAtIndex: row];
	[flakController resizeToFitBody];
	
	return [[flakController view] frame].size.height;
}

- (int) numberOfRowsInTableView:(NSTableView *) tableView {
	return [flakiArray count];
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
	return NO;
}

// Actions

- (IBAction) refresh:(id)sender {
	[flaker refreshFriends];
	
}

- (IBAction) typeChange:(id)sender {
	NSLog(@"Wybrano opcje:");
}

@end

//
//  controller.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import "Controller.h"

@implementation Controller

@synthesize refreshRate, flakiArray, flakInListLimit;

- (id) init {
	self = [super init];
	if (self != nil) {
		flakiArray = [[NSMutableArray alloc] init];
		
		flaker = [[Flaker alloc] init];
		[self setRefreshRate: [[NSNumber alloc] initWithInt:10]];
		[self setFlakInListLimit: [NSNumber numberWithInt: 20]];
		
		[flaker setDelegate: self];
		[GrowlApplicationBridge setGrowlDelegate:self];
		
		otrzymaneFlakiSound = [[NSSound alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"otrzymanoFlaki" ofType:@"m4a"] 
																											byReference:YES];
		errorSound = [[NSSound alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"error" ofType:@"m4a"] 
																						 byReference:YES];
	}
	return self;
}

- (void) dealloc {
	[errorSound release];
	[newFlakController release];
	[authContoller release];
	[flakiTableViewController release];
	[otrzymaneFlakiSound release];
	[flakiArray release];
	[refreshRate release];
	[flaker release];
	[updateTimer release];
	[super dealloc];
}

- (void) awakeFromNib {
	flakiTableViewController = [[SubviewTableViewController controllerWithViewColumn: flakTableColumn] retain];
	[flakiTableViewController setDelegate: self];
	[newFlakController setFlaker: flaker];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[flaker authorizeUsingOAuth: @"iFlaker" serviveProviderName: @"flaker.pl"];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	NSFileManager * fm = [NSFileManager defaultManager];
	[fm removeItemAtPath: [FileStore pathForImage: @"" ] error:nil];
	
	return NSTerminateNow;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)aApplication 
										hasVisibleWindows:(BOOL)aFlag {
	[mainWindow makeKeyAndOrderFront:self];
	return YES;
}

- (void)applicationDidBecomeActive:(NSNotification *)aNotification {
	show_flaks_badgage = NO;
	new_flaks_count = 0;
	//NSDockTile * icon = [NSApp dockTile];
	[[NSApp dockTile] setBadgeLabel: @""];
	//[icon setShowsApplicationBadge: NO];
}

- (void)applicationDidResignActive:(NSNotification *)aNotification {
	show_flaks_badgage = YES;
	new_flaks_count = 0;
	//[[NSApp dockTile] setShowsApplicationBadge: YES];
}

// Growl Delegate

- (void) growlNotificationWasClicked:(id)clickContext {
	[NSApp activateIgnoringOtherApps: YES];
	//[mainWindow 
}

- (NSDictionary *) registrationDictionaryForGrowl {
	NSArray *notifications = [NSArray arrayWithObject: @"NoweFlaki"];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
												notifications, GROWL_NOTIFICATIONS_ALL,
												notifications, GROWL_NOTIFICATIONS_DEFAULT, nil];
	
	return dict;
}

- (void)growlAboutFlak:(Flak *)flak {
	NSData * avatarImage;
	
	if ([FileStore avatarExist: [flak.user avatarName]]){
		avatarImage = [flak.user.avatarImage TIFFRepresentation];
	} else {
		avatarImage = nil;
	}
	
	[GrowlApplicationBridge notifyWithTitle: flak.user.login
															description: flak.body
												 notificationName:@"NoweFlaki"
																 iconData: avatarImage 
																 priority:1
																 isSticky:NO
														 clickContext: 0];
}

// Flaker Api delegate 

- (void) haveOAuthTokenFromFlaker:(OAToken *)requestToken {
	authContoller = [[AuthController alloc] initWithFlaker: flaker];
	
	[NSApp beginSheet: [authContoller view]
		 modalForWindow: mainWindow
			modalDelegate: self
		 didEndSelector: @selector(didAuthorizeFlaker:returnCode:contextInfo:)
				contextInfo: nil];
}

- (void)didAuthorizeFlaker:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	[sheet orderOut: self];
	[authContoller release];
	[self refresh: self];
}

- (void) cannotFetchOAuthTokenFromFlaker {
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText:@"iFlaker"];
	[alert setInformativeText:@"Nie można pobrać kodu oAuth z flaker.pl"];
	[alert setAlertStyle:NSWarningAlertStyle];
	
	[alert runModal];
}

- (void)startFetchingFromFlaker {
	if (updateTimer != nil) {
		[updateTimer release];
		updateTimer = nil;
	}
	[refreshButton setEnabled: NO];
	[typePopUpButton setEnabled: NO];

}

- (void)afterCompleteFetch {
	updateTimer = [NSTimer scheduledTimerWithTimeInterval: [self.refreshRate doubleValue]
																								 target: self 
																							 selector: @selector(refresh:) 
																							 userInfo: nil 
																								repeats: NO];

	[flakiTableViewController reloadTableView];
	[refreshButton setEnabled: YES];
	[typePopUpButton setEnabled: YES];
}

NSComparisonResult flakSort(FlakController * fc1, FlakController * fc2, void *context) {
	return [fc2.flak.createdAt compare:fc1.flak.createdAt];
}

- (void)completeFetchingFromFlaker:(NSArray *) flaki {
	
	for (FlakController * fc in flakiArray){
		[fc updateDate];
	}
	
	if ([flaki count] > 0) {
		[otrzymaneFlakiSound play];
		new_flaks_count += [flaki count];
	}
	
	if (new_flaks_count > 0 && show_flaks_badgage){
		[[NSApp dockTile] setBadgeLabel: [NSString stringWithFormat:@"%i", new_flaks_count]];
	} 
	
	for(int i = 0; i < [flaki count]; i++) {
		Flak * flak = [flaki objectAtIndex: i];
		
		FlakController * fc = [[[FlakController alloc] initWithFlak: flak] autorelease];
		[flakiArray addObject: fc];

		if (i <= 5) { [self growlAboutFlak: flak]; }
	}
	
	[flakiArray sortUsingFunction: flakSort context: nil];
	
	if ([flaki count] > 5) {
	
		[GrowlApplicationBridge notifyWithTitle: @"iFlaker"
																description: [NSString stringWithFormat: @"Zostało jeszcze %i flaków", [flaki count] - 5]
													 notificationName: @"NoweFlaki"
																	 iconData: nil //[NSBundle bundleWithIdentifier: "avatarDefault"]
																	 priority: 1
																	 isSticky: NO
															 clickContext: 0];
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
	[errorSound play];
	//NSAlert * alert = [NSAlert alertWithError:error];
	//[alert runModal];
}

// NSTable Delegate Methods

- (void) tableViewColumnDidResize:(NSNotification *) notification {
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
	
	return [[flakiArray objectAtIndex: row] frame].size.height;
}

- (int) numberOfRowsInTableView:(NSTableView *) tableView {
	return [flakiArray count];
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
	return NO;
}

// Actions

- (IBAction) refresh:(id)sender {
	[flaker refresh];
}

- (IBAction) typeChange:(id)sender {
	NSLog(@"Wybrano opcje: %i", [sender tag]);
	[flaker setType: [[Flaker types] objectAtIndex: [sender tag]]];
	[flakiArray removeAllObjects];
	[flaker refresh];
}


@end

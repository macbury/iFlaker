//
//  Flak.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Arkadiusz Buras. All rights reserved.
//

#import "Flak.h"


@implementation Flak

@synthesize body, user, permalink, createdAt;

- (id) initWithUser:(FlakerUser *)flakUser flakContent:(NSDictionary *) flakContent; {
	self = [super init];
	if (self != nil) {
		[self setUser: flakUser];
		[self setBody: [flakContent objectForKey: @"text"]];
		[self setPermalink: [flakContent objectForKey: @"permalink"]];
		NSLog(@"Date check: %@", [flakContent objectForKey:@"datetime"]);
		[self setCreatedAt: [NSDate dateWithString: [[flakContent objectForKey:@"datetime"] stringByAppendingString: @" +0000"]]];
	}
	return self;
}

// Prawie jak rails...
- (NSString *) distanceOfTimeInWords {
	double seconds = [createdAt timeIntervalSinceNow] * -1;

	if (seconds < 10) 
		return @"10 sekund temu";
	if (seconds < 20) 
		return @"20 sekund temu";
	if (seconds < 30) 
		return @"pół minuty temu";
	if (seconds < 60) 
		return @"około minuty temu";
	if (seconds < 120)
		return @"minute temu";
	
	return [createdAt descriptionWithCalendarFormat: @"%H:%M:%S"
										   timeZone: nil 
											 locale: nil];

}

- (void) dealloc {
	[createdAt release];
	[permalink release];
	[body release];
	[user release];
	[super dealloc];
}


@end

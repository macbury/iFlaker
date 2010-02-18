//
//  Flak.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Arkadiusz Buras. All rights reserved.
//

#import "Flak.h"


@implementation Flak

@synthesize body, user, permalink, createdAt, link, images, flakId;

- (id) initWithUser:(FlakerUser *)flakUser flakContent:(NSDictionary *) flakContent; {
	self = [super init];
	if (self != nil) {
		[self setUser: flakUser];
		[self setBody: [flakContent objectForKey: @"text"]];
		[self setLink: [flakContent objectForKey: @"link"]];
		[self setPermalink: [flakContent objectForKey: @"permalink"]];
		[self setCreatedAt: [NSDate dateWithString: [[flakContent objectForKey:@"datetime"] stringByAppendingString: @" +0000"]]];
		[self setFlakId: [[flakContent objectForKey: @"id"] integerValue]];
		NSMutableArray * tempImages = [[NSMutableArray alloc] init];
		
		for (NSDictionary * imageDict in [[flakContent objectForKey:@"data"] objectForKey: @"images"]) {
			FlakImage * image = [[FlakImage alloc] initWithDict: imageDict];
			[tempImages addObject: image];
		}
		[self setImages: tempImages];
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
	[images release];
	[link release];
	[createdAt release];
	[permalink release];
	[body release];
	[user release];
	[super dealloc];
}


@end

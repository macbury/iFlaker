//
//  Flak.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Arkadiusz Buras. All rights reserved.
//

#import "Flak.h"


@implementation Flak

@synthesize body, user, permalink;

- (id) initWithUser:(FlakerUser *)flakUser flakContent:(NSDictionary *) flakContent; {
	self = [super init];
	if (self != nil) {
		[self setUser: flakUser];
		[self setBody: [flakContent objectForKey: @"text"]];
		[self setPermalink: [flakContent objectForKey: @"permalink"]];
	}
	return self;
}

- (void) dealloc {
	[permalink release];
	[body release];
	[user release];
	[super dealloc];
}


@end

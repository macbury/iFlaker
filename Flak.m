//
//  Flak.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Arkadiusz Buras. All rights reserved.
//

#import "Flak.h"


@implementation Flak

@synthesize login, body;

- (id) initWithLogin:(NSString *)newLogin body:(NSString *)newBody {
	self = [super init];
	if (self != nil) {
		[self setLogin: newLogin];
		[self setBody: newBody];
	}
	return self;
}


- (void) dealloc {
	[login release];
	[body release];
	[super dealloc];
}


@end

//
//  FlakImage.m
//  iFlaker
//
//  Created by MacBury on 10-02-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlakImage.h"


@implementation FlakImage

@synthesize image, url;

- (id) initWithDict:(NSDictionary *)dict {
	self = [super init];
	if (self != nil) {
		[self setUrl: [dict objectForKey: @"big"]];
	}
	return self;
}

- (NSString *) name {
	return [[url componentsSeparatedByString: @"/"] lastObject];
}

- (void) dealloc {
	[url release];
	[image release];
	[super dealloc];
}


@end

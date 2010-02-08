//
//  FlakerUser.m
//  iFlaker
//
//  Created by MacBury on 10-02-08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlakerUser.h"


@implementation FlakerUser

@synthesize avatar, login, url, avatarImage;

- (id) initWithContent:(NSDictionary *) userContent
{
	self = [super init];
	if (self != nil) {
		[self setLogin: [userContent objectForKey: @"login"]];
		[self setAvatar: [userContent objectForKey: @"avatar"]];
		[self setUrl: [userContent objectForKey: @"url"]];
	}
	return self;
}

- (NSURL *) avatarUrl {
	return [NSURL URLWithString: [self avatar]];
}

- (NSString *) avatarName {
	return [NSString stringWithFormat: @"%@.%@", self.login, [[[self avatarUrl] path] pathExtension]];
}

- (void) dealloc {
	[avatarImage release];
	[login release];
	[avatar release];
	[url release];
	[super dealloc];
}


@end

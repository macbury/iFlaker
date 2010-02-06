//
//  Flaker.m
//  Flaker
//
//  Created by Jacek Bajor on 09-09-17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Flaker.h"

@implementation Flaker

@synthesize login;
@synthesize limit;
@synthesize flaki;

- (id) initWithLogin:(NSString *)newLogin {
	self = [super init];
	if (self != nil) {
		parser = [[SBJSON alloc] init];
		
		[self setLogin:newLogin];
		[self setLimit: [[NSNumber alloc] initWithInt:10]];
		flaki = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[flaki removeAllObjects];
	[flaki release];
	[limit release];
	[parser release];
	[super dealloc];
}

- (void)refreshFriends {
	[self fetchEntriesType: @"friends"];
}

- (NSString *)stringWithUrl:(NSURL *)url {
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:30];
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
									returningResponse:&response
												error:&error];
	
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

- (void)fetchEntriesType: (NSString *) newType {
	NSString * urlString = [[NSString alloc] initWithFormat:@"http://api.flaker.pl/api/type:%@/login:%@/limit:%@/html:false",
						   newType, self.login, self.limit];
	
	NSString * jsonString = [self stringWithUrl:[NSURL URLWithString:urlString]];
	
	NSDictionary * dictionary = [parser objectWithString:jsonString error:nil];
	
	[flaki removeAllObjects];
	
	for (NSDictionary * entry in [dictionary objectForKey:@"entries"]) {
		Flak * flak = [[Flak alloc] initWithLogin: [[entry objectForKey:@"user"] objectForKey: @"login"]
											 body: [entry objectForKey:@"text"]];
		[flaki addObject: flak];
	}
	
}

@end

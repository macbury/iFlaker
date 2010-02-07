//
//  Flaker.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import "Flaker.h"

@implementation Flaker

@synthesize login, limit;

- (id) initWithLogin:(NSString *)newLogin {
	self = [super init];
	if (self != nil) {
		parser = [[SBJSON alloc] init];
		
		[self setLogin:newLogin];
		[self setLimit: [[NSNumber alloc] initWithInt:20]];
	}
	return self;
}

- (void) dealloc {
	[limit release];
	[parser release];
	[updateConnection release];
	[super dealloc];
}


- (void)refreshFriends {
	if (updateConnection == nil) { [self fetchEntriesType: @"friends"]; }
}

- (void)fetchEntriesType: (NSString *) newType {
	NSString * urlString = [[NSString alloc] initWithFormat: @"http://api.flaker.pl/api/type:%@/login:%@/limit:%@/html:false",
							newType, self.login, self.limit];
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:urlString]
												cachePolicy: NSURLRequestReturnCacheDataElseLoad
											timeoutInterval: 30];
	NSLog(@"GET: %@", urlString);
	
	receivedData = [[NSMutableData alloc] init];
	updateConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	
	if ([delegate respondsToSelector:@selector(startFetchingFromFlaker)]) {
		[delegate startFetchingFromFlaker];
	}    
}

- (void)connection:(NSURLConnection *)con didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)con {
	NSLog(@"Succeeded! Received %d bytes of data", [receivedData length]);
	
	NSString * jsonString = [[NSString alloc] initWithData:receivedData 
												  encoding:NSUTF8StringEncoding];
	
	NSDictionary * dictionary = [parser objectWithString:jsonString 
												   error:nil];
	
	NSMutableArray * flaki = [[NSMutableArray alloc] init];
	
	for (NSDictionary * entry in [dictionary objectForKey:@"entries"]) {
		Flak * flak = [[Flak alloc] initWithLogin: [[entry objectForKey:@"user"] objectForKey: @"login"]
											 body: [entry objectForKey:@"text"]];
		[flaki addObject: flak];
		[flak autorelease];
	}
	
	[receivedData release];
	[updateConnection release];
	updateConnection = nil;
	
	if ([delegate respondsToSelector:@selector(completeFetchingFromFlaker:)]) {
		[delegate completeFetchingFromFlaker:(NSArray*)flaki];
	}   
}

- (void)connection:(NSURLConnection *)con didFailWithError:(NSError *)error {
	[receivedData release];
    [updateConnection release];
	updateConnection = nil;
	
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	if ([delegate respondsToSelector:@selector(errorOnFetchFromFlaker)]) {
		[delegate errorOnFetchFromFlaker: error];
	}  
}

- (id)delegate {
    return delegate;
}

- (void)setDelegate:(id)new_delegate {
    delegate = new_delegate;
}

@end
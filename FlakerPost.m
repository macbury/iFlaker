//
//  FlakerPost.m
//  iFlaker
//
//  Created by MacBury on 10-02-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlakerPost.h"


@implementation FlakerPost

@synthesize flaker, delegate;

- (id) initWithFlaker:(Flaker *) newFlaker {
	self = [super init];
	if (self != nil) {
		[self setFlaker: newFlaker];
	}
	return self;
}

- (void) dealloc {
	[postConnection release];
	[receivedData release];
	[flaker release];
	[super dealloc];
}

- (void) postFlak:(NSString *)contentText link:(NSString *)link images:(NSArray *) images {
	NSURL * url = [NSURL URLWithString: @"http://api.flaker.pl/api/type:submit"];
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL: url
                                                                   consumer: flaker.consumer
                                                                      token: flaker.accessToken
                                                                      realm: nil
                                                          signatureProvider: [[[OAPlaintextSignatureProvider alloc] init] autorelease]];
	[request setHTTPMethod:@"POST"];
	
	OARequestParameter *textParam = [[OARequestParameter alloc] initWithName:@"text"
                                                                       value:contentText];
	
    [request setParameters: [NSArray arrayWithObjects:textParam, nil]];
	
	[request prepare];
	
	NSLog(@"Wysyłanie flaka...");
	
	receivedData = [[NSMutableData alloc] init];
	postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)con didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)con {
	NSLog(@"Succeeded! Received %d bytes of data", [receivedData length]);
	//NSLog([[[NSString alloc] initWithData: receivedData encoding:NSUTF8StringEncoding] autorelease]);
	
	[flaker refreshFriends];
	[receivedData release];
	[postConnection release];
	postConnection = nil;
	
	if ([delegate respondsToSelector:@selector(flakHaveBeenPostedToFlaker)]) {
		[delegate flakHaveBeenPostedToFlaker];
	}   
}

- (void)connection:(NSURLConnection *)con didFailWithError:(NSError *)error {
    [receivedData release];
	[postConnection release];
	postConnection = nil;
	
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	if ([delegate respondsToSelector:@selector(flakHaventBeenPostedToFlaker)]) {
		[delegate flakHaventBeenPostedToFlaker: error];
	}  
}

@end

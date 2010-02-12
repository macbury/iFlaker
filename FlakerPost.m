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

- (void) postFlak:(NSString *)contentText link:(NSString *)link image:(NSData *)image {
	NSURL * url = [NSURL URLWithString: @"http://api.flaker.pl/api/type:submit"];
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL: url
                                                                   consumer: flaker.consumer
                                                                      token: flaker.accessToken
                                                                      realm: nil
                                                          signatureProvider: [[[OAPlaintextSignatureProvider alloc] init] autorelease]];
	[request prepare];
	
	NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	NSMutableData *postBody = [NSMutableData data];
	
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"text\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString: contentText] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	/*if (link != @""){
		[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"link\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithString: link] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}*/
	
	if (image != nil) {
		[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"uploadFile\"; filename=\"test.txt\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData: image];
		[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
	}
	
	[request setHTTPBody:postBody];
	[request setHTTPMethod:@"POST"];
	
	
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
	
	[flaker refresh];
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

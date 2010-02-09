//
//  FlakerOAuthPinVerificator.m
//  iFlaker
//
//  Created by MacBury on 10-02-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlakerOAuthPinVerificator.h"


@implementation FlakerOAuthPinVerificator

@synthesize flaker, delegate;

- (id) initWithAuthFlaker:(Flaker *) flakerObj {
	self = [super init];
	if (self != nil) {
		[self setFlaker: flakerObj];
	}
	return self;
}

- (void) dealloc {
	[flaker release];
	[super dealloc];
}


- (void) authorizeFlakerTokenWithVerifier:(NSString *)oauth_verifier {
	NSLog(@"Fetching access token...");
	NSURL *url = [NSURL URLWithString: @"http://flaker.pl/oauth/access_token"];
	
	[flaker.requestToken setVerifier: oauth_verifier];
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:flaker.consumer
                                                                      token:flaker.requestToken   
                                                                      realm:nil   
                                                          signatureProvider:nil]; 
	
   // OARequestParameter *verifierParam = [[OARequestParameter alloc] initWithName: @"oauth_verifier"
	//																	   value: oauth_verifier];
   // [request setParameters:[NSArray arrayWithObjects:verifierParam, nil]];

    [request setHTTPMethod:@"GET"];
	
	OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(tokenVerification:didFinishWithData:)
                  didFailSelector:@selector(tokenVerification:didFailWithError:)];
}

- (void)tokenVerification:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
		OAToken * accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		
		[flaker setAccessToken: accessToken];
		
		if ([delegate respondsToSelector:@selector(oAuthPinVerificationSuccessful:)]) {
			[delegate oAuthPinVerificationSuccessful: accessToken];
		}  
	} else {
		if ([delegate respondsToSelector:@selector(oAuthPinVerificationFail)]) {
			[delegate oAuthPinVerificationFail];
		}  
	}
}

- (void)tokenVerification:(OAServiceTicket *)ticket didFailWithError: (NSError *)error {
	NSLog(@"Cannot fetch token verification Token!!! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	if ([delegate respondsToSelector:@selector(oAuthPinVerificationFail)]) {
		[delegate oAuthPinVerificationFail];
	}  
}


@end

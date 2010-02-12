//
//  Flaker.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import "Flaker.h"

@implementation Flaker

@synthesize limit, requestToken, accessToken, consumer, type;

+ (NSArray *) types {
	return [NSArray arrayWithObjects: @"followed", @"niuchacz", @"user", @"tags", nil];
}

- (id) init {
	self = [super init];
	if (self != nil) {
		parser = [[SBJSON alloc] init];
		usersDictionary = [[NSMutableDictionary alloc] init];
		
		consumer = [[OAConsumer alloc] initWithKey: @"a8a3c249ac2151321e544c592258174b04b7174e5"
											secret: @"89468e4a05f5c8a13186611edb9c433c"];
		
		limit = 20;
		[self setType: @"followed"];
	}
	return self;
}

- (void) setType:(NSString*)newType {
	last_flak_timestamp = 0;
	type = newType;
}

- (void) dealloc {
	[receivedData release];
	[accessToken release];
	[consumer release];
	[requestToken release];
	[usersDictionary release];
	[parser release];
	[updateConnection release];
	[super dealloc];
}

// oAuth

- (void) authorizeUsingOAuth:(NSString *) appName serviveProviderName:(NSString *) serviceProvider {
	accessToken = [[OAToken alloc] initWithKeychainUsingAppName: appName
											serviceProviderName: serviceProvider];	
	if (accessToken == nil) {
		[self requestOAuthToken];
	} else {
		[self refresh];
	}
}

- (void) requestOAuthToken {
	NSURL *url = [NSURL URLWithString: @"http://flaker.pl/oauth/request_token"];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil   
                                                                      realm:nil   
                                                          signatureProvider:[[[OAPlaintextSignatureProvider alloc] init] autorelease]]; 
	
    [request setHTTPMethod:@"POST"];
	
    OADataFetcher * fetcher = [[OADataFetcher alloc] init];
	
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
		requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		
		if ([delegate respondsToSelector:@selector(haveOAuthTokenFromFlaker:)]) {
			[delegate haveOAuthTokenFromFlaker: requestToken];
		}  
	} else {
		if ([delegate respondsToSelector:@selector(cannotFetchOAuthTokenFromFlaker)]) {
			[delegate cannotFetchOAuthTokenFromFlaker];
		}  
	}
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError: (NSError *)error {
	NSLog(@"Cannot fetch oAuth Token!!! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	if ([delegate respondsToSelector:@selector(cannotFetchOAuthTokenFromFlaker)]) {
		[delegate cannotFetchOAuthTokenFromFlaker];
	}  
}

// Lista flakow

- (void) refresh {
	if (updateConnection == nil) { [self fetchEntriesType: self.type]; }
}

- (void)fetchEntriesType: (NSString *) newType {
	
	NSString * urlString;
	
	if(last_flak_timestamp == 0) {
		urlString = [[NSString alloc] initWithFormat: @"http://api.flaker.pl/api/type:%@/limit:%i/html:false/avatars:medium/comments:false/",
								newType, self.limit];
	}else{
		urlString = [[NSString alloc] initWithFormat: @"http://api.flaker.pl/api/type:%@/limit:%i/html:false/avatars:medium/comments:false/since:%i",
								newType, self.limit, last_flak_timestamp];
	}
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL: [NSURL URLWithString: urlString]
                                                                   consumer: consumer
                                                                      token: accessToken
                                                                      realm: nil
                                                          signatureProvider: nil];
	
	[request prepare];
	NSLog(@"GET: %@", urlString);

	receivedData = [[NSMutableData alloc] init];
	updateConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
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
	NSArray * entries = [dictionary objectForKey:@"entries"];
	
	for (int i = 0; i < [entries count]; i++) {
		NSDictionary * entry = [entries objectAtIndex: i];
		
		last_flak_timestamp = MAX(last_flak_timestamp, [[entry objectForKey: @"timestamp"] intValue]);
		
		NSDictionary * userTempDict = [entry objectForKey:@"user"];
		
		FlakerUser * user = [usersDictionary objectForKey: [userTempDict objectForKey: @"login"]];
		
		if (user == nil) {
			user = [[[FlakerUser alloc] initWithContent: userTempDict] autorelease];
			[usersDictionary setObject: user forKey: user.login];
		}
		
		Flak * flak = [[Flak alloc]  initWithUser: user flakContent: entry];
		
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
	
	if ([delegate respondsToSelector:@selector(errorOnFetchFromFlaker:)]) {
		[delegate errorOnFetchFromFlaker: error];
	}  
}

- (id)delegate {
    return delegate;
}

- (void)setDelegate:(id)new_delegate {
    delegate = new_delegate;
}

- (NSArray *) usersLogins:(NSString *) query {
	NSMutableArray * tempUsersLogins = [[[NSMutableArray alloc] init] autorelease];
	
	for (NSString * key in usersDictionary) {
		NSString * login = [[usersDictionary objectForKey: key] login];
		if (NSOrderedSame == [login compare:query options:NSCaseInsensitiveSearch]) {
			[tempUsersLogins addObject: login];
		}
	}
	
	return tempUsersLogins;
}

@end

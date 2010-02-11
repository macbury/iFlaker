//
//  Flaker.h
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OAuthConsumer/OAuthConsumer.h>
#import "JSON.h"

#import "Flak.h"
#import "FlakerUser.h"


@protocol FlakerDelegate <NSObject>
@optional
- (void)startFetchingFromFlaker; // Jak przekazać tutaj jako parametr obiekt Flaker?
- (void)completeFetchingFromFlaker:(NSArray *) flaki;
- (void)errorOnFetchFromFlaker:(NSError *)error;

// oAuth
- (void) haveOAuthTokenFromFlaker:(OAToken *)requestToken;
- (void) cannotFetchOAuthTokenFromFlaker;

@end

@interface Flaker : NSObject {
	NSNumber * limit;
	int last_flak_id;
	
	SBJSON * parser;
	
	NSURLConnection * updateConnection;
	NSMutableData * receivedData;
	
	NSMutableDictionary * usersDictionary;
	
	OAConsumer * consumer;
	OAToken * requestToken;
	OAToken * accessToken;
	
	id<FlakerDelegate> delegate;
}

@property (assign) id<FlakerDelegate> delegate;

@property (retain) NSNumber * limit;
@property (retain) OAToken * requestToken;
@property (retain) OAToken * accessToken;
@property (retain) OAConsumer * consumer;

- (id) init;
- (void)refreshFriends;
- (void)refresh;

- (id)delegate;
- (void)setDelegate:(id)new_delegate;

- (void) requestOAuthToken;
- (void) authorizeUsingOAuth:(NSString *) appName serviveProviderName:(NSString *) serviceProvider;

- (void)fetchEntriesType: (NSString *) newType;
@end

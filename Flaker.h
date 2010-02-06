//
//  Flaker.h
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "flak.h"
#import "JSON.h"

@protocol FlakerDelegate <NSObject>
@optional
- (void)startFetchingFromFlaker;
- (void)completeFetchingFromFlaker;
- (void)errorOnFetchFromFlaker:(NSError *)error;
@end

@interface Flaker : NSObject {
	NSMutableArray * flaki;
	NSString * login;
	NSNumber * limit;
	
	SBJSON * parser;
	NSURLConnection * updateConnection;
	NSMutableData * receivedData;
	
	id<FlakerDelegate> delegate;
}

@property (assign) id<FlakerDelegate> delegate;

@property (copy) NSString * login;
@property (retain) NSMutableArray * flaki;
@property (retain) NSNumber * limit;

- (id) initWithLogin:(NSString *)login;
- (void)refreshFriends;

- (id)delegate;
- (void)setDelegate:(id)new_delegate;

- (void)fetchEntriesType: (NSString *) newType;
@end

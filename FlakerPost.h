//
//  FlakerPost.h
//  iFlaker
//
//  Created by MacBury on 10-02-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OAuthConsumer/OAuthConsumer.h>

#import "Flaker.h"
#import "Flak.h"

@protocol FlakerPostDelegate <NSObject>
- (void) flakHaveBeenPostedToFlaker;
- (void) flakHaventBeenPostedToFlaker:(NSError *)error;
@end

@interface FlakerPost : NSObject {
	id<FlakerPostDelegate> delegate;
	Flaker * flaker;
	
	NSURLConnection * postConnection;
	NSMutableData * receivedData;
}

@property (retain) Flaker * flaker;
@property (assign) id<FlakerPostDelegate> delegate;

- (id) initWithFlaker:(Flaker *) newFlaker;
- (void) postFlak:(NSString *)contentText link:(NSString *)link images:(NSArray *) images;

@end

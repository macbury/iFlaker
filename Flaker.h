//
//  Flaker.h
//  Flaker
//
//  Created by Jacek Bajor on 09-09-17.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

// Kod rozwinięty przez MacBury(Buras Arkadiusz)

#import <Foundation/Foundation.h>
#import "flak.h"
#import "JSON.h"

@interface Flaker : NSObject {
	NSMutableArray * flaki;
	NSString * login;
	NSNumber * limit;
	SBJSON * parser;
}

@property (copy) NSString * login;
@property (retain) NSMutableArray * flaki;
@property (retain) NSNumber * limit;

- (id) initWithLogin:(NSString *)login;
- (void)refreshFriends;

- (void)fetchEntriesType: (NSString *) newType;
- (NSString *)stringWithUrl:(NSURL *)url;
@end

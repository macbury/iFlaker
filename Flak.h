//
//  Flak.h
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Arkadiusz Buras. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlakerUser.h"

@interface Flak : NSObject {
	NSString * permalink;
	NSString * body;
	NSDate * createdAt;
	
	FlakerUser * user;
}

@property (copy) NSString * body;
@property (copy) NSString * permalink;
@property (retain) FlakerUser * user;
@property (retain) NSDate * createdAt;

- (id) initWithUser:(FlakerUser *)flakUser flakContent:(NSDictionary *) flakContent;
- (NSString *) distanceOfTimeInWords;

@end

//
//  Flak.h
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Arkadiusz Buras. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlakerUser.h"
#import "FlakImage.h"

@interface Flak : NSObject {
	NSString * permalink;
	NSString * link;
	NSString * body;
	NSDate * createdAt;
	NSArray * images;
	
	FlakerUser * user;
}

@property (copy) NSString * body;
@property (copy) NSString * link;
@property (copy) NSString * permalink;
@property (retain) FlakerUser * user;
@property (retain) NSArray * images;
@property (retain) NSDate * createdAt;
//@property (assign, nonatomic) NSInteger flak_id;

- (id) initWithUser:(FlakerUser *)flakUser flakContent:(NSDictionary *) flakContent;
- (NSString *) distanceOfTimeInWords;

@end

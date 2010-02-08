//
//  FlakerUser.h
//  iFlaker
//
//  Created by MacBury on 10-02-08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FlakerUser : NSObject {
	NSString * login;
	NSString * avatar;
	NSString * url;
}

@property (copy) NSString * login;
@property (copy) NSString * avatar;
@property (copy) NSString * url;

- (id) initWithContent:(NSDictionary *) userContent;
- (NSString *) avatarName;
@end

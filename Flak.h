//
//  Flak.h
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Arkadiusz Buras. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Flak : NSObject {
	NSString * login;
	NSString * body;
}

@property (copy) NSString * login;
@property (copy) NSString * body;

- (id) initWithLogin:(NSString *)newLogin body:(NSString *)newBody;

@end

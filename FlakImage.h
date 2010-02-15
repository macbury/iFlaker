//
//  FlakImage.h
//  iFlaker
//
//  Created by MacBury on 10-02-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FlakImage : NSObject {
	NSImage * image;
	NSString * url;
}

@property (retain) NSImage * image;
@property (retain) NSString * url;

- (id) initWithDict:(NSDictionary *)dict;
- (NSString *) name;

@end

//
//  UrlTextField.h
//  iFlaker
//
//  Created by MacBury on 10-02-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface UrlTextField : NSTextField {
	NSURL * url;
}

@property (retain) NSURL * url;

@end

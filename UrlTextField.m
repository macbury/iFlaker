//
//  UrlTextField.m
//  iFlaker
//
//  Created by MacBury on 10-02-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UrlTextField.h"


@implementation UrlTextField

@synthesize url;

- (void)mouseDown:(NSEvent *)aEvent {
    [[NSWorkspace sharedWorkspace] openURL:url];
}



@end

//
//  SubviewController.m
//  SubviewTableViewTester
//
//  Created by Joar Wingfors on Tue Dec 02 2003.
//  Copyright (c) 2003 joar.com. All rights reserved.
//

#import "SubviewController.h"

@implementation SubviewController

@synthesize flak;

+ (id) controller {
    return [[[self alloc] init] autorelease];
}

- (id) init {
    if ((self = [super init]) != nil)
    {
        if (![NSBundle loadNibNamed: @"flakCell" owner: self])
        {
            [self release];
            self = nil;
        }
    }
    
    return self;
}

- (void) dealloc
{
    [subview release];
    
    [super dealloc];
}

- (NSView *) view {
    return subview;
}


@end

//
//  FlakCell.h
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Flak.h"
#import "NSBezierPathAdditions.h"

@interface FlakCell : NSCell {
	Flak * flak;
}

@property (retain) Flak * flak;

@end

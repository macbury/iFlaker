//
//  FlakCell.h
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Flak.h"

@interface FlakCell : NSCollectionViewItem {
	Flak * flak;
	IBOutlet NSTextField * loginTextField;
	IBOutlet NSTextField * bodyTextField;
	IBOutlet NSBox * contentBox;
}

@property (retain) Flak * flak;
- (id)copyWithZone:(NSZone *)zone;

@end

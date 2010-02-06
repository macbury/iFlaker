//
//  controller.h
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 Buras Arkadiusz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "flak.h"

@interface Controller : NSObject {
	IBOutlet NSTableView * flakiTableView;
	IBOutlet NSProgressIndicator * progressIndicator;
	
	NSMutableArray * flaki;
}

- (IBAction) refresh:(id)sender;

@end

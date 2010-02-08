//
//  FlakController.h
//  iFlaker
//
//  Created by MacBury on 10-02-07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Flak.h"
#import "FlakerUser.h"
#import "FlakBubbleView.h"
#import "FileStore.h"

@interface FlakController : NSObject {
	IBOutlet NSView *subview;
	IBOutlet NSTextField * loginTextField;
	IBOutlet NSTextField * bodyTextField;
	IBOutlet FlakBubbleView * contentBox;
	IBOutlet NSProgressIndicator * avatarDownloadIndicator;
	IBOutlet NSImageView * avatarView;
	
	Flak * flak;
	
	NSURLConnection * avatarDownloadConnection;
	NSMutableData * recivedAvatarData;
}

@property (retain) Flak * flak;

- (id) initWithFlak:(Flak*)flak;
- (NSView *) view;
-(void) resizeToFitBody;
@end

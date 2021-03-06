//
//  FlakController.h
//  iFlaker
//
//  Created by MacBury on 10-02-07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Flak.h"
#import "FlakImage.h"
#import "FlakerUser.h"
#import "FlakBubbleView.h"
#import "FileStore.h"
#import "RegexKitLite.h"
#import "UrlTextField.h"
#import "FlakImageCell.h"

@interface FlakController : NSObject {
	IBOutlet NSView *subview;
	IBOutlet UrlTextField * loginTextField;
	IBOutlet NSTextView * bodyTextField;
	IBOutlet NSTextField * timeTextField;
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
- (NSRect) frame;

- (void) resizeToFitBody;
- (void) updateDate;

- (IBAction) openFlak:(id)sender;

@end

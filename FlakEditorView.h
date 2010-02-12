//
//  FlakEditorView.h
//  iFlaker
//
//  Created by MacBury on 10-02-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FlakEditorView : NSTextView {
	NSString * imagePath;
	NSString * linkUrl;
	
	IBOutlet NSButton * removeImageButton;
	IBOutlet NSButton * removeLinkButton;
}

@property (retain) NSString * imagePath;
@property (retain) NSString * linkUrl;

- (IBAction) removeImage:(id)sender;
- (IBAction) removeLink:(id)sender;
- (void) reset;

@end

//
//  FlakImageCell.h
//  iFlaker
//
//  Created by MacBury on 10-02-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlakImage.h"
#import "FileStore.h"
#import "QuickLook.h"

#define QLPreviewPanel NSClassFromString(@"QLPreviewPanel")

@interface FlakImageCell : NSTextAttachmentCell {
	FlakImage * image;
	NSMutableData * rawImage;
	NSURLConnection * imageDownloader;
	NSImage * thumbImage;
}

@property (retain) FlakImage * image;

- (id) initWithFlakImage:(FlakImage *) fi;
- (NSImage *) thumbImage;

@end

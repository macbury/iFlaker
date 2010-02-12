//
//  FlakEditorView.m
//  iFlaker
//
//  Created by MacBury on 10-02-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlakEditorView.h"


@implementation FlakEditorView

@synthesize imagePath, linkUrl;

- (id) init
{
	self = [super init];
	if (self != nil) {
		imagePath = [[NSString alloc] init];
		linkUrl = [[NSString alloc] init];
	}
	return self;
}


- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	NSPasteboard* pboard = [sender draggingPasteboard];
	NSDragOperation sourceDragMask = [sender draggingSourceOperationMask];
	NSArray *fileTypes = [NSArray arrayWithObjects:@"jpg", @"gif",
						  @"png",@"jpeg", nil];
	if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
		
		NSArray* files = [pboard propertyListForType:NSFilenamesPboardType];
		if([files count] == 1) {
			if (sourceDragMask & NSDragOperationLink) {
				NSString * file = (NSString *)[files objectAtIndex:0];
				if ([fileTypes containsObject: [file pathExtension]]) {
					[self setImagePath: file];
					[removeImageButton setEnabled: YES];
					return YES;
				}
			} 
		}
		
		return NO;
	} else if ([[pboard types] containsObject:NSURLPboardType]) {
		if (sourceDragMask & NSDragOperationLink) {
			NSURL * link = [NSURL URLFromPasteboard:pboard];
			NSLog(@"Link: %@", link);
			
			[self setLinkUrl: [link absoluteString]];
			[removeLinkButton setEnabled: YES];
			
			return YES;
		}
	}
	
	return [super performDragOperation:sender];
}

- (void) dealloc {
	[imagePath release];
	[linkUrl release];
	[super dealloc];
}


- (IBAction) removeImage:(id)sender {
	[removeImageButton setEnabled: NO];
	imagePath = @"";
}

- (IBAction) removeLink:(id)sender {
	[removeLinkButton setEnabled: NO];
	linkUrl = @"";
}

- (void) reset {
	[removeLinkButton setEnabled: NO];
	[removeImageButton setEnabled: NO];
	imagePath = @"";
	linkUrl = @"";
	[self setString: @""];
}

@end

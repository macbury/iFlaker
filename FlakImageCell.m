//
//  FlakImageCell.m
//  iFlaker
//
//  Created by MacBury on 10-02-15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlakImageCell.h"


@implementation FlakImageCell

@synthesize image;

- (id) initWithFlakImage:(FlakImage *) fi {
	self = [super init];
	if (self != nil) {
		[self setImage: fi];
		
		if ([FileStore imageExist: [image name]]) {
			image.image = [[NSImage alloc] initWithContentsOfFile: [FileStore pathForImage: [image name]]];
		}else{
			NSURLRequest *urlRequest = [NSURLRequest requestWithURL: [NSURL URLWithString: image.url]
														cachePolicy: NSURLRequestUseProtocolCachePolicy
													timeoutInterval: 30];
			NSLog(@"Image GET: %@", image.url);
			
			imageDownloader = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
		}
		
	}
	return self;
}

- (void) dealloc {
	[thumbImage release];
	[image release];
	[super dealloc];
}

- (void)connection:(NSURLConnection *)con didReceiveData:(NSData *)data {
	if (rawImage == nil){
		rawImage = [[NSMutableData alloc] init];
	}
	[rawImage appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)con {
	if (image.image == nil){
		image.image = [[NSImage alloc] initWithData: rawImage];
		[rawImage writeToFile: [FileStore pathForImage: [image name] ] atomically: YES];
	}
	//[image setImage: flak.user.avatarImage];
	[[self controlView] needsDisplay];
	[imageDownloader release];
	[rawImage release];
	
}

- (void)connection:(NSURLConnection *)con didFailWithError:(NSError *)error {
	[rawImage release];
	[imageDownloader release];
	
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (NSRect)cellFrameForTextContainer:(NSTextContainer *) textContainer 
			   proposedLineFragment:(NSRect)lineFrag 
					  glyphPosition: (NSPoint)position 
					 characterIndex:(unsigned)charIndex 
{
	return NSMakeRect(0, 0, 64, 64);
}

- (void)drawWithFrame:(NSRect)cellFrame 
			   inView:(NSView *) controlView 
	   characterIndex:(unsigned)charIndex 
		layoutManager:(NSLayoutManager *)layoutManager 
{
	if (image.image == nil){
		[[NSColor blackColor] set];
		NSRectFill(cellFrame);
	}else{
		NSRect imageRect = NSMakeRect(0,0, 64, 64);
		//[[self thumbImage] lockFocus];
		[[self thumbImage] drawInRect:cellFrame fromRect:imageRect operation:NSCompositeCopy fraction:1.0];
		//[[self thumbImage] unlockFocus];
	}
	
}

- (NSImage *) thumbImage {

	if (thumbImage == nil){
		//NSSize originalSize = [image.image size];
		NSImage * temp = [[NSImage alloc] initWithSize: NSMakeSize(64,64)];
		[temp lockFocus];
		[temp setFlipped: YES];
		[image.image drawInRect: NSMakeRect(0, 0, 64, 64) 
					   fromRect: NSZeroRect
					  operation: NSCompositeSourceOver
					   fraction: 1.0];
		[temp unlockFocus];
		thumbImage = [[NSImage alloc] initWithData: [temp TIFFRepresentation]];
		[thumbImage setFlipped: YES];
		[temp release];
	}
    
	return thumbImage;
}

- (BOOL)wantsToTrackMouse {
	return YES;
}

- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)aTextView untilMouseUp:(BOOL)flag {
	NSLog(@"QuickLoog: %@", [FileStore pathForImage: [image name]]);
	
	[[QLPreviewPanel sharedPreviewPanel] setURLs:[NSArray arrayWithObject:[NSURL fileURLWithPath:[FileStore pathForImage: [image name]]]] 
									currentIndex:0 
						  preservingDisplayState:YES];
	
	[[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFrontWithEffect:1];
	
	return YES;
}



@end

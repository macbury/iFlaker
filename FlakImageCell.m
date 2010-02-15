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
		NSSize originalSize = [image.image size];
		thumbImage = [[NSImage alloc] initWithSize: NSMakeSize(64,64)];
		[thumbImage lockFocus];
		[image.image drawInRect: NSMakeRect(0, 0, 64, 64) fromRect: NSMakeRect(0, 0, originalSize.width, originalSize.height) operation: NSCompositeSourceOver fraction: 1.0];
		[thumbImage unlockFocus];
	}
    
	return thumbImage;
}

@end

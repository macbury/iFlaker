//
//  FlakController.m
//  iFlaker
//
//  Created by MacBury on 10-02-07.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlakController.h"

@implementation FlakController

@synthesize flak;

- (id) initWithFlak:(Flak*)newFlak {
	self = [super init];
	if (self != nil) {
		[self setFlak:newFlak];
		if (![NSBundle loadNibNamed: @"flakCell" owner: self]) {
            [self release];
            self = nil;
        }
		
	}
	return self;
}

-(void) resizeToFitBody {
	NSSize size = [bodyTextField frame].size;
	NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithAttributedString:[bodyTextField attributedStringValue]]autorelease];
	NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(size.width, FLT_MAX)] autorelease];
	NSLayoutManager *layoutManager = [[[NSLayoutManager alloc]init] autorelease];
	
	[layoutManager addTextContainer:textContainer];
	[textStorage addLayoutManager:layoutManager];

	[textContainer setLineFragmentPadding:2.0];
	[layoutManager glyphRangeForTextContainer:textContainer];
	
	// Body Text
	CGFloat textHeight = [layoutManager usedRectForTextContainer:textContainer].size.height;
	
	// Bubble Height 
	float bubbleVerticalPadding = 13.0;
	
	CGFloat bubbleHeight = textHeight + (bubbleVerticalPadding * 2) + 17;
	bubbleHeight = MAX(bubbleHeight, 80.0);
	
	// View Height
	NSSize viewBoxSize = [subview frame].size;
	
	viewBoxSize.height = bubbleHeight + 36.0;
	[subview setFrameSize: viewBoxSize];
}

- (void) updateDate {
	[timeTextField setStringValue: [flak distanceOfTimeInWords]];
}

- (void) awakeFromNib {
	[loginTextField setStringValue: flak.user.login];
	[bodyTextField setStringValue: flak.body];
	[self updateDate];
	[self resizeToFitBody];
	[avatarDownloadIndicator startAnimation: self];
	
	if ([FileStore avatarExist: [flak.user avatarName]]){
		if (flak.user.avatarImage == nil) {
			flak.user.avatarImage = [[NSImage alloc] initWithContentsOfFile: [FileStore pathForAvatar: [flak.user avatarName]]];
		}
		
		[avatarDownloadIndicator stopAnimation: self];
		[avatarView setImage: flak.user.avatarImage];
		[avatarDownloadIndicator setHidden: YES];
	}else{
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL: [NSURL URLWithString: flak.user.avatar]
													cachePolicy: NSURLRequestReturnCacheDataElseLoad
												timeoutInterval: 30];
		NSLog(@"Avatar GET: %@", flak.user.avatar);
		
		recivedAvatarData = [[NSMutableData alloc] init];
		avatarDownloadConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	}
}

- (void)connection:(NSURLConnection *)con didReceiveData:(NSData *)data {
	[recivedAvatarData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)con {
	[avatarDownloadIndicator stopAnimation: self];
	[avatarDownloadIndicator setHidden: YES];
	
	flak.user.avatarImage = [[NSImage alloc] initWithData: recivedAvatarData];
	[avatarView setImage: flak.user.avatarImage];
	
	[recivedAvatarData writeToFile: [FileStore pathForAvatar: [flak.user avatarName] ] atomically: YES];
	
	[recivedAvatarData release];
	[avatarDownloadConnection release];
}

- (void)connection:(NSURLConnection *)con didFailWithError:(NSError *)error {
	[recivedAvatarData release];
	[avatarDownloadConnection release];
	
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}


- (void) dealloc {
	[avatarDownloadConnection release];
	[recivedAvatarData release];
    [subview release];
    [flak release];
    [super dealloc];
}

- (NSView *) view {
    return subview;
}

@end

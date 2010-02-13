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
	
	viewBoxSize.height = bubbleHeight + 20.0;
	[subview setFrameSize: viewBoxSize];
}

- (NSRect) frame {
	[self resizeToFitBody];
	
	return [subview frame];
}

- (void) updateDate {
	[timeTextField setStringValue: [flak distanceOfTimeInWords]];
}

- (void)hiliteAndActivateURLs:(NSTextField*)textView {
	[textView setAllowsEditingTextAttributes: YES];
	[textView setSelectable: YES];
	
	NSString * string = [textView stringValue];
	NSMutableAttributedString* attrString = [[[NSMutableAttributedString alloc] initWithString: string] autorelease];
	NSRange searchRange = NSMakeRange(0, [attrString length]);
	NSRange foundRange;
	
	[attrString beginEditing];
	do {
		foundRange=[string rangeOfString:@"http://" options:0 range:searchRange];
		
		if (foundRange.length > 0) {
			NSURL* theURL;
			NSRange endOfURLRange;
			
			//Restrict the searchRange so that it won't find the same string again
			searchRange.location=foundRange.location+foundRange.length;
			searchRange.length = [string length]-searchRange.location;
			
			//We assume the URL ends with whitespace
			endOfURLRange=[string rangeOfCharacterFromSet:
						   [NSCharacterSet whitespaceAndNewlineCharacterSet]
												  options:0 range:searchRange];
			
			//The URL could also end at the end of the text.  The next line fixes it in case it does
			if (endOfURLRange.length==0)  // BUGFIX - was location == 0
				endOfURLRange.location=[string length]-1;
			
			//Set foundRange's length to the length of the URL
			foundRange.length = endOfURLRange.location-foundRange.location+1;
			
			//grab the URL from the text
			theURL=[NSURL URLWithString:[string substringWithRange:foundRange]];
			
			//Make the link attributes
			[attrString addAttribute: NSForegroundColorAttributeName 
							   value: [NSColor blueColor] 
							   range: foundRange];
			
			// next make the text appear with an underline
			[attrString addAttribute: NSUnderlineStyleAttributeName 
							   value: [NSNumber numberWithInt:NSSingleUnderlineStyle] 
							   range: foundRange];
			
			// add cursor
			[attrString addAttribute: NSCursorAttributeName 
							   value: [NSCursor pointingHandCursor] 
							   range: foundRange];
		}
		
	} while (foundRange.length!=0); //repeat the do block until it no longer finds anything
	
	[attrString endEditing];
	[textView setAttributedStringValue: attrString];
	[textView display];
}

- (void) awakeFromNib {
	[loginTextField setStringValue: flak.user.login];
	[bodyTextField setStringValue: flak.body];
	[self hiliteAndActivateURLs: bodyTextField];
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
													cachePolicy: NSURLRequestUseProtocolCachePolicy
												timeoutInterval: 30];
		NSLog(@"Avatar GET: %@", flak.user.avatar);
		
		avatarDownloadConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	}
	
	[self updateDate];
	[self resizeToFitBody];
}

- (void)connection:(NSURLConnection *)con didReceiveData:(NSData *)data {
	if (recivedAvatarData == nil){
		recivedAvatarData = [[NSMutableData alloc] init];
	}
	[recivedAvatarData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)con {
	[avatarDownloadIndicator stopAnimation: self];
	[avatarDownloadIndicator setHidden: YES];
	
	if (flak.user.avatarImage == nil){
		flak.user.avatarImage = [[NSImage alloc] initWithData: recivedAvatarData];
		[recivedAvatarData writeToFile: [FileStore pathForAvatar: [flak.user avatarName] ] atomically: YES];
	}
	
	[avatarView setImage: flak.user.avatarImage];
	
	[avatarDownloadConnection release];
	[recivedAvatarData release];
	
}

- (void)connection:(NSURLConnection *)con didFailWithError:(NSError *)error {
	[recivedAvatarData release];
	[avatarDownloadConnection release];
	
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}


- (void) dealloc {

	[subview release];
    [flak release];
    [super dealloc];
}

- (NSView *) view {
    return subview;
}

@end

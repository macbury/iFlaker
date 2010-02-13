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
	// Body Text
	NSRect rect = [[bodyTextField layoutManager] usedRectForTextContainer: [bodyTextField textContainer]];
	CGFloat textHeight = rect.size.height;
	
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


- (void)hiliteAndActivateURLs:(NSTextView*)textView regexp:(NSString *) regexp format:(NSString *) format {
	
	NSTextStorage* textStorage=[textView textStorage];
	NSString* string=[textStorage string];
	NSRange searchRange=NSMakeRange(0, [string length]);
	NSRange foundRange;
	
	NSError * error = NULL;
	
	[textStorage beginEditing];
	do {
		
		foundRange = [string rangeOfRegex: regexp 
								  options: RKLNoOptions 
								  inRange: searchRange 
								  capture: 1
									error: &error];
		
		if (foundRange.length > 0) {
			NSURL* theURL;
			NSDictionary* linkAttributes;
			
			searchRange.location = foundRange.location+foundRange.length;
			searchRange.length = [string length]-searchRange.location;
			
			theURL = [NSURL URLWithString: [NSString stringWithFormat: format, [string substringWithRange:foundRange]]];
			
			linkAttributes= [NSDictionary dictionaryWithObjectsAndKeys: theURL, NSLinkAttributeName,
							 [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
							 [NSColor blueColor], NSForegroundColorAttributeName,
							 NULL];
			
			[textStorage addAttributes:linkAttributes range:foundRange];
			[textStorage addAttribute: NSCursorAttributeName 
								value: [NSCursor pointingHandCursor] 
								range: foundRange];
		}
	} while (foundRange.length!=0); 
	
	[textStorage endEditing];
}


- (void) awakeFromNib {
	[loginTextField setStringValue: flak.user.login];
	[bodyTextField setAlignment: NSLeftTextAlignment];
	[bodyTextField setString: flak.body];
	
	[self hiliteAndActivateURLs: bodyTextField 
						 regexp: @"\\b(https?://[a-zA-Z0-9\\-.]+(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?)"
						 format: @"%@"];
	[self hiliteAndActivateURLs: bodyTextField 
						 regexp: @"#([a-zA-Z0-9]+)"
						 format: @"http://flaker.pl/t/%@"];
	[self hiliteAndActivateURLs: bodyTextField 
						 regexp: @"@([a-zA-Z0-9]+)"
						 format: @"http://flaker.pl/%@"];
	
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

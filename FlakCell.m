//
//  FlakCell.m
//  iFlaker
//
//  Created by MacBury on 10-02-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlakCell.h"


@implementation FlakCell

@synthesize flak;

- (id)copyWithZone:(NSZone *)zone {
	id result = [super copyWithZone:zone];
	[NSBundle loadNibNamed:@"flakCell" owner:result];
	
	return result;
}

- (void)setRepresentedObject:(id)object {
	if (object == nil)
		return;
	
	[self setFlak: object];
	
	[loginTextField setStringValue: flak.login];
	[bodyTextField setStringValue: flak.body];
}

//- (void)setSelected:(BOOL)flag {
//	[super setSelected:	flag];	
//}

- (void) awakeFromNib {
	[contentBox setTitlePosition:NSNoTitle];
	[contentBox setBoxType:NSBoxCustom];

	[contentBox setCornerRadius:8.0];
	[contentBox setBorderType:NSLineBorder];

	[contentBox setBorderColor:[NSColor blackColor]];
	[contentBox setFillColor:[NSColor selectedControlColor]];
}

@end

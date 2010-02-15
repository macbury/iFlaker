//
//  FileStore.m
//  iFlaker
//
//  Created by MacBury on 10-02-08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FileStore.h"


@implementation FileStore

+ (NSString *) pathForFileStore:(NSString *) path {
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	NSString *folder = @"~/Library/Application Support/iFlaker/";
	
	folder = [folder stringByExpandingTildeInPath];
	
	if ([fileManager fileExistsAtPath: folder] == NO) {
		[fileManager createDirectoryAtPath: folder attributes: nil];
	}

	folder = [folder stringByAppendingPathComponent: path];
	
	if ([fileManager fileExistsAtPath: folder] == NO) {
		[fileManager createDirectoryAtPath: folder attributes: nil];
	}
	
	return folder;    
}

+ (NSString *) pathForAvatar:(NSString *) avatar {
	return [[FileStore pathForFileStore: @"/avatary/"] stringByAppendingPathComponent: avatar];
}

+ (NSString *) pathForImage:(NSString *) image {
	return [[FileStore pathForFileStore: @"/pictures/"] stringByAppendingPathComponent: image];
}

+ (BOOL) avatarExist:(NSString *) avatarName {
	return [[NSFileManager defaultManager] fileExistsAtPath: [FileStore pathForAvatar: avatarName ]];
}

+ (BOOL) imageExist:(NSString *) image {
	return [[NSFileManager defaultManager] fileExistsAtPath: [FileStore pathForImage: image ]];
}

@end

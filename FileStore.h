//
//  FileStore.h
//  iFlaker
//
//  Created by MacBury on 10-02-08.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FileStore : NSObject {

}

+ (NSString *) pathForFileStore:(NSString *) path;
+ (NSString *) pathForAvatar:(NSString *) avatar;
+ (NSString *) pathForImage:(NSString *) image;
+ (BOOL) avatarExist:(NSString *) avatarName;
+ (BOOL) imageExist:(NSString *) image;
@end

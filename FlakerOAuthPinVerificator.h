//
//  FlakerOAuthPinVerificator.h
//  iFlaker
//
//  Created by MacBury on 10-02-09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OAuthConsumer/OAuthConsumer.h>

#import "Flaker.h"

@protocol FlakerOAuthPinVerificatorDelegate <NSObject>
- (void) oAuthPinVerificationSuccessful:(OAToken *)accessToken;
- (void) oAuthPinVerificationFail;
@end

@interface FlakerOAuthPinVerificator : NSObject {
	id<FlakerOAuthPinVerificatorDelegate> delegate;
	Flaker * flaker;
}

@property (retain) Flaker * flaker;
@property (assign) id<FlakerOAuthPinVerificatorDelegate> delegate;

- (id) initWithAuthFlaker:(Flaker *) flaker;
- (void) authorizeFlakerTokenWithVerifier:(NSString *)oauth_verifier;

@end

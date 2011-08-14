//
//  L1User.h
//  locations1
//
//  Created by Joe Zuntz on 21/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LROAuth2Client.h"

@interface L1User : NSObject<LROAuth2ClientDelegate> {
	LROAuth2Client * oAuthClient;
	UIWebView * oAuthWebView;
	LROAuth2AccessToken * token;
}
@property (retain) LROAuth2AccessToken * token;

-(void) loginWithWebView:(UIWebView*)webView;

@end

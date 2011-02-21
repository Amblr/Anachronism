//
//  L1User.m
//  locations1
//
//  Created by Joe Zuntz on 21/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import "L1User.h"
#import "LROAuth2AccessToken.h"

@implementation L1User


-(void) loginWithWebView:(UIWebView*)webView
{
	oAuthClient = [[LROAuth2Client alloc] 
				   initWithClientID:@"MY_CLIENT_ID" 
				   secret:@"sssh_top_secret" 
				   redirectURL:[NSURL URLWithString:@"myapp://oauth"]];
	oAuthClient.delegate = self;

	
	oAuthClient.userURL  = [NSURL URLWithString:@"http://myawesomeservice.com/authorization/new"];
	oAuthClient.tokenURL = [NSURL URLWithString:@"http://myawesomeservice.com/authorization/verify"];
	NSLog(@"Logging in...");
	[oAuthClient authorizeUsingWebView:webView];
	
}


- (void)oauthClientDidReceiveAccessToken:(LROAuth2Client *)client
{
	self.token = client.accessToken;
	NSLog(@"I received token %@\nExpires at date %@",self.token.accessToken,self.token.expiresAt);
	
}


- (void)oauthClientDidRefreshAccessToken:(LROAuth2Client *)client
{
	self.token = client.accessToken;
	NSLog(@"I refreshed token %@\nExpires at date %@",self.token.accessToken,self.token.expiresAt);

}

@synthesize token;
@end
//
//- (void)oauthClientDidReceiveAccessCode:(LROAuth2Client *)client
//{
//	self.token = client.accessToken;
//	NSLog(@"I received token %@\nExpires at date %@",self.token.accessToken,self.token.expiresAt);
//
//}
//- (void)oauthClientDidCancel:(LROAuth2Client *)client
//{
//	
//}
//
//
//@end

//
//  SimpleURLConnection.h
//  GalaxyZooLib
//
//  Created by Stuart Lynn on 09/06/2010.
//  Copyright 2010 me. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SimpleURLConnection : NSObject {
	
	NSMutableURLRequest* request;
	NSMutableData* resultData;
	id returnDelegate;
	SEL returnSelector;
	SEL failSelector;
	NSHTTPURLResponse* httpResponse;
}

-(id) initWithURL:(NSString*) target delegate:(id)delegate passSelector:(SEL) passSel failSelector:(SEL) failSel;
-(NSError*)generateError:(NSString*)description httpReturnCode:(NSHTTPURLResponse*)response errorNo:(int)code;
-(void)runRequest;

@property (retain) NSMutableURLRequest* request;


@end

//
//  SimpleURLConnection.m
//  GalaxyZooLib
//
//  Created by Stuart Lynn on 09/06/2010.
//  Copyright 2010 me. All rights reserved.
//

#import "SimpleURLConnection.h"


#warning REMOVE THIS
@implementation NSURLRequest (acceptAll)

+(BOOL) allowsAnyHTTPSCertificateForHost:(id)host{
	return YES;
}

@end


@implementation SimpleURLConnection

@synthesize request;


-(id) initWithURL:(NSString*) target delegate:(id)delegate passSelector:(SEL) passSel failSelector:(SEL) failSel {
	self.request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: target]
								   cachePolicy:NSURLRequestReloadIgnoringCacheData
								   timeoutInterval:60.0];
	[self.request addValue:@"300" forHTTPHeaderField:@"Keep-Alive"];
	[self.request addValue:@"en-us,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
	[self.request addValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
	[self.request addValue:@"ISO-8859-1,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];
	[self.request addValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
	[self.request addValue:@"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1) Gecko/20090624 Firefox/3.5" forHTTPHeaderField:@"User-Agent"];
	[self.request addValue:@"application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
	[self.request addValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
	
	returnDelegate = delegate;
	returnSelector = passSel;
	failSelector   = failSel;
	return self;

}

-(void) setData:(NSData*)data{
	[self.request setHTTPMethod:@"POST"];
	[self.request addValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
	[self.request setHTTPBody:data];
}

-(void) runRequest{
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if(!connection){
		NSLog(@"failed to get connection");
		NSError* error=[self generateError:@"Failed to establishConnection" httpReturnCode:nil errorNo:1];
		
		[returnDelegate performSelector:failSelector withObject:error];
		
	}	
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	NSLog(@"Response received.");
	httpResponse =(NSHTTPURLResponse*) response;
	[httpResponse retain];
	int returnCode = [httpResponse statusCode];
	
	
	if (returnCode/100!=2){
		
        if (returnCode==401){
			NSError* error=[self generateError:@"Failed With unauthorised" httpReturnCode:httpResponse errorNo:2];
			[returnDelegate performSelector:failSelector withObject:error];
		}
        else{
			NSError* error=[self generateError:@"Failed to establishConnection" httpReturnCode:httpResponse errorNo:3];
			NSLog(@"return code is %d",returnCode);
			[returnDelegate performSelector:failSelector withObject:error];
        }
        [connection cancel];
        [connection release];
        return;
    }
	
	resultData=[[NSMutableData alloc] initWithCapacity:0];
	
}

-(NSError*)generateError:(NSString*)description httpReturnCode:(NSHTTPURLResponse*)response errorNo:(int)code{
	NSArray *objArray = [NSArray arrayWithObjects:description, response, nil];
	NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, @"http_response", nil];
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
	NSError* returnError= [NSError errorWithDomain:NSPOSIXErrorDomain code:code userInfo:userInfo];
	return returnError;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	
	[resultData appendData:data];
	
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	NSLog(@"SimpleURLConnection: Connection succeded");
	[returnDelegate performSelector:returnSelector withObject:resultData withObject:httpResponse];
	[resultData autorelease];
	[httpResponse autorelease];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"SimpleURLConnection: Failed with error %@",error);
	[returnDelegate performSelector:failSelector withObject:error];
	
}


// TODO: write this !!!!!!
@end

//
//  L1Resource.m
//  locations1
//
//  Created by Joe Zuntz on 04/04/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1Resource.h"
#import "SimpleURLConnection.h"

@implementation L1Resource

-(id) initWithKey:(NSString *)resourceKey
{
    if ((self = [super init])){
        self.key = resourceKey;
    } 
    return self;

}

-(void) downloadedResourceData:(NSData*)data response:(NSURLResponse*)response
{
    self.resourceData = [NSData dataWithData:data];
    self.local=YES;
}

-(void) failedDownloadingResourceDataWithError:(NSError*) error
{
    NSLog(@"Failed download of resource.\nname:%@ \nurl: %@\nerror:%@",self.name,self.url,error);
    

}

-(void) downloadResourceData
{
    if (!self.url){
        NSLog(@"Cannot download data for resource %@ - no URL",self.name);
        return;
    }

    if (![self.url isKindOfClass:[NSNull class]]   ){
    SimpleURLConnection * connection = [[SimpleURLConnection alloc] initWithURL:self.url delegate:self passSelector:@selector(downloadedResourceData:response:) failSelector:@selector(failedDownloadingResourceDataWithError:)];
    [connection runRequest];
    }

}

-(id) initWithDictionary:(NSDictionary*) data
{
    if ((self = [super init])){
        self.name = [data objectForKey:@"name"];
        self.key = [data objectForKey:@"id"];
        self.url = [data objectForKey:@"path"];
        self.type = [data objectForKey:@"type"];
        self.local = NO;
        self.metadata = [NSMutableDictionary dictionaryWithDictionary:[data objectForKey:@"metadata"]];
        self.resourceData = nil;
        [self downloadResourceData];
    }
    return self;
}


@synthesize name, url, type, local, key, metadata, resourceData;
@end

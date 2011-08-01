//
//  L1Resource.m
//  locations1
//
//  Created by Joe Zuntz on 04/04/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1Resource.h"
#import "SimpleURLConnection.h"
#import "L1Utils.h"

int currentIndex = 0;

@implementation L1Resource

-(id) initWithKey:(NSString *)resourceKey
{
    if ((self = [super init])){
        self.key = resourceKey;
        self.saveLocal = YES;
        self.local = NO;
        self.downloading = NO;
        resourceData = nil;
    } 
    return self;

}

-(void) setResourceData:(NSData *)data
{
    [resourceData autorelease];
    resourceData = [data retain];
}

-(void) flush
{
    if (self.saveLocal && self.local) self.resourceData=nil; 
}

-(NSData*) resourceData
{
    //data not ready yet.
    if (!self.local) return nil;
    //data in RAM already
    if (resourceData) return resourceData;
    // data saved to file
    if (self.saveLocal){
        self.resourceData = [NSData dataWithContentsOfFile:[self localFileName]];
        return resourceData;
    }
    //Data should have been here but was not for some reason.
    //Maybe we should re-load it here?
    NSLog(@"Data mysteriously disappeared: %@,%@",self.key,self.name);
    return nil;
        
    
}

-(void) downloadedResourceData:(NSData*)data response:(NSURLResponse*)response
{
    self.local=YES;
    self.downloading=NO;
    if (self.saveLocal){
        [[NSFileManager defaultManager] createFileAtPath:[self localFileName] contents:data attributes:nil];
        self.resourceData = nil;

    }
    else
    {
        self.resourceData = [NSData dataWithData:data];

    }
    
}

-(void) rerunWrapper:(NSObject*) dummy
{
    [self downloadResourceData];    
}

-(void) failedDownloadingResourceDataWithError:(NSError*) error
{
    NSLog(@"Failed download of resource.\nname:%@ \nurl: %@\nerror:%@",self.name,self.url,error);
    NSRange range = [self.url rangeOfString:@"soundcloud"];
    BOOL isSoundCloud = range.length!=0;
    NSLog(@"code = %d",[error code]);
    
    if ([error code]==403 && isSoundCloud){
        NSLog(@"Received  403 Error from SoundCloud - trying again in 30 seconds");
        SEL selector = @selector(rerunWrapper:);
        [self performSelector:selector withObject:nil afterDelay:30.0]; 
    }
    
    
//    if ([self.type isEqualToString:@"sound"]){
//#warning TEST CODE
//        NSArray* soundNames = [NSArray arrayWithObjects:@"momentum",@"major",@"dying",@"jonathan",@"youll",@"rock",@"worth", nil];
//        NSString* randomSoundName = [soundNames objectAtIndex: (currentIndex++)%[soundNames count]];
//        NSLog(@"Faking sound resource: %@",randomSoundName);
//        NSString * filename = [[NSBundle mainBundle] pathForResource:randomSoundName ofType:@"mp3"];
//        NSData * data = [NSData dataWithContentsOfFile:filename];
//        [self downloadedResourceData:data response:nil];
//    }
    self.downloading=NO;
}

-(void) downloadResourceData
{
    if (!self.url){
        NSLog(@"Cannot download data for resource %@ - no URL",self.name);
        return;
    }
    if (self.saveLocal && [[NSFileManager defaultManager] fileExistsAtPath:[self localFileName]]){
        NSLog(@"Resource data %@ already downloaded.  Using cached version.",name);
        self.local=YES;
        return;
    }

    if (![self.url isKindOfClass:[NSNull class]]   ){
    SimpleURLConnection * connection = [[SimpleURLConnection alloc] initWithURL:self.url delegate:self passSelector:@selector(downloadedResourceData:response:) failSelector:@selector(failedDownloadingResourceDataWithError:)];
    [connection runRequest];
        self.downloading=YES;

    }

}

-(id) initWithDictionary:(NSDictionary*) data
{
    if ((self = [super init])){
        self.name = [data objectForKey:@"name"];
        self.key = [data objectForKey:@"id"];
        self.url = [data objectForKey:@"path"];
        self.type = [data objectForKey:@"type"];
        NSLog(@"Resource type: %@",self.type);
        self.saveLocal = YES;
        self.local = NO;
        self.metadata = [NSMutableDictionary dictionaryWithDictionary:[data objectForKey:@"metadata"]];
        self.resourceData = nil;
        self.downloading = NO;

        [self downloadResourceData];
    }
    return self;
}

-(NSString*) localFileName
{
    NSString * resourceDir = [L1Utils resourceDirectory];
    if ([self.type isEqualToString:@"sound"]){
    return [[NSString pathWithComponents:[NSArray arrayWithObjects:resourceDir,self.key,nil]] stringByAppendingString:@".mp3"];
    }
    return [NSString pathWithComponents:[NSArray arrayWithObjects:resourceDir,self.key,nil]];
            
}


@synthesize name, url, type, local, key, metadata, saveLocal,downloading;
@end

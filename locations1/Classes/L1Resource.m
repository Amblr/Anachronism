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
    } 
    return self;

}

-(void) downloadedResourceData:(NSData*)data response:(NSURLResponse*)response
{
    self.resourceData = [NSData dataWithData:data];
    self.local=YES;
    if (self.saveLocal){
        [[NSFileManager defaultManager] createFileAtPath:[self localFileName] contents:self.resourceData attributes:nil];
        self.resourceData = nil;
    }
    
}

-(void) failedDownloadingResourceDataWithError:(NSError*) error
{
    NSLog(@"Failed download of resource.\nname:%@ \nurl: %@\nerror:%@",self.name,self.url,error);

//    if ([self.type isEqualToString:@"sound"]){
//#warning TEST CODE
//        NSArray* soundNames = [NSArray arrayWithObjects:@"momentum",@"major",@"dying",@"jonathan",@"youll",@"rock",@"worth", nil];
//        NSString* randomSoundName = [soundNames objectAtIndex: (currentIndex++)%[soundNames count]];
//        NSLog(@"Faking sound resource: %@",randomSoundName);
//        NSString * filename = [[NSBundle mainBundle] pathForResource:randomSoundName ofType:@"mp3"];
//        NSData * data = [NSData dataWithContentsOfFile:filename];
//        [self downloadedResourceData:data response:nil];
//    }
        
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
        NSLog(@"Resource type: %@",self.type);
        self.saveLocal = YES;
        self.local = NO;
        self.metadata = [NSMutableDictionary dictionaryWithDictionary:[data objectForKey:@"metadata"]];
        self.resourceData = nil;
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


@synthesize name, url, type, local, key, metadata, resourceData, saveLocal;
@end

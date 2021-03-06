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
#import "SBJsonParser.h"
#import "L1DownloadManager.h"

/* 
 
 Temporary Hackney Hear Hack
 
 
 */

static NSSet * HHspeechNodes=nil;
static NSSet * HHmusicNodes=nil;
static NSSet * HHatmosNodes=nil;





@implementation L1Resource

//-(id) initWithKey:(NSString *)resourceKey
//{
//    
//    if ((self = [super init])){
//        self.key = resourceKey;
//        self.saveLocal = YES;
//        self.local = NO;
//        self.downloading = NO;
//        resourceData = nil;
//        self.soundType=L1SoundTypeUnknown;
//    } 
//    return self;
//
//}

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
        self.resourceData = [NSData dataWithContentsOfFile:[self localFilePath]];
        return resourceData;
    }
    //Data should have been here but was not for some reason.
    //Maybe we should re-load it here?
    NSLog(@"Data mysteriously disappeared: %@,%@",self.key,self.name);
    
    return nil;
        
    
}

-(void) downloadedResourceData:(NSData*)data response:(NSURLResponse*)response
{
    if (self.saveLocal){
        [[NSFileManager defaultManager] createFileAtPath:[self localFilePath] contents:data attributes:nil];
        self.resourceData = nil;

    }
    else
    {
        self.resourceData = [NSData dataWithData:data];

    }
    self.local=YES;
    self.downloading=NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:L1_RESOURCE_DATA_IS_READY object:self];

    
}

-(void) rerunWrapper:(NSObject*) dummy
{
    [self downloadResourceData];    
}

-(void) failedDownloadingResourceDataWithError:(NSError*) error
{
    NSLog(@"Failed download of resource.\nname:%@ \nurl: %@\nerror:%@",self.name,self.url,error);
//    NSRange range = [self.url rangeOfString:@"soundcloud"];
//    BOOL isSoundCloud = range.length!=0;
    NSLog(@"code = %d",[error code]);
    [[NSNotificationCenter defaultCenter] postNotificationName:L1_RESOURCE_DATA_IS_PROBLEM object:self];

    
    if ([error code]!=404){
        NSLog(@"Re-trying download soon");
        SEL selector = @selector(rerunWrapper:);
        [self performSelector:selector withObject:nil afterDelay:30.0]; 
    }
    self.downloading=NO;

    
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
    if (self.downloading){
        NSLog(@"Already downloading resource %@",self.name);
        return;
    }
    
    if (!self.url){
        NSLog(@"Cannot download data for resource %@ - no URL",self.name);
        return;
    }
    if (self.saveLocal && [[NSFileManager defaultManager] fileExistsAtPath:[self localFilePath]]){
        [[NSNotificationCenter defaultCenter] postNotificationName:L1_RESOURCE_DATA_IS_READY object:self];
        NSLog(@"Resource data %@ already downloaded.  Using cached version.",name);
        self.local=YES;
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:L1_RESOURCE_DATA_IS_DOWNLOADING object:self];


    if (![self.url isKindOfClass:[NSNull class]]){
        [[L1DownloadManager sharedL1DownloadManager] downloadURLString:self.url 
                                                              delegate:self passSelector:@selector(downloadedResourceData:response:) 
                                                          failSelector:@selector(failedDownloadingResourceDataWithError:)];
        
//    SimpleURLConnection * connection = [[SimpleURLConnection alloc] initWithURL:self.url delegate:self passSelector:@selector(downloadedResourceData:response:) failSelector:@selector(failedDownloadingResourceDataWithError:)];
//    [connection runRequest];
        self.downloading=YES;

    }

}


+(void) setupHHSpeechNodes
{
    SBJsonParser * parser = [[SBJsonParser alloc] init];

    NSData * data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"speech" ofType:@"json"]];
    NSArray * arrayOfNames = [parser objectWithData:data];
    HHspeechNodes = [[NSSet setWithArray:arrayOfNames] retain];
    NSLog(@"Speech node set: %@",HHspeechNodes);

    NSData * data2 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"music" ofType:@"json"]];
    NSArray * arrayOfNames2 = [parser objectWithData:data2];
    HHmusicNodes = [[NSSet setWithArray:arrayOfNames2] retain];
    NSLog(@"Music node set: %@",HHmusicNodes);

    NSData * data3 = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"atmos" ofType:@"json"]];
    NSArray * arrayOfNames3 = [parser objectWithData:data3];
    HHatmosNodes = [[NSSet setWithArray:arrayOfNames3] retain];
    NSLog(@"Speech node set: %@",HHatmosNodes);
    
    [parser release];

}

-(id) initWithDictionary:(NSDictionary*) data
{
    
    if (HHspeechNodes==nil)[L1Resource setupHHSpeechNodes];

    

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
        self.soundType = L1SoundTypeUnknown;
        if ([HHspeechNodes member:self.name]){
            self.soundType=L1SoundTypeSpeech;
            NSLog(@"Node %@ is SPEECH",self.name);
        }
        else if ([HHatmosNodes member:self.name]){
            self.soundType=L1SoundTypeAtmos;
            NSLog(@"Node %@ is ATMOS",self.name);
        }
        else if ([HHmusicNodes member:self.name]){
            self.soundType=L1SoundTypeMusic;
            NSLog(@"Node %@ is MUSIC",self.name);
        }
        else{
            NSLog(@"Node %@ is UNKNOWN",self.name);

        }

        bundled=NO;
        if ([self bundleFilename]){
            NSLog(@"%@ is bundled!",self.name);
            [[NSNotificationCenter defaultCenter] postNotificationName:L1_RESOURCE_DATA_IS_READY object:self];
            bundled = YES;
            self.local = YES;
        }
        else if (self.saveLocal && [[NSFileManager defaultManager] fileExistsAtPath:[self localFilePath]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:L1_RESOURCE_DATA_IS_READY object:self];
            NSLog(@"Resource data %@ already downloaded.  Using cached version.",name);
            self.local=YES;
        }
        

        
//        [self downloadResourceData];
    }
    return self;
}

-(NSString*) bundleFilename
{
    if ([self.type isEqualToString:@"sound"]){
        return [[NSBundle mainBundle] pathForResource:self.key ofType:@"mp3"];
    }
    return [[NSBundle mainBundle] pathForResource:self.key ofType:nil];
}

-(NSString*) localFileName
{
    if ([self.type isEqualToString:@"sound"]){
        return [self.key stringByAppendingString:@".mp3"];
    }
    return [NSString stringWithString:self.key];

}

-(NSString*) localFilePath
{
    if (bundled) return [self bundleFilename];
    NSString * resourceDir = [L1Utils resourceDirectory];
    NSString * filename = [self localFileName];
    return [NSString pathWithComponents:[NSArray arrayWithObjects:resourceDir, filename, nil]];
            
}


@synthesize name, url, type, local, key, metadata, saveLocal,downloading, soundType;
@end

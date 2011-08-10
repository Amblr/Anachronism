//
//  L1DownloadManager.m
//  locations1
//
//  Created by Joe Zuntz on 10/08/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1DownloadManager.h"
#import "SynthesizeSingleton.h"


#define DEFAULT_MAX_SIMULTANEOUS_DOWNLOADS 5


@interface L1DownloadTarget : NSObject {
@private
    SEL passSelector;
    SEL failSelector;
    NSString * urlString;
    NSObject * delegate;
    SimpleURLConnection * connection;

}
@property (readonly) NSString * urlString;
@property (readonly) NSObject * delegate;
@property (readonly) SEL passSelector;
@property (readonly) SEL failSelector;

-(id) initWithString:(NSString*)string delegate:(NSObject*) del pass:(SEL) pass fail:(SEL) fail;
+(L1DownloadTarget*) targetWithString:(NSString*)string delegate:(NSObject*) del pass:(SEL) pass fail:(SEL) fail;
-(SimpleURLConnection*) connectionForDelegate:(NSObject*) newDelegate;
@end


@implementation L1DownloadTarget
@synthesize urlString, delegate, passSelector, failSelector;
-(id) initWithString:(NSString*)string delegate:(NSObject*) del pass:(SEL) pass fail:(SEL) fail
{
    self = [super init];
    if (self){
        passSelector=pass;
        failSelector=fail;
        urlString=[[NSString stringWithString:string] retain];
        delegate=[del retain];
        
    }
    return self;
}

-(void) downloadComplete:(NSData*) download response:(NSURLResponse*) response
{
    [delegate performSelector:passSelector withObject:download withObject:response];
    [[L1DownloadManager sharedL1DownloadManager] performSelector:@selector(downloadEnded:) withObject:self];
}

-(void) downloadFailed:(NSError*) error
{
    [delegate performSelector:failSelector withObject:error];
    [[L1DownloadManager sharedL1DownloadManager] performSelector:@selector(downloadEnded:) withObject:self];

}


-(void) beginDownload
{
    connection = [[SimpleURLConnection  alloc] initWithURL:urlString 
                                                  delegate:self
                                              passSelector:@selector(downloadComplete:response:) 
                                              failSelector:@selector(downloadFailed:)];
    [connection runRequest];
    NSLog(@"Connection run.");
}



+(L1DownloadTarget*) targetWithString:(NSString*)string delegate:(NSObject*) del pass:(SEL) pass fail:(SEL) fail;
{
    L1DownloadTarget * target = [[L1DownloadTarget alloc] initWithString:string delegate:del pass:pass fail:fail];
    return [target autorelease];
}

-(void) dealloc
{
    
    [urlString release];
    [delegate release];
    [super dealloc];
}

@end



@implementation L1DownloadManager

SYNTHESIZE_SINGLETON_FOR_CLASS(L1DownloadManager)


-(id) init
{
    self = [super init];
    if (self){
        maxSimultaneousDownloads = DEFAULT_MAX_SIMULTANEOUS_DOWNLOADS;
        downloadQueue = [[L1Queue alloc] init];
        currentDownloads = [[NSMutableArray alloc] initWithCapacity:maxSimultaneousDownloads];
    }
    return self;
}

-(void) downloadEnded:(L1DownloadTarget*) download
{
    NSLog(@"Done download of %@",download.urlString);
    [currentDownloads removeObject:download];

    [self considerDownload];
}


-(void) considerDownload
{
    if (![downloadQueue count]) {
        NSLog(@"All downloads complete.");
        return;
    }
    if ([currentDownloads count]>maxSimultaneousDownloads){
        NSLog(@"Too many downloads right now.");
        return;
    }
    L1DownloadTarget * target = [downloadQueue dequeue];
    [currentDownloads addObject:target];
    NSLog(@"Starting download of %@",target.urlString);
    [target beginDownload];
}


-(void) downloadURLString:(NSString*) urlString 
               delegate:(id)delegate 
           passSelector:(SEL) passSel 
           failSelector:(SEL) failSel
{
 
    
    L1DownloadTarget * target = [L1DownloadTarget targetWithString:urlString delegate:delegate pass:passSel fail:failSel];
    [downloadQueue enqueue:target];
    [self considerDownload];
    
}

@end

//
//  L1DownloadManager.h
//  locations1
//
//  Created by Joe Zuntz on 10/08/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "L1Queue.h"
#import "SimpleURLConnection.h"

@interface L1DownloadManager : NSObject {
    int maxSimultaneousDownloads;
    int currentDownloadIndex;
    NSMutableArray * currentDownloads;
    L1Queue * downloadQueue;
    
}


+(L1DownloadManager*) sharedL1DownloadManager;

-(void) considerDownload;
-(void) downloadURLString:(NSString*) urlString 
               delegate:(id)delegate 
           passSelector:(SEL) passSel 
           failSelector:(SEL) failSel;

@end

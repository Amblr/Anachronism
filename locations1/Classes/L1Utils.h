//
//  L1Utils.h
//  locations1
//
//  Created by Joe Zuntz on 06/07/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface L1Utils : NSObject {
    
    
    
}
+(NSString*) cacheDirectory;
+(NSString*) resourceDirectory;
+(NSString*) soundDirectory;
+(BOOL) initializeDirs;

@end
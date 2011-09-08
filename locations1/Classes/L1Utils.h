//
//  L1Utils.h
//  locations1
//
//  Created by Joe Zuntz on 06/07/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>


#define TREAT_SIMULATOR_AS_3G 1

@interface L1Utils : NSObject {
    
    
    
}
+(NSString*) cacheDirectory;
+(NSString*) resourceDirectory;
+(NSString*) soundDirectory;
+(BOOL) initializeDirs;
+(BOOL) versionIs3X;

@end


int point_in_polygon(int nvert, float *vertx, float *verty, float testx, float testy);
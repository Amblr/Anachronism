//
//  L1Utils.m
//  locations1
//
//  Created by Joe Zuntz on 06/07/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1Utils.h"
#import "L1DeviceHardware.h"




@implementation L1Utils

+(void) createDirectoryIfNeeded:(NSString*)directory
{
    BOOL exists,isDir;
    NSFileManager * os = [NSFileManager defaultManager];
    exists=[os fileExistsAtPath:directory isDirectory:&isDir];
    if (exists && (!isDir)){
        NSString * errorMsg = [NSString stringWithFormat:@"A file already exists where we want to put the directory: %@",directory];
        if (!isDir) NSLog(@"%@",errorMsg);
    }
    else if (exists) {
        NSLog(@"Directory %@ already exists",directory);
    }
    else{
        
        NSError * error;
        BOOL success = [os createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
        if (success)
            NSLog(@"Created directory at %@",directory);
        else 
            NSLog(@"Failed to create directory at %@",directory);
    }
}


+(BOOL) initializeDirs
{
    [L1Utils createDirectoryIfNeeded:[L1Utils cacheDirectory]];
    [L1Utils createDirectoryIfNeeded:[L1Utils resourceDirectory]];
    [L1Utils createDirectoryIfNeeded:[L1Utils soundDirectory]];
    return YES;
    
}


+(BOOL) versionIs3X
{
    L1HardwareType hType = [L1DeviceHardware platform];
    return (hType==L1HardwareTypeiPhone3G || hType==L1HardwareTypeiPhone3GS) || (TREAT_SIMULATOR_AS_3G && hType==L1HardwareTypeSimulator);
    
}

+(NSString*) cacheDirectory
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, NO);
    NSAssert([paths count] > 0,@"Could not find cache dir");
    NSString * cacheDir = [paths objectAtIndex:0];
    NSString * amblrDir = [NSString pathWithComponents:[NSArray arrayWithObjects:cacheDir,@"Amblr",nil]];
    return [amblrDir stringByExpandingTildeInPath];
}

+(NSString*) resourceDirectory
{
    NSString * cacheDir = [L1Utils cacheDirectory];
    NSString * resourceDir = [NSString pathWithComponents:[NSArray arrayWithObjects:cacheDir,@"resource",nil]];
    return [resourceDir stringByExpandingTildeInPath];
}

+(NSString*) soundDirectory
{
    NSString * resourceDir = [L1Utils resourceDirectory];
    NSString * soundDir = [NSString pathWithComponents:[NSArray arrayWithObjects:resourceDir,@"sound",nil]];
    return [soundDir stringByExpandingTildeInPath];
  
}



@end


int point_in_polygon(int nvert, float *vertx, float *verty, float testx, float testy)
{
    int i, j, c = 0;
    for (i = 0, j = nvert-1; i < nvert; j = i++) {
        if ( ((verty[i]>testy) != (verty[j]>testy)) &&
            (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]) )
            c = !c;
    }
    return c;
}



//
//  L1Resource.m
//  locations1
//
//  Created by Joe Zuntz on 04/04/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1Resource.h"


@implementation L1Resource

-(id) initWithKey:(NSString *)resourceKey
{
    if ((self = [super init])){
        self.key = resourceKey;
    } 
    return self;

}

-(id) initWithDictionary:(NSDictionary*) data
{
    if ((self = [super init])){
        self.name = [data objectForKey:@"name"];
        self.key = [data objectForKey:@"key"];
        self.url = [NSURL URLWithString:[data objectForKey:@"url"]];
        self.type = [data objectForKey:@"type"];
        self.local = NO;
        self.metadata = [NSMutableDictionary dictionaryWithDictionary:[data objectForKey:@"metadata"]];
        self.resourceData = nil;
    }
    return self;

}


@synthesize name, url, type, local, key, metadata, resourceData;
@end

//
//  L1JsonSerializedObject.m
//  locations1
//
//  Created by Joe Zuntz on 15/06/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1JsonSerializedObject.h"


@implementation L1JsonSerializedObject


-(id) initWithDictionary:(NSDictionary*) propertiesDictionary
{
    self = [super init];
    if (self){
        NSDictionary * fieldNames = [[self class] serializedFieldNames];
        for (NSString * propertyName in fieldNames){
            NSString * propertyKey = [fieldNames objectForKey:propertyName];
            [self setValue:[propertiesDictionary objectForKey:propertyKey] forKeyPath:propertyName];
        }
    }
    return self;
}


//Return the mapping from property name to JSON name
+(NSDictionary*) serializedFieldNames
{
    return [NSDictionary dictionary];
}
@end

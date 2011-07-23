//
//  L1Plotline.h
//  locations1
//
//  Created by Joe Zuntz on 19/02/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>

//Contains a subset of the nodes, with sequences among them and rules about experiences?
//Does this even need to exist, or is it implicit in the definition of the nodes.

@interface L1Story : NSObject {
    NSMutableDictionary * nodes;
    NSMutableDictionary * paths;
    NSString * key;
    NSString * name;
    id delegate;
    
}
@property (retain) id delegate;
@property (retain) NSMutableDictionary * nodes;
@property (retain) NSMutableDictionary * paths;
@property (retain) NSString * key;
@property (retain) NSString * name;

@end

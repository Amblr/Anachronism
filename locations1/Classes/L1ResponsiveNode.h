//
//  L1ResponsiveNode.h
//  locations1
//
//  Created by Joe Zuntz on 21/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "L1MultiNode.h"


@interface L1ResponsiveNode : L1MultiNode {
	NSMutableArray * possibleResponses;

}
-(void) selectResponse:(NSString*)response;

@property (retain) NSMutableArray * possibleResponses;
@end

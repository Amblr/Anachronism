//
//  L1Experience.h
//  locations1
//
//  Created by Joe Zuntz on 19/02/2011.
//  Copyright 2011 Joe Zuntz. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface L1Experience : NSObject {
	NSString * eventID;
	NSDate * date;
}

@property (retain) NSString * eventID;
@property (retain) NSDate * date;
@end

//
//  L1Pin.h
//  locations1
//
//  Created by Joe Zuntz on 22/05/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface L1Pin : NSObject <MKAnnotation> {
    
@private
    
	CLLocationCoordinate2D _coordinate;
	NSString * _title;
	NSString * _subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

+ (L1Pin *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate;
+ (L1Pin *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle;
+ (L1Pin *)mapAnnotationWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle;

- (L1Pin *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate;
- (L1Pin *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle;
- (L1Pin *)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate title:(NSString *)aTitle subtitle:(NSString *)aSubtitle;

@end

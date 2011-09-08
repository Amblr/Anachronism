//
//  L1DeviceHardware.h
//  locations1
//
//  Created by Joe Zuntz on 08/09/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import <Foundation/Foundation.h>



//
//  UIDeviceHardware.h
//
//  Used to determine EXACT version of device software is running on.

#import <Foundation/Foundation.h>

typedef enum{
    L1HardwareTypeiPhoneUnknown,
    L1HardwareTypeiPhone1G,
    L1HardwareTypeiPhone3G,
    L1HardwareTypeiPhone3GS,
    L1HardwareTypeiPhone4,
    L1HardwareTypeVerizoniPhone4,
    L1HardwareTypeiPodTouch1G,
    L1HardwareTypeiPodTouch2G,
    L1HardwareTypeiPodTouch3G,
    L1HardwareTypeiPodTouch4G,
    L1HardwareTypeiPad,
    L1HardwareTypeiPad2WiFi,
    L1HardwareTypeiPad2GSM,
    L1HardwareTypeiPad2CDMA,
    L1HardwareTypeSimulator,
} L1HardwareType;


@interface L1DeviceHardware : NSObject 

+(L1HardwareType) platform;
+(NSString *) platformString;
+(NSString *) platformStringCode;

@end

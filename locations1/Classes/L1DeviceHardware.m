//
//  L1DeviceHardware.m
//  locations1
//
//  Created by Joe Zuntz on 08/09/2011.
//  Copyright 2011 Imperial College London. All rights reserved.
//

#import "L1DeviceHardware.h"


//
//  UIDeviceHardware.m
//
//  Used to determine EXACT version of device software is running on.

#include <sys/types.h>
#include <sys/sysctl.h>

@implementation L1DeviceHardware

+ (NSString *) platformStringCode{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

+(NSString *) platformString{
    NSString *platform = [L1DeviceHardware platformStringCode];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    return platform;
}

+(L1HardwareType) platform
{
    NSString *platform = [L1DeviceHardware platformStringCode];
    NSLog(@"Platform = %@",platform);
    if ([platform isEqualToString:@"iPhone1;1"]) return L1HardwareTypeiPhone1G;
    if ([platform isEqualToString:@"iPhone1;2"])return L1HardwareTypeiPhone3G;
    if ([platform isEqualToString:@"iPhone2;1"])return L1HardwareTypeiPhone3GS;
    if ([platform isEqualToString:@"iPhone3;1"])return L1HardwareTypeiPhone4;
    if ([platform isEqualToString:@"iPhone3;3"])return L1HardwareTypeVerizoniPhone4;
    if ([platform isEqualToString:@"iPod1;1"])  return L1HardwareTypeiPodTouch1G;
    if ([platform isEqualToString:@"iPod2;1"])  return L1HardwareTypeiPodTouch2G;
    if ([platform isEqualToString:@"iPod3;1"])  return L1HardwareTypeiPodTouch3G;
    if ([platform isEqualToString:@"iPod4;1"])  return L1HardwareTypeiPodTouch4G;
    if ([platform isEqualToString:@"iPad1;1"])  return L1HardwareTypeiPad;
    if ([platform isEqualToString:@"iPad2;1"])  return L1HardwareTypeiPad2WiFi;
    if ([platform isEqualToString:@"iPad2;2"])  return L1HardwareTypeiPad2GSM;
    if ([platform isEqualToString:@"iPad2;3"])  return L1HardwareTypeiPad2CDMA;
    if ([platform isEqualToString:@"i386"])return L1HardwareTypeSimulator;
    return L1HardwareTypeiPhoneUnknown;

}

@end

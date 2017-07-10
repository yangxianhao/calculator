//
//  GEStatusBar.m
//  ESP_2_0
//
//  Created by BC_design on 2016/12/1.
//  Copyright © 2016年 官洋. All rights reserved.
//

#import "GEStatusBar.h"

@implementation GEStatusBar

+ (UIView *)statusBar
{
    UIView *statusBar = nil;
    NSData *data = [NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9];
    NSString *key = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    id object = [UIApplication sharedApplication];
    if ([object respondsToSelector:NSSelectorFromString(key)])
        statusBar = [object valueForKey:key];
    return statusBar;
}

@end

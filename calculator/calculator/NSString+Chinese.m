//
//  NSString+Chinese.m
//  calculator
//
//  Created by 杨先豪 on 2017/6/24.
//  Copyright © 2017年 yangxianhao. All rights reserved.
//

#import "NSString+Chinese.h"

@implementation NSString (Chinese)

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)includeChinese
{
    for(int i = 0; i < [self length]; i++)
    {
        int a = [self characterAtIndex:i];
        if(a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

@end

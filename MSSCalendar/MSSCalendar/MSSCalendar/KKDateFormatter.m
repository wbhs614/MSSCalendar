//
//  KKDateFormatter.m
//  Stomatology
//
//  Created by kkmac on 2017/7/10.
//  Copyright © 2017年 cn.kekang.com. All rights reserved.
//

#import "KKDateFormatter.h"

@implementation KKDateFormatter
/*单例*/
static KKDateFormatter *instance = nil;
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KKDateFormatter alloc] init];
    });
    return instance;
}
@end

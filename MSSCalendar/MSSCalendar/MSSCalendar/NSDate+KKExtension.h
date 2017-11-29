//
//  NSDate+KKExtension.h
//  BeautifulAgent
//
//  Created by kkmac on 2017/6/12.
//  Copyright © 2017年 kkmac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (KKExtension)
+(NSString *)getTimeStrFromStrWithStr:(NSString *)oriStr;
/**
 时间处理
 @return 时间字符串
 */
+(NSString *)getHMTimeStrFromStr:(NSString *)oriStr;

/**
 获取当前时间
 @return 当前时间字符串
 */
+(NSString *)getCurrentTime;

/**
 获取当前时间(YY-mm-dd H:M)
 @return 返回当前时间
 */
+(NSString *)getCurrentTime1;

/**
 判断某一天是星期几
 @param dateStr 当前时间字符串
 @return 当前是星期几
 */
+(NSString *)getWeekStringFromDateString:(NSString *)dateStr;

/**
 字符串转时间
 @param formatestr 字符串的格式
 @param dateStr 字符串
 @return 返回一个本地时间
 */
+(NSDate *)getDateWithForamteStr:(NSString *)formatestr dateStr:(NSString *)dateStr;

/**
 字符串转时间
 @param formatestr 字符串的格式
 @param dateStr 字符串
 @return 返回一个本地时间
 */
+(NSString *)getDateStrWithForamteStr:(NSString *)formatestr date:(NSDate *)date ;
@end

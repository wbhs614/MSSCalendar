//
//  NSDate+KKExtension.m
//  BeautifulAgent
//
//  Created by kkmac on 2017/6/12.
//  Copyright © 2017年 kkmac. All rights reserved.
//

#import "NSDate+KKExtension.h"
#import "KKDateFormatter.h"
@implementation NSDate (KKExtension)


/**
 时间处理
 @return 时间字符串
 */
+(NSString *)getTimeStrFromStrWithStr:(NSString *)oriStr {
    char *cString = (char *)[oriStr UTF8String];
    struct tm _tm;
    int year, month, day, hour, minute,second;
    sscanf(cString, "%d/%d/%d %d:%d:%d", &year, &month, &day, &hour, &minute, &second);
    _tm.tm_year  = year - 1900;
    _tm.tm_mon   = month - 1;
    _tm.tm_mday  = day;
    _tm.tm_hour  = hour+8;/*解决相差相差8小时的问题*/
    _tm.tm_min   = minute;
    _tm.tm_sec   = second;
    _tm.tm_isdst = 0;
    time_t t = mktime(&_tm);
    struct tm *p;
    p=gmtime(&t);
    char s[100];
    strftime(s, sizeof(s), "%Y-%m-%d %H:%M:%S", p);
    NSString *ocTime=[NSString stringWithCString:s encoding:NSUTF8StringEncoding];
    return ocTime;
}

/**
 时间处理
 @return 时间字符串
 */
+(NSString *)getHMTimeStrFromStr:(NSString *)oriStr {
    char *cString = (char *)[oriStr UTF8String];
    struct tm _tm;
    int year, month, day, hour, minute,second;
    sscanf(cString, "%d-%d-%d %d:%d:%d", &year, &month, &day, &hour, &minute, &second);
    _tm.tm_year  = year - 1900;
    _tm.tm_mon   = month - 1;
    _tm.tm_mday  = day;
    _tm.tm_hour  = hour+8;/*解决相差相差8小时的问题*/
    _tm.tm_min   = minute;
    _tm.tm_sec   = second;
    _tm.tm_isdst = 0;
    time_t t = mktime(&_tm);
    struct tm *p;
    p=gmtime(&t);
    char s[100];
    strftime(s, sizeof(s), "%Y-%m-%d %H:%M", p);
    NSString *ocTime=[NSString stringWithCString:s encoding:NSUTF8StringEncoding];
    return ocTime;
}


/**
 获取当前时间(YY-mm-dd HH:MM:SS)
 @return 返回当前时间
 */
+(NSString *)getCurrentTime {
    time_t time_T;
    time_T = time(NULL);
    // tm对象格式的时间
    struct tm *tmTime;
    tmTime = localtime(&time_T);
    printf("Now Time is: %d:%d:%d\n", (*tmTime).tm_hour, (*tmTime).tm_min, (*tmTime).tm_sec);
    char* format = "%Y-%m-%d %H:%M:%S";
    char strTime[100];
    strftime(strTime, sizeof(strTime), format, tmTime);
    NSString *ocTime=[NSString stringWithCString:strTime encoding:NSUTF8StringEncoding];
    return ocTime;
}

+(NSString *)getCurrentTime1 {
    time_t time_T;
    time_T = time(NULL);
    // tm对象格式的时间
    struct tm *tmTime;
    tmTime = localtime(&time_T);
    printf("Now Time is: %d:%d:%d\n", (*tmTime).tm_hour, (*tmTime).tm_min, (*tmTime).tm_sec);
    char* format = "%Y-%m-%d %H:%M";
    char strTime[100];
    strftime(strTime, sizeof(strTime), format, tmTime);
    NSString *ocTime=[NSString stringWithCString:strTime encoding:NSUTF8StringEncoding];
    return ocTime;
}

/**
 获取当前时间( 年月日)
 @return 返回当前时间
 */
+(NSString *)getCurrentTime2 {
    time_t time_T;
    time_T = time(NULL);
    // tm对象格式的时间
    struct tm *tmTime;
    tmTime = localtime(&time_T);
    printf("Now Time is: %d:%d:%d\n", (*tmTime).tm_hour, (*tmTime).tm_min, (*tmTime).tm_sec);
    char* format = "%Y-%m-%d %H:%M";
    char strTime[100];
    strftime(strTime, sizeof(strTime), format, tmTime);
    NSString *ocTime=[NSString stringWithCString:strTime encoding:NSUTF8StringEncoding];
    return ocTime;
}

/**
 判断某一天是星期几
 @param dateStr 当前时间字符串
 @return 当前是星期几
 */
+(NSString *)getWeekStringFromDateString:(NSString *)dateStr {
    NSArray  *weeks=@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    int year, month, day;
    char *cString = (char *)[dateStr UTF8String];
    struct tm _tm;
    sscanf(cString, "%d-%d-%d", &year, &month, &day);
    _tm.tm_year  = year - 1900;
    _tm.tm_mon   = month - 1;
    _tm.tm_mday  = day;
    _tm.tm_hour  = 0+8;/*解决相差相差8小时的问题*/
    _tm.tm_min   = 0;
    _tm.tm_sec   = 0;
    _tm.tm_isdst = 0;
    time_t t = mktime(&_tm);
    struct tm *p;
    p=gmtime(&t);
    return [weeks objectAtIndex:p->tm_wday];
    
}

/**
 字符串转时间
 @param formatestr 字符串的格式
 @param dateStr 字符串
 @return 返回一个本地时间
 */
+(NSDate *)getDateWithForamteStr:(NSString *)formatestr dateStr:(NSString *)dateStr {
    KKDateFormatter *dateFormatter=[KKDateFormatter sharedManager];
    [dateFormatter setDateFormat:formatestr];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    return localDate;
}

/**
 字符串转时间
 @param formatestr 字符串的格式
 @param dateStr 字符串
 @return 返回一个本地时间
 */
+(NSString *)getDateStrWithForamteStr:(NSString *)formatestr date:(NSDate *)date {
    KKDateFormatter *dateFormatter=[KKDateFormatter sharedManager];
    [dateFormatter setDateFormat:formatestr];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString *dateStr=[dateFormatter stringFromDate:date];
    return dateStr;
}


@end

//
//  MSSCalendarManager.m
//  MSSCalendar
//
//  Created by sq580 on 16/4/4.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import "MSSCalendarManager.h"
#import "MSSChineseCalendarManager.h"

@interface MSSCalendarManager ()

@property (nonatomic,strong)NSDate *todayDate;
@property (nonatomic,strong)NSDateComponents *todayCompontents;
@property (nonatomic,strong)NSCalendar *greCalendar;
@property (nonatomic,strong)NSDateFormatter *dateFormatter;
@property (nonatomic,strong)MSSChineseCalendarManager *chineseCalendarManager;
@property (nonatomic,assign)BOOL showChineseHoliday;// 是否展示农历节日
@property (nonatomic,assign)BOOL showChineseCalendar;// 是否展示农历

@end

@implementation MSSCalendarManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static MSSCalendarManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MSSCalendarManager alloc] init];
    });
    
    return instance;
}

-(NSCalendar *)greCalendar {
    if (!_greCalendar) {
       _greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return _greCalendar;
}

- (instancetype)initWithShowChineseHoliday:(BOOL)showChineseHoliday showChineseCalendar:(BOOL)showChineseCalendar
{
    self = [super init];
    {
        //_greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *newDate=[NSDate dateWithTimeIntervalSinceNow:6*30*24*60*60];
        _todayDate = newDate;
       // _todayCompontents = [self dateToComponents:[NSDate date]];
        _dateFormatter = [[NSDateFormatter alloc]init];
        _chineseCalendarManager = [[MSSChineseCalendarManager alloc]init];
        _showChineseCalendar = showChineseCalendar;
        _showChineseHoliday = showChineseHoliday;
    }
    return self;
}

-(NSDateComponents *)todayCompontents {
    if (!_todayCompontents) {
        _todayCompontents = [self dateToComponents:[NSDate date]];
    }
    return _todayCompontents;
}

- (NSArray *)getCalendarDataSoruceWithLimitMonth:(NSInteger)limitMonth type:(MSSCalendarViewControllerType)type
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSDateComponents *components = [self dateToComponents:_todayDate];
    components.day = 1;
    if(type == MSSCalendarViewControllerNextType)
    {
        components.month -= 1;
    }
    else if(type == MSSCalendarViewControllerLastType)
    {
        components.month -= limitMonth;
    }
    else
    {
        components.month -= (limitMonth + 1) / 2;
    }
    NSInteger i = 0;
    for(i = 0;i < limitMonth;i++)
    {
        components.month++;
        MSSCalendarHeaderModel *headerItem = [[MSSCalendarHeaderModel alloc]init];
        NSDate *date = [self componentsToDate:components];
        [_dateFormatter setDateFormat: @"yyyy年MM月"];
        NSString *dateString = [_dateFormatter stringFromDate:date];
        headerItem.headerText = dateString;
        headerItem.year=[dateString substringToIndex:4].integerValue;
        headerItem.calendarItemArray = [self getCalendarItemArrayWithDate:date section:i];
        [resultArray addObject:headerItem];
    }
    return resultArray;
}

// 得到每一天的数据源
- (NSArray *)getCalendarItemArrayWithDate:(NSDate *)date section:(NSInteger)section
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSInteger tatalDay = [self numberOfDaysInCurrentMonth:date];
    NSInteger firstDay = [self startDayOfWeek:date];
    NSDateComponents *components = [self dateToComponents:date];
    // 判断日历有多少列
    NSInteger tempDay = tatalDay + (firstDay - 1);
    NSInteger column = 0;
    if(tempDay % 7 == 0)
    {
        column = tempDay / 7;
    }
    else
    {
        column = tempDay / 7 + 1;
    }
    NSInteger i = 0;
    NSInteger j = 0;
    components.day = 0;
    for(i = 0;i < column;i++)
    {
        for(j = 0;j < 7;j++)
        {
            if(i == 0 && j < firstDay - 1)
            {
                MSSCalendarModel *calendarItem = [[MSSCalendarModel alloc]init];
                calendarItem.year = 0;
                calendarItem.month = 0;
                calendarItem.day = 0;
                calendarItem.chineseCalendar = @"";
                calendarItem.holiday = @"";
                calendarItem.week = -1;
                calendarItem.dateInterval = -1;
                [resultArray addObject:calendarItem];
                continue;
            }
            components.day += 1;
            if(components.day == tatalDay + 1)
            {
                i = column;// 结束外层循环
                break;
            }
            MSSCalendarModel *calendarItem = [[MSSCalendarModel alloc]init];
            calendarItem.year = components.year;
            calendarItem.month = components.month;
            calendarItem.day = components.day;
            calendarItem.week = j;
            NSDate *date = [self componentsToDate:components];
            // 时间戳
            calendarItem.dateInterval = [self dateToInterval:date];
            [self setChineseCalendarAndHolidayWithDate:components date:date calendarItem:calendarItem];
            if(calendarItem.type == MSSCalendarTodayType)
            {
                _startIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            }
            [resultArray addObject:calendarItem];
        }
    }
    return resultArray;
}

// 一个月有多少天
- (NSUInteger)numberOfDaysInCurrentMonth:(NSDate *)date
{
    return [self.greCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

// 确定这个月的第一天是星期几
- (NSUInteger)startDayOfWeek:(NSDate *)date
{
    NSDate *startDate = nil;
    BOOL result = [self.greCalendar rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:NULL forDate:date];
    if(result)
    {
        return [self.greCalendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:startDate];
    }
    return 0;
}

// 日期转时间戳
- (NSInteger)dateToInterval:(NSDate *)date
{
    return (long)[date timeIntervalSince1970];
}

#pragma mark 农历和节假日
- (void)setChineseCalendarAndHolidayWithDate:(NSDateComponents *)components date:(NSDate *)date calendarItem:(MSSCalendarModel *)calendarItem
{
    if (components.year == self.todayCompontents.year && components.month == self.todayCompontents.month && components.day == self.todayCompontents.day)
    {
        calendarItem.type = MSSCalendarTodayType;
    }
    else
    {
        if([date compare:_todayDate] == 1)
        {
            calendarItem.type = MSSCalendarNextType;
        }
        else
        {
            calendarItem.type = MSSCalendarLastType;
        }
    }
}

#pragma mark NSDate和NSCompontents转换
- (NSDateComponents *)dateToComponents:(NSDate *)date
{
    NSDateComponents *components = [self.greCalendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSCalendarUnitWeekday| NSSecondCalendarUnit) fromDate:date];
    return components;
}

- (NSDate *)componentsToDate:(NSDateComponents *)components
{
    // 不区分时分秒
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *date = [self.greCalendar dateFromComponents:components];
    return date;
}


/**
 获取选中日期一段时间内的日期
 @param intervals 时间间隔
 @param currrentDate 选中的当前时间
 @return 返回一段时间的结果集
 */
-(NSArray *)getDateModelsWithInterval:(int)intervals date:(NSDate *)currrentDate{
    NSMutableArray *dateArray=[NSMutableArray arrayWithCapacity:abs(intervals)+1];
    NSInteger dis=24*60*60*1;
    //当前日期之前
    if (intervals>0) {
        for (int i=0; i<intervals; i++) {
            //NSDate *nextDate=[currrentDate initWithTimeIntervalSinceNow:(i+1)*dis];
            NSDate *nextDate=[NSDate dateWithTimeInterval:(i+1)*dis sinceDate:currrentDate];
            NSDateComponents *components = [self dateToComponents:nextDate];
            MSSCalendarModel *calendarItem = [[MSSCalendarModel alloc]init];
            calendarItem.year = components.year;
            calendarItem.month = components.month;
            calendarItem.day = components.day;
            calendarItem.week = components.weekday-1;
            calendarItem.select=NO;
            [self setChineseCalendarAndHolidayWithDate:components date:nextDate calendarItem:calendarItem];
            [dateArray addObject:calendarItem];
        }
    }
    //当前日期之后
    else {
        for (int i=0; i>intervals; i--) {
            NSDate *nextDate=[NSDate dateWithTimeInterval:(i-1)*dis sinceDate:currrentDate];
            NSDateComponents *components = [self dateToComponents:nextDate];
            MSSCalendarModel *calendarItem = [[MSSCalendarModel alloc]init];
            calendarItem.year = components.year;
            calendarItem.month = components.month;
            calendarItem.day = components.day;
            calendarItem.week = components.weekday-1;
            calendarItem.select=NO;
            [self setChineseCalendarAndHolidayWithDate:components date:nextDate calendarItem:calendarItem];
            [dateArray insertObject:calendarItem atIndex:0];
            //[dateArray reverseObjectEnumerator];
        }
    }
    return dateArray;
}
@end

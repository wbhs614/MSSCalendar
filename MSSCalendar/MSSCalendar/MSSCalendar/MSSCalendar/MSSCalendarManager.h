//
//  MSSCalendarManager.h
//  MSSCalendar
//
//  Created by sq580 on 16/4/4.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSCalendarViewController.h"
@interface MSSCalendarManager : NSObject

- (instancetype)initWithShowChineseHoliday:(BOOL)showChineseHoliday showChineseCalendar:(BOOL)showChineseCalendar;

/**
 获取几个月的时间
 @param limitMonth 月数
 @param type 当前日历类型
 @return 几个月时间数据集
 */
- (NSArray *)getCalendarDataSoruceWithLimitMonth:(NSInteger)limitMonth type:(MSSCalendarViewControllerType)type;

/**
 获取选中日期前后的一段时间内的日期
 @param intervals 时间间隔
 @param currrentDate 选中的当前时间
 @return 返回一段时间的结果集
 */
-(NSArray *)getDateModelsWithInterval:(int)intervals date:(NSDate *)currrentDate;

- (NSDateComponents *)dateToComponents:(NSDate *)date;
/**月日历开始的所在的行*/
@property (nonatomic,strong)NSIndexPath *startIndexPath;
/**时间管理的单例*/
+(instancetype)sharedManager;
@end

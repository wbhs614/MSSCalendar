//
//  MSSCalendarHeaderModel.h
//  MSSCalendar
//
//  Created by sq580 on 16/4/5.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSSCalendarHeaderModel : NSObject
@property (assign)NSInteger year;
@property (nonatomic,copy)NSString *headerText;
@property (nonatomic,strong)NSArray *calendarItemArray;
@end

typedef NS_ENUM(NSInteger, MSSCalendarType)
{
    MSSCalendarTodayType = 0,
    MSSCalendarLastType,
    MSSCalendarNextType
};

@interface MSSCalendarModel : NSObject
@property (nonatomic,assign)NSInteger year;
@property (nonatomic,assign)NSInteger month;
@property (nonatomic,assign)NSInteger day;
@property (nonatomic,copy)NSString *chineseCalendar;// 农历
@property (nonatomic,copy)NSString *holiday;// 节日
@property (nonatomic,assign)MSSCalendarType type;
@property (nonatomic,assign)NSInteger dateInterval;// 日期的时间戳
@property (nonatomic,assign)NSInteger week;// 星期
@property (assign,getter=isSelected)BOOL select;//是否选中的model
@end

@interface MSSYearModel : NSObject
@property (nonatomic,assign)NSInteger year;//年
@property (nonatomic,strong)NSMutableArray *months;//月的数组

@end

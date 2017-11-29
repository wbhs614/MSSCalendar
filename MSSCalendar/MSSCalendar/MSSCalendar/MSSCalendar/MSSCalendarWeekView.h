//
//  MSSClendaerWeekView.h
//  MSSCalendar
//
//  Created by kkmac on 2017/8/19.
//  Copyright © 2017年 kkmac. All rights reserved.
//

/*月--星期的头部，年--每个月星期的头部*/
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, WeekHeaderType){
    KKYearType = 0,//年日历部分星期
    KKMonthType = 1 //月日历部分星期
};

@interface MSSCalendarWeekView : UIView
-(instancetype)initWithFrame:(CGRect)frame haaderType:(WeekHeaderType )type;

@end

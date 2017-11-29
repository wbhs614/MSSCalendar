//
//  MSSChineseCalendarManager.h
//  MSSCalendar
//
//  Created by sq580 on 16/4/5.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSCalendarHeaderModel.h"

@interface MSSChineseCalendarManager : NSObject

- (void)getChineseCalendarWithDate:(NSDate *)date calendarItem:(MSSCalendarModel *)calendarItem;

- (BOOL)isQingMingholidayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end

//
//  MSSCalendarHeaderModel.m
//  MSSCalendar
//
//  Created by sq580 on 16/4/5.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import "MSSCalendarHeaderModel.h"

@implementation MSSCalendarHeaderModel

@end

@implementation MSSCalendarModel

@end

@implementation MSSYearModel
-(instancetype)init {
    if (self=[super init]) {
        self.months=[NSMutableArray arrayWithCapacity:12];
    }
    return self;
}
@end

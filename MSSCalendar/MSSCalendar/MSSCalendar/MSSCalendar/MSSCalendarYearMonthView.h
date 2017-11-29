//
//  MSSCalendarYearMonthView.h
//  MSSCalendar
//
//  Created by kkmac on 2017/8/19.
//  Copyright © 2017年 kkmac. All rights reserved.
//

/*年控件上面的月cell的自定义view（一个cell上面显示一个月）*/
#import <UIKit/UIKit.h>
#import "MSSCalendarHeaderModel.h"
@interface MSSCalendarYearMonthView : UIView
-(instancetype)initWithFrame:(CGRect)frame model:(MSSCalendarHeaderModel *)model;
-(void)refreshWeekViewWithModel:(MSSCalendarHeaderModel *)model;
@end

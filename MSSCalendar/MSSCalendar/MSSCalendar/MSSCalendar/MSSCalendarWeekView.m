//
//  MSSClendaerWeekView.m
//  MSSCalendar
//
//  Created by kkmac on 2017/8/19.
//  Copyright © 2017年 kkmac. All rights reserved.
//

#import "MSSCalendarWeekView.h"
#import "MSSCalendarDefine.h"
#import "Global.h"
@implementation MSSCalendarWeekView

-(instancetype)initWithFrame:(CGRect)frame haaderType:(WeekHeaderType )type {
    if (self=[super initWithFrame:frame]) {
        [self addWeakViewWithFrame:frame type:type];
    }
    return self;
}

- (void)addWeakViewWithFrame:(CGRect)frame type:(WeekHeaderType) type
{
    NSArray *weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    int i = 0;
    NSInteger width = frame.size.width/7.0;
    for(i = 0; i < 7;i++)
    {
        UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * width, 0, width, frame.size.height)];
        weekLabel.backgroundColor = [UIColor clearColor];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        if (type==KKMonthType) {
            if(i == 0 || i == 6)
            {
                weekLabel.textColor = MSS_TodayBackgroundColor;
            }
            else
            {
                weekLabel.textColor = MSS_UTILS_COLORRGB(78, 78, 78);
            }
            weekLabel.text = weekArray[i];
            weekLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            self.backgroundColor = [UIColor whiteColor];
            UIView *underLine=[[UIView alloc]initWithFrame:CGRectMake(0, MSS_WeekViewHeight-1, MSS_SCREEN_WIDTH, 1)];
            underLine.backgroundColor=[UIColor groupTableViewBackgroundColor];
            [self addSubview:underLine];
        }
        else {
            weekLabel.text=[weekArray[i] stringByReplacingOccurrencesOfString:@"周" withString:@""];
            weekLabel.textColor = MSS_UTILS_COLORRGB(78, 78, 78);
            weekLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            self.backgroundColor = [UIColor clearColor];
        }
        [self addSubview:weekLabel];
    }
 
    
}
@end

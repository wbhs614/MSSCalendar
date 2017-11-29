//
//  MSSCalendarYearMonthView.m
//  MSSCalendar
//
//  Created by kkmac on 2017/8/19.
//  Copyright © 2017年 kkmac. All rights reserved.
//

#import "MSSCalendarYearMonthView.h"
#import "Global.h"
#import <Masonry.h>
#import "MSSCalendarDefine.h"
#import "MSSCalendarWeekView.h"
#import "MSSCalendarHeaderModel.h"
#import "MSSCircleLabel.h"
#define defaultWeekWidth self.bounds.size.width/7
@interface MSSCalendarYearMonthView()
@property(nonatomic,strong)UILabel *monthLabel;
@property(nonatomic,strong)UILabel *accountLabel;
@end

@implementation MSSCalendarYearMonthView
-(instancetype)initWithFrame:(CGRect)frame model:(MSSCalendarHeaderModel *)model{
    if (self=[super initWithFrame:frame]) {
        [self addWeekHaderViewWithModel:model];
        [self addDayLabesWithModel:model];
    }
    return self;
}

/*添加顶部的haderView*/
-(void)addWeekHaderViewWithModel:(MSSCalendarHeaderModel *)model {
    self.monthLabel=[[UILabel alloc]init];
    self.accountLabel=[[UILabel alloc]init];
    self.monthLabel.font=[UIFont systemFontOfSize:20.0];
    self.accountLabel.font=[UIFont systemFontOfSize:12.0];
    self.accountLabel.textAlignment=NSTextAlignmentCenter;
    self.monthLabel.textAlignment=NSTextAlignmentCenter;
    self.accountLabel.text=@"300/256";
    self.accountLabel.tag=1000;
    self.monthLabel.tag=1001;
    self.monthLabel.text=[NSString stringWithFormat:@"%ld月",[model.headerText substringFromIndex:5].integerValue];
    self.monthLabel.textColor=MSS_TodayBackgroundColor;
    [self addSubview:self.monthLabel];
    [self addSubview:self.accountLabel];
    MSSCalendarWeekView *weekView=[[MSSCalendarWeekView alloc]initWithFrame:CGRectMake(0, 25, self.frame.size.width, 25)haaderType:KKYearType];
    [self addSubview:weekView];
}

-(void)refreshWeekViewWithModel:(MSSCalendarHeaderModel *)model {
    UILabel *countLabel=[self viewWithTag:1000];
    UILabel *monthLabel=[self viewWithTag:1001];
    countLabel.text=@"200/700";
    monthLabel.text=model.headerText?[NSString stringWithFormat:@"%ld月",[model.headerText substringFromIndex:5].integerValue]:@"";
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[MSSCircleLabel class]]) {
            MSSCircleLabel *label=(MSSCircleLabel *)subView;
                if ((label.tag-1)>=0&&(label.tag-1)<42) {
                    label.text=@"";
                    if ((label.tag-1)<model.calendarItemArray.count) {
                        MSSCalendarModel *calendarModel=model.calendarItemArray[label.tag-1];
                        if (calendarModel.dateInterval>0) {
                            if (calendarModel.type==MSSCalendarTodayType) {
                                label.isToday=YES;
                                label.textColor=[UIColor whiteColor];
                            }
                            else {
                                label.isToday=NO;
                                label.textColor=MSS_UTILS_COLORRGB(78, 78, 78);
                            }
                            label.text=[NSString stringWithFormat:@"%ld",calendarModel.day];
                        }
                        else {
                            label.text=@"";
                        }
                    }
            }
        }
    }
}

/*添加下面的天数的label（按照一个星期最多六行计创建42个label）*/
-(void)addDayLabesWithModel:(MSSCalendarHeaderModel *)model {
    for (int i=0; i<6; i++) {
        for (int j=0; j<7; j++) {
            MSSCircleLabel *label=[[MSSCircleLabel alloc]init];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:10.0];
            label.textColor=MSS_UTILS_COLORRGB(78, 78, 78);
            [label setFrame:CGRectMake(j*defaultWeekWidth, i*defaultWeekWidth+50, defaultWeekWidth, defaultWeekWidth)];
            NSInteger index=i*7+j;
            label.tag=index+1;
            if (index<model.calendarItemArray.count) {
                MSSCalendarModel *calendarModel=model.calendarItemArray[index];
                if (calendarModel.dateInterval>0) {
                    if (calendarModel.type==MSSCalendarTodayType) {
                        label.isToday=YES;
                        label.textColor=[UIColor whiteColor];
                    }
                    else {
                        label.isToday=NO;
                        label.textColor=MSS_UTILS_COLORRGB(78, 78, 78);
                    }
                   label.text=[NSString stringWithFormat:@"%ld",calendarModel.day];
                }
                else {
                   label.text=@"";
                }
            }
            
            [self addSubview:label];
        }
    }
}


-(void)layoutSubviews {
    [super layoutSubviews];
    Weak(self);
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).mas_offset(0);
        make.top.equalTo(weakself.mas_top).mas_offset(0);
        make.height.mas_equalTo(25);
    }];
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.mas_right).mas_offset(0);
        make.top.equalTo(weakself.mas_top).mas_offset(0);
        make.height.mas_equalTo(25);
    }];
}


@end

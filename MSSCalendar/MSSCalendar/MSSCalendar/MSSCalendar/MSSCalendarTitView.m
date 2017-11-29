//
//  MSSCalendarTitView.m
//  MSSCalendar
//
//  Created by kkmac on 2017/8/19.
//  Copyright © 2017年 kkmac. All rights reserved.
//

#import "MSSCalendarTitView.h"
#import "MSSCalendarDefine.h"
#import <Masonry.h>
#import "Global.h"
@interface MSSCalendarTitView()
@property(copy,nonatomic)void(^segmentBlock)(NSInteger index);
@property(nonatomic,strong)UIImageView *calendarView;
@end


@implementation MSSCalendarTitView

-(instancetype)initWithFrame:(CGRect)frame segmentBlock:(void(^)(NSInteger index))block{
    if (self=[super initWithFrame:frame]) {
        [self setupView];
        self.backgroundColor=MSS_WeeKBackGroundColor;
        self.segmentBlock=block;
    }
    return self;
}

-(void)setupView {
    //分段控件
    self.segment=[[UISegmentedControl alloc]initWithItems:@[@"月",@"年"]];
    self.segment.tintColor=MSS_TodayBackgroundColor;
    self.segment.selectedSegmentIndex=1;
    [self.segment addTarget:self action:@selector(onSegmentChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.segment];
    //左边的时间
    self.timeLabel=[[UILabel alloc]init];
    self.timeLabel.textColor=MSS_UTILS_COLORRGB(78, 78, 78);
    self.timeLabel.font=[UIFont boldSystemFontOfSize:16.0];
    self.timeLabel.textAlignment=NSTextAlignmentLeft;
    self.timeLabel.text=@"2017年08月";
    [self addSubview:self.timeLabel];
    //右边的日历
    self.calendarView=[[UIImageView alloc]init];
    self.calendarView.backgroundColor=[UIColor yellowColor];
    [self addSubview:self.calendarView];
}

-(void)onSegmentChange:(UISegmentedControl *)sender {
    self.segmentBlock(sender.selectedSegmentIndex);
    
}

-(void)layoutSubviews {
    Weak(self);
    [super layoutSubviews];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.centerY.equalTo(weakself.mas_centerY).offset(8);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).mas_offset(10);
        make.centerY.equalTo(weakself.segment.mas_centerY);
    }];
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.mas_right).mas_offset(-10);
        make.centerY.equalTo(weakself.segment.mas_centerY);
        make.height.and.width.mas_equalTo(40);
    }];
}

@end

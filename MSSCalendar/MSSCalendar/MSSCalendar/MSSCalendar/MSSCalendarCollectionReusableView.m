//
//  MSSCalendarCollectionReusableView.m
//  MSSCalendar
//
//  Created by sq580 on 16/4/5.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import "MSSCalendarCollectionReusableView.h"
#import "MSSCalendarCollectionReusableView.h"
#import "MSSCalendarDefine.h"
#import "Global.h"
#import <Masonry.h>
@interface MSSCalendarYearCollectionReusableView ()
@property(nonatomic,strong)UILabel *underLine;//下划线
@property(nonatomic,strong)UILabel *timeLabel;//时间label
@property(nonatomic,strong)UILabel *comLabel;//已完成label
@property(nonatomic,strong)UILabel *orderLabel;//已预约label
@end

@implementation MSSCalendarCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createReusableView];
    }
    return self;
}

- (void)createReusableView
{
    UIView *headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:headerView];
    _headerLabel = [[UILabel alloc]init];
    _headerLabel.frame = CGRectMake(10, 0, self.frame.size.width - 10, self.frame.size.height);
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.backgroundColor = [UIColor clearColor];
    _headerLabel.textColor = MSS_HeaderViewTextColor;
    [headerView addSubview:_headerLabel];
    UIView *topLineView = [[UIView alloc]init];
    topLineView.frame = CGRectMake(0, 0, headerView.frame.size.width, MSS_ONE_PIXEL);
    [headerView addSubview:topLineView];
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.frame = CGRectMake(0, headerView.frame.size.height - MSS_ONE_PIXEL, headerView.frame.size.width, MSS_ONE_PIXEL);
    [headerView addSubview:bottomLineView];
}

@end


#pragma MSSCalendarYearCollectionReusableView Method
@implementation MSSCalendarYearCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView {
    //下划线
    self.underLine=[[UILabel alloc]init];
    self.underLine.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self addSubview:self.underLine];
    //时间label
    self.timeLabel=[[UILabel alloc]init];
    self.timeLabel.textColor=MSS_UTILS_COLORRGB(50, 50, 50);
    self.timeLabel.textAlignment=NSTextAlignmentCenter;
    self.timeLabel.font=[UIFont fontWithName:@"Bangla Sangam MN" size:30];
    [self addSubview:self.timeLabel];
    //已完成label
    self.comLabel=[[UILabel alloc]init];
    self.comLabel.textColor=MSS_UTILS_COLORRGB(120, 120, 120);
    self.comLabel.textAlignment=NSTextAlignmentLeft;
    self.comLabel.font=[UIFont systemFontOfSize:14.0];
    self.comLabel.text=@"已成交:83945人次";
    [self addSubview:self.comLabel];
    //预约按妞
    self.orderLabel=[[UILabel alloc]init];
    self.orderLabel.textColor=MSS_UTILS_COLORRGB(120, 120, 120);
    self.orderLabel.textAlignment=NSTextAlignmentLeft;
    self.orderLabel.font=[UIFont systemFontOfSize:14.0];
    self.orderLabel.text=@"已预约:87328人次";
    [self addSubview:self.orderLabel];
}

-(void)setYearModel:(MSSYearModel *)yearModel {
    _yearModel=yearModel;
    self.timeLabel.text=[NSString stringWithFormat:@"%ld年",yearModel.year];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    Weak(self);
    [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).offset(80);
        make.right.equalTo(weakself.mas_right).offset(-80);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(weakself.mas_bottom);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).offset(80);
        make.bottom.equalTo(weakself.underLine.mas_top);
        make.height.mas_equalTo(30);
    }];
    [self.comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.mas_bottom).mas_offset(-10);
        make.right.equalTo(weakself.mas_right).offset(-80);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(150);
    }];
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.comLabel.mas_top).mas_offset(-5);
        make.right.equalTo(weakself.mas_right).offset(-80);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(150);
    }];
}

@end

//
//  MSSCalendarCollectionViewCell.m
//  MSSCalendar
//
//  Created by sq580 on 16/4/4.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import "MSSCalendarCollectionViewCell.h"
#import "MSSCalendarDefine.h"
#import "Global.h"
#import <Masonry.h>

@implementation MSSCalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    {
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    __weak MSSCalendarCollectionViewCell *weakSelf=self;
    UILabel *rightLine=[[UILabel alloc]init];
    rightLine.backgroundColor=RGBA(230, 230, 230, 1.0);
    [self.contentView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView.mas_top).mas_offset(0);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).mas_offset(0.70);
        make.width.mas_equalTo(0.70);
    }];
    UILabel *bottomLine=[[UILabel alloc]init];
    bottomLine.backgroundColor=RGBA(230, 230, 230, 1.0);
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).mas_offset(0);
        make.left.equalTo(weakSelf.contentView.mas_left).mas_offset(0);
        make.right.equalTo(weakSelf.contentView.mas_right).mas_offset(1);
        make.height.mas_equalTo(0.75);
    }];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.contentView addSubview:_imageView];
    
    _dateLabel = [[MSSCircleLabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-45, 5, 40, 40)];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_dateLabel];
    
    _subLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_dateLabel.frame), self.contentView.frame.size.width, _dateLabel.frame.size.height)];
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.font = [UIFont systemFontOfSize:10.0f];
    [self.contentView addSubview:_subLabel];
}


-(void)setIsToday:(BOOL)isToday {
    _dateLabel.isToday=isToday;
}
@end

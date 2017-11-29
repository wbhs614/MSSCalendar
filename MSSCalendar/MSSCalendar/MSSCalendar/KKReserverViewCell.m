//
//  KKReserverViewCell.m
//  MSSCalendar
//
//  Created by kkmac on 2017/10/23.
//  Copyright © 2017年 于威. All rights reserved.
//

#import "KKReserverViewCell.h"
#import <Masonry.h>
#import "Global.h"
#import "MSSCircleLabel.h"
#import "MSSCalendarHeaderModel.h"

@implementation KKReserverViewCell
+(KKReserverViewCell *)collectionView:(UICollectionView *)clvView cellId:(NSString *)cellId indexPath:(NSIndexPath *)indexPath model:(MSSCalendarModel *)model {
    KKReserverViewCell *cell=[clvView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    MSSCircleLabel *titleLabel=[cell.contentView viewWithTag:1];
    if (titleLabel==nil) {
        titleLabel=[[MSSCircleLabel alloc]init];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.textColor=RGBA(50, 50, 50, 1.0);
        titleLabel.tag=1;
        titleLabel.numberOfLines=0;
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(cell.contentView);
            make.top.equalTo(cell.contentView.mas_top).offset(5);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-5);
        }];
    }
    if (model.type==MSSCalendarTodayType) {
        titleLabel.isToday=YES;
        titleLabel.textColor=[UIColor whiteColor];
    }
    else {
        titleLabel.isToday=NO;
        titleLabel.textColor=RGBA(50, 50, 50, 1.0);
        titleLabel.selected=model.isSelected;
    }
    NSString *week=[cell getWeekDayFromModel:model];
    NSInteger day=model.day;
    NSString *timeStr=[NSString stringWithFormat:@"%ld\n%@",(long)day,week];
    NSRange range=[timeStr rangeOfString:[NSString stringWithFormat:@"%ld",day]];
    NSMutableAttributedString *attributedStr= [[NSMutableAttributedString alloc] initWithString: timeStr];
    NSDictionary* dict=@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]};
    [attributedStr addAttributes:dict range:range];
    NSRange range1=[timeStr rangeOfString:[NSString stringWithFormat:@"%@",week]];
    [attributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0]} range:range1];
    titleLabel.attributedText=attributedStr;
    return cell;
}

-(NSString *)getWeekDayFromModel:(MSSCalendarModel *)model {
    NSString *weekStr=@"";
    switch (model.week) {
        case 0:
            weekStr=@"周日";
            break;
        case 1:
            weekStr=@"周一";
            break;
        case 2:
            weekStr=@"周二";
            break;
        case 3:
            weekStr=@"周三";
            break;
        case 4:
            weekStr=@"周四";
            break;
        case 5:
            weekStr=@"周五";
            break;
        case 6:
            weekStr=@"周六";
            break;
        default:
            break;
    }
    return weekStr;
}
@end

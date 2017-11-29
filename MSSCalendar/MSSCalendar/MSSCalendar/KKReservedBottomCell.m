//
//  KKReservedBottomCell.m
//  ReservedBottomViewDemo
//
//  Created by kkmac on 2017/10/25.
//  Copyright © 2017年 ReservedBottomViewDemo. All rights reserved.
//

#import "KKReservedBottomCell.h"
#import "Global.h"
#import <Masonry.h>
@interface KKReservedBottomCell ()
@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)UILabel *titleLabe;
@end
@implementation KKReservedBottomCell
+(KKReservedBottomCell *)collectionView:(UICollectionView *)clvView cllId:(NSString *)cellId indexPath:(NSIndexPath *)indexPath title:(NSString *)title{
    KKReservedBottomCell *cell=[clvView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.headerImageView=[cell.contentView viewWithTag:1];
    cell.titleLabe=[cell.contentView viewWithTag:2];
    if (!cell.headerImageView) {
        cell.headerImageView=[[UIImageView alloc]init];
        [cell.contentView addSubview:cell.headerImageView];
        cell.headerImageView.backgroundColor=[UIColor redColor];
        cell.headerImageView.layer.cornerRadius=10.0;
    }
    //cell.headerImageView.image=[UIImage imageNamed:@"Arrow"];
    if (!cell.titleLabe) {
        cell.titleLabe=[[UILabel alloc]init];
        cell.titleLabe.textAlignment=NSTextAlignmentLeft;
        cell.titleLabe.textColor=RGBA(120, 120, 120, 1.0);
        cell.titleLabe.font=[UIFont systemFontOfSize:10.0];
        [cell.contentView addSubview:cell.titleLabe];
    }
    cell.titleLabe.text=title;
    return cell;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    Weak(self);
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.contentView.mas_left).mas_offset(5);
        make.centerY.equalTo(weakself.contentView.mas_centerY);
        make.height.and.width.mas_equalTo(20);
    }];
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.headerImageView.mas_right).mas_offset(5);
        make.right.equalTo(weakself.contentView.mas_right);
        make.top.and.bottom.equalTo(weakself.contentView);
    }];
}
@end

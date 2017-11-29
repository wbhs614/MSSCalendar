//
//  ReservedTimeView.m
//  MSSCalendar
//
//  Created by kkmac on 2017/10/21.
//  Copyright © 2017年 kkmac. All rights reserved.
//

#import "KKReservedTimeView.h"
#import "KKReserverViewCell.h"
#import <Masonry.h>
#import "Global.h"
#define itemWidth (ScreenWidth-216)/7.0
static  NSString* const KKReserverTimeCellId=@"KKReserverViewCell";
@interface KKReservedTimeView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *weekLabel;
@property(nonatomic,strong)UILabel *speartLine;

@property(nonatomic,strong)NSArray *dates;
@end
@implementation KKReservedTimeView

-(instancetype)initWithFrame:(CGRect)frame dates:(NSArray *)dates selectedModel:(MSSCalendarModel *)model {
    if (self=[super initWithFrame:frame]) {
        self.dates=dates;
        [self setupViewsWithModel:model];
    }
    return self;
}

-(void)refreshClvWithDates:(NSArray *)dates selectedModel:(MSSCalendarModel *)model {
    self.timeLabel.text=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)model.year,(long)model.month,(long)model.day];
    self.weekLabel.text=[self getWeekDayFromModel:model];
    self.dates=dates;
    [self.collectionView reloadData];
}

-(void)setupViewsWithModel:(MSSCalendarModel *)model {
    //日期的label
    self.timeLabel=[[UILabel alloc]init];
    self.timeLabel.font=[UIFont systemFontOfSize:15.0];
    self.timeLabel.textAlignment=NSTextAlignmentLeft;
    self.timeLabel.textColor=RGBA(50, 50, 50, 1.0);
    self.timeLabel.text=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)model.year,(long)model.month,(long)model.day];
    [self addSubview:self.timeLabel];
    //星期label
    self.weekLabel=[[UILabel alloc]init];
    self.weekLabel.font=[UIFont boldSystemFontOfSize:15.0];
    self.weekLabel.textAlignment=NSTextAlignmentLeft;
    self.weekLabel.textColor=RGBA(50, 50, 50, 1.0);
    self.weekLabel.text=[self getWeekDayFromModel:model];
    [self addSubview:self.weekLabel];
    //竖线
    self.speartLine=[[UILabel alloc]init];
    self.speartLine.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self addSubview:self.speartLine];
    //日期的collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    flowLayout.itemSize=CGSizeMake(itemWidth, 45);
    flowLayout.minimumLineSpacing=0.0;
    flowLayout.minimumInteritemSpacing=0.0;
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    [self.collectionView registerClass:[KKReserverViewCell class] forCellWithReuseIdentifier:KKReserverTimeCellId];
    [self addSubview:self.collectionView];
}



-(void)layoutSubviews {
    [super layoutSubviews];
    Weak(self);
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.mas_left).mas_offset(10);
        make.top.and.bottom.equalTo(weakself);
        make.width.mas_equalTo(115);
    }];
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakself);
        make.left.equalTo(weakself.timeLabel.mas_right).offset(20);
        make.width.mas_equalTo(50);
    }];
    [self.speartLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.mas_top).mas_offset(10);
        make.bottom.equalTo(weakself.mas_bottom).mas_offset(-10);
        make.left.equalTo(weakself.weekLabel.mas_right).mas_offset(20);
        make.width.mas_equalTo(1);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(weakself);
        make.left.equalTo(weakself.speartLine.mas_right);
        make.right.equalTo(weakself.mas_right).mas_offset(-10);
    }];
    
}

-(NSString *)getWeekDayFromModel:(MSSCalendarModel *)model {
    NSString *weekStr=@"";
    switch (model.week) {
        case 0:
            weekStr=@"星期日";
            break;
        case 1:
            weekStr=@"星期一";
            break;
        case 2:
            weekStr=@"星期二";
            break;
        case 3:
            weekStr=@"星期三";
            break;
        case 4:
            weekStr=@"星期四";
            break;
        case 5:
            weekStr=@"星期五";
            break;
        case 6:
            weekStr=@"星期六";
            break;
        default:
            break;
    }
    return weekStr;
}

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MSSCalendarModel *model=self.dates[indexPath.row];
    KKReserverViewCell *cell=[KKReserverViewCell collectionView:collectionView cellId:KKReserverTimeCellId indexPath:indexPath model:model];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MSSCalendarModel *model=self.dates[indexPath.row];
    self.timeLabel.text=[NSString stringWithFormat:@"%ld年%ld月%ld日",(long)model.year,(long)model.month,(long)model.day];
    self.weekLabel.text=[self getWeekDayFromModel:model];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"select==Yes"];
    NSArray *selectedArray=[self.dates filteredArrayUsingPredicate:predicate];
    if (selectedArray&&selectedArray.count>0) {
        MSSCalendarModel *tempModel=[selectedArray lastObject];
        tempModel.select=NO;
        NSInteger index=[self.dates indexOfObject:tempModel];
        NSIndexPath *oldIndex=[NSIndexPath indexPathForRow:index inSection:0];
        [collectionView reloadItemsAtIndexPaths:@[oldIndex]];
    }
    model.select=YES;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end

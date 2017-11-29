//
//  KKReservedBottomView.m
//  ReservedBottomViewDemo
//
//  Created by kkmac on 2017/10/25.
//  Copyright © 2017年 ReservedBottomViewDemo. All rights reserved.
//

#import "KKReservedBottomView.h"
#import "KKReservedBottomCell.h"
#import "NSString+KKExtension.h"
#import <Masonry.h>
#import "Global.h"
//#define itemWidth (ScreenWidth)/13.0

static NSString * const KKReservedBottomCellName=@"KKReservedBottomCell";
@interface KKReservedBottomView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)UILabel *countLabel;
@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)UILabel *sperartLabel;
@property(strong,nonatomic)NSArray *titles;
@property(strong,nonatomic)NSMutableArray *itemWidths;
@property(assign)KKReserveType roleType;
@end

@implementation KKReservedBottomView
-(instancetype)initWithFrame:(CGRect)frame roleType:(KKReserveType )roleType {
    if (self=[super initWithFrame:frame]) {
        self.roleType=roleType;
        self.itemWidths=[NSMutableArray arrayWithCapacity:self.titles.count];
        [self getTitleWidths];
        [self setupView];
    }
    return self;
}

-(void)getTitleWidths {
    for (NSString *title in self.titles) {
        CGSize size=[title boundingSizeWithFont:[UIFont systemFontOfSize:10.0] maxBoundingSize:CGSizeMake(MAXFLOAT, 45)];
        [self.itemWidths addObject:@(size.width+33)];
    }
}

-(void)setupView {
    //创建数量的label
    self.countLabel=[[UILabel alloc]init];
    self.countLabel.textColor=RGBA(50, 50, 50, 1.0);
    self.countLabel.font=[UIFont systemFontOfSize:14.0];
    self.countLabel.text=@"今日主任预约人数：0人";
    [self addSubview:self.countLabel];
    //创建分割线
    self.sperartLabel=[[UILabel alloc]init];
    self.sperartLabel.backgroundColor=RGBA(195, 195, 195, 1.0);
    [self addSubview:self.sperartLabel];
    //创建collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[KKReservedBottomCell class] forCellWithReuseIdentifier:KKReservedBottomCellName];
}

-(NSArray *)titles {
    if (!_titles) {
        if (self.roleType==KKDirectorReserve) {
            _titles=@[@"老爷爷",@"老太太",@"男士",@"女士",@"男孩",@"女孩",@"默认",@"候诊预警",@"停车位",@"有备注"];
        }
        else {
            _titles=@[@"老爷爷",@"老太太",@"男士",@"女士",@"男孩",@"女孩",@"默认",@"候诊预警",@"停车位",@"欠费",@"有备注",@"生日",@"会员"];
        }
    }
    return _titles;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    Weak(self);
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.equalTo(weakself);
        make.left.equalTo(weakself).mas_offset(10);
        make.height.mas_equalTo(40);
    }];
    [self.sperartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakself);
        make.top.equalTo(weakself.countLabel.mas_bottom);
        make.height.mas_equalTo(1.0);
    }];
    //对collectionView的布局进行特殊处理
    NSInteger collectionViewWidth=0.0;
    collectionViewWidth=((NSNumber *)[self.itemWidths valueForKeyPath:@"@sum.self"]).integerValue;
    NSInteger leftMegin=0.0;
    if (collectionViewWidth<ScreenWidth) {
        leftMegin=(ScreenWidth-collectionViewWidth)/2.0;
    }
    else {
        leftMegin=0.0;
    }
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.sperartLabel.mas_bottom);
        make.left.equalTo(weakself.mas_left).mas_offset(leftMegin);
        make.right.and.bottom.equalTo(weakself);
    }];
}

-(void)refreshBottomVieWithCount:(NSInteger)count roleType:(KKReserveType)roleType {
    self.roleType=roleType;
    Weak(self);
    if (roleType==KKDirectorReserve) {
        self.countLabel.text=[NSString stringWithFormat:@"今日主任总预约：%ld",count];
    }
    else {
        self.countLabel.text=[NSString stringWithFormat:@"今日治疗总预约：%ld",count];
    }
    NSInteger collectionViewWidth=0.0;
    collectionViewWidth=((NSNumber *)[self.itemWidths valueForKeyPath:@"@sum.self"]).integerValue;
    NSInteger leftMegin=0.0;
    if (collectionViewWidth<ScreenWidth) {
        leftMegin=(ScreenWidth-collectionViewWidth)/2.0;
    }
    else {
        leftMegin=10.0;
    }
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.sperartLabel.mas_bottom);
        make.left.equalTo(weakself.mas_left).mas_offset(leftMegin);
        make.right.and.bottom.equalTo(weakself);
    }];
}

#pragma mark - CollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString  *title=self.titles[indexPath.row];
    KKReservedBottomCell *cell=[KKReservedBottomCell collectionView:collectionView cllId:KKReservedBottomCellName indexPath:indexPath title:title];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.titles.count==0) {
        return CGSizeZero;
    }
    NSNumber *titleWidth=self.itemWidths[indexPath.row];
    if (self.roleType==KKDirectorReserve) {
        return CGSizeMake(titleWidth.floatValue, 45);
    }
    else {
        return CGSizeMake(titleWidth.floatValue, 45);
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
@end

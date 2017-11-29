//
//  MSSCalendarViewController.m
//  MSSCalendar
//
//  Created by sq580 on 16/4/4.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import "MSSCalendarViewController.h"
#import "MSSCalendarCollectionViewCell.h"
#import "MSSCalendarHeaderModel.h"
#import "MSSCalendarManager.h"
#import "MSSCalendarCollectionReusableView.h"
#import "MSSCalendarDefine.h"
#import "MSSCalendarWeekView.h"
#import "MSSCalendarTitView.h"
#import "MSSCalendarWeekView.h"
#import "MSSCalendarYearMonthView.h"
#import "MSSCalendarHeaderModel.h"
#import "Global.h"

@interface MSSCalendarViewController ()
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataArray;//月的数据源
@property (nonatomic,strong)NSMutableArray *yearDataArray;//年的数据源
@property (assign)WeekHeaderType timeType;
@property (nonatomic,strong)MSSCalendarTitView *titView;
@property (nonatomic,strong)NSIndexPath *yearStartIndex;
@property (nonatomic,strong)NSIndexPath *monthStartIndex;
@property (nonatomic,strong)NSCalendar *calendar;
@property (nonatomic,strong) MSSCalendarWeekView *weekView;
@end

@implementation MSSCalendarViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _afterTodayCanTouch = YES;
        _beforeTodayCanTouch = YES;
        _dataArray = [[NSMutableArray alloc]initWithCapacity:30];
        _yearDataArray=[NSMutableArray arrayWithCapacity:3];
        _calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        _showChineseCalendar = NO;
        _showChineseHoliday = NO;
        _showHolidayDifferentColor = NO;
        _showAlertView = NO;
        _timeType=KKYearType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initDataSource];
    [self createUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)initDataSource
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MSSCalendarManager *manager = [[MSSCalendarManager alloc]initWithShowChineseHoliday:_showChineseHoliday showChineseCalendar:_showChineseCalendar];
        NSArray *tempDataArray = [manager getCalendarDataSoruceWithLimitMonth:_limitMonth type:_type];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dataArray addObjectsFromArray:tempDataArray];
            [self addDataWithArray:[_dataArray copy]];
            [self showYearStartIndexPath:_yearStartIndex];
            //[self showCollectionViewWithStartIndexPath:manager.startIndexPath];
        });
    });
}

-(void)addDataWithArray:(NSArray *)array {
    NSDateComponents *todayCompontents=[_calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    //按年区分日历总共的分区数
    NSInteger allCount=0;
    for (MSSCalendarHeaderModel *yearCalendarModel in _dataArray) {
        NSPredicate *pre=[NSPredicate predicateWithFormat:@"year=%d",yearCalendarModel.year];
        NSArray *tempArray=[_yearDataArray filteredArrayUsingPredicate:pre];
        if (tempArray==nil||tempArray.count==0) {
            MSSYearModel *yearModel=[[MSSYearModel alloc]init];
            [yearModel.months addObject:yearCalendarModel];
            yearModel.year=yearCalendarModel.year;
            [_yearDataArray addObject:yearModel];
            if (todayCompontents.year==yearCalendarModel.year) {
                _yearStartIndex=[NSIndexPath indexPathForRow:0 inSection:allCount];
            }
            allCount=allCount+1;
        }
        else {
            MSSYearModel *model=[tempArray lastObject];
            NSInteger index=[_yearDataArray indexOfObject:model];
            [model.months addObject:yearCalendarModel];
            [_yearDataArray replaceObjectAtIndex:index withObject:model];
        }
    }
    
}

- (NSDateComponents *)dateToComponents:(NSDate *)date
{
    NSDateComponents *components = [_calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    return components;
}

-(void)showYearStartIndexPath:(NSIndexPath *)index {
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    _collectionView.contentOffset = CGPointMake(0, _collectionView.contentOffset.y - 84);
}

- (void)showCollectionViewWithStartIndexPath:(NSIndexPath *)startIndexPath
{
    [_collectionView reloadData];
    // 滚动到上次选中的位置
    if(startIndexPath)
    {
        if (self.timeType==KKYearType) {
            
        }
        else {
            [_collectionView scrollToItemAtIndexPath:startIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            MSSCalendarHeaderModel *model=self.dataArray[startIndexPath.section];
            self.titView.timeLabel.text=model.headerText;
            _collectionView.contentOffset = CGPointMake(0, _collectionView.contentOffset.y - 84);
        }
    }
    else
    {
        if(_type == MSSCalendarViewControllerLastType)
        {
            if([_dataArray count] > 0)
            {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_dataArray.count - 1] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            }
        }
        else if(_type == MSSCalendarViewControllerMiddleType)
        {
            if([_dataArray count] > 0)
            {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(_dataArray.count - 1) / 2] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                _collectionView.contentOffset = CGPointMake(0, _collectionView.contentOffset.y - MSS_HeaderViewHeight);
            }
        }
    }
}

- (void)createUI
{
    NSInteger width = MSS_Iphone6Scale(54)-1;
    //NSInteger height = MSS_Iphone6Scale(60);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, width * 7+7, MSS_SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //创建头部的view
    Weak(self);
   self.weekView=[[MSSCalendarWeekView alloc]initWithFrame:CGRectMake(0, 64, MSS_SCREEN_WIDTH, MSS_WeekViewHeight) haaderType:KKMonthType];
    self.titView=[[MSSCalendarTitView alloc]initWithFrame:CGRectMake(0, 0, MSS_SCREEN_WIDTH, 64) segmentBlock:^(NSInteger index) {
        [weakself setViewWithIndex:index];
        [weakself.collectionView reloadData];
    }];
    weakself.titView.timeLabel.hidden=YES;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.weekView];
    [self.view addSubview:self.titView];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[MSSCalendarCollectionViewCell class] forCellWithReuseIdentifier:@"MSSCalendarCollectionViewCell"];
    [_collectionView registerClass:[MSSCalendarCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MSSCalendarCollectionReusableView"];
    [_collectionView registerClass:[MSSCalendarYearCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MSSCalendarYearCollectionReusableView"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"defultCell"];
}

-(void)setViewWithIndex:(NSInteger) index {
    NSInteger width = MSS_Iphone6Scale(54)-1;
    if (index==0) {
        self.timeType=KKMonthType;
        self.weekView.hidden=NO;
        self.titView.timeLabel.hidden=NO;
#warning 这里修改背景色
        self.collectionView.backgroundColor=[UIColor whiteColor];
        [self.collectionView setFrame:CGRectMake(0, 64 + MSS_WeekViewHeight, width * 7+7, MSS_SCREEN_HEIGHT - 64 - MSS_WeekViewHeight)];
         [self getMonthStartIndex];
    }
    else {
        self.timeType=KKYearType;
        self.weekView.hidden=YES;
        self.titView.timeLabel.hidden=YES;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView setFrame:CGRectMake(0, 64 , width * 7+7, MSS_SCREEN_HEIGHT - 64)];
        
    }
}

-(void)getMonthStartIndex {
        time_t time_T;
        time_T = time(NULL);
        // tm对象格式的时间
        struct tm *tmTime;
        tmTime = localtime(&time_T);
        printf("Now Time is: %d:%d:%d\n", (*tmTime).tm_hour, (*tmTime).tm_min, (*tmTime).tm_sec);
        char* format = "%Y年%m月";
        char strTime[100];
        strftime(strTime, sizeof(strTime), format, tmTime);
        NSString *ocTime=[NSString stringWithCString:strTime encoding:NSUTF8StringEncoding];
       NSPredicate* predicate = [NSPredicate predicateWithFormat:@"headerText==%@",ocTime];
       NSArray *selectedArray=[self.dataArray filteredArrayUsingPredicate:predicate];
      if (selectedArray.count>0) {
          self.monthStartIndex=[NSIndexPath indexPathForRow:0 inSection:[self.dataArray indexOfObject:[selectedArray lastObject]]];
       [self showCollectionViewWithStartIndexPath:self.monthStartIndex];
      }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.timeType==KKYearType) {
        return _yearDataArray.count;
    }
    else {
        return [_dataArray count];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.timeType==KKYearType) {
        MSSYearModel *yearModel=_yearDataArray[section];
        return yearModel.months.count;
    }
    else {
        MSSCalendarHeaderModel *headerItem = _dataArray[section];
        return headerItem.calendarItemArray.count%7?headerItem.calendarItemArray.count+7-headerItem.calendarItemArray.count%7:headerItem.calendarItemArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.timeType==KKYearType) {
        MSSYearModel *yearModel=_yearDataArray[indexPath.section];
        MSSCalendarHeaderModel *headerModel=yearModel.months[indexPath.row];
        UICollectionViewCell *defaultCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"defultCell" forIndexPath:indexPath];
        MSSCalendarYearMonthView *yearMonthView=[defaultCell.contentView viewWithTag:1];
        if (yearMonthView==nil) {
            NSInteger width=((ScreenWidth-240)/3)/7;
            yearMonthView=[[MSSCalendarYearMonthView alloc]initWithFrame:CGRectMake(0, 0, (ScreenWidth-240)/3, width*6+50) model:headerModel];
            yearMonthView.tag=1;
            [defaultCell.contentView addSubview:yearMonthView];
        }
        else {
            [yearMonthView refreshWeekViewWithModel:headerModel];
        }
        defaultCell.contentView.backgroundColor=[UIColor whiteColor];
        return defaultCell;
    }
    else {
        MSSCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSSCalendarCollectionViewCell" forIndexPath:indexPath];
        MSSCalendarHeaderModel *headerItem = _dataArray[indexPath.section];
        cell.dateLabel.text = @"";
        cell.dateLabel.textColor = MSS_TextColor;
        cell.subLabel.text = @"";
        cell.subLabel.textColor = MSS_SelectSubLabelTextColor;
        cell.isToday = NO;
        cell.userInteractionEnabled = NO;
        cell.contentView.backgroundColor=[UIColor whiteColor];
        if (indexPath.row<headerItem.calendarItemArray.count) {
            MSSCalendarModel *calendarItem = headerItem.calendarItemArray[indexPath.row];
            if(calendarItem.day > 0)
            {
                if (calendarItem.type==MSSCalendarTodayType) {
                    cell.isToday=YES;
                    cell.dateLabel.textColor = [UIColor whiteColor];
                }
                else {
                    if(calendarItem.week == 0 || calendarItem.week == 6)
                    {
                        cell.dateLabel.textColor = MSS_WeekEndTextColor;
                        cell.subLabel.textColor = MSS_WeekEndTextColor;
                    }
                    else {
                        cell.dateLabel.textColor=MSS_WeekMainTextColor;
                    }
                }
                cell.dateLabel.text = [NSString stringWithFormat:@"%ld",(long)calendarItem.day];
                cell.userInteractionEnabled = YES;
                
            }
        }
        if (indexPath.row%7==0||indexPath.row%7==6) {
            cell.contentView.backgroundColor=MSS_WeeKBackGroundColor;
        }
        else {
            cell.contentView.backgroundColor=[UIColor whiteColor];
        }
        return cell;
    }
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (self.timeType==KKYearType) {
        MSSCalendarYearCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MSSCalendarYearCollectionReusableView" forIndexPath:indexPath];
        MSSYearModel *headerItem = _yearDataArray[indexPath.section];
        headerView.yearModel=headerItem;
        return headerView;
    }
    else {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            MSSCalendarCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"MSSCalendarCollectionReusableView" forIndexPath:indexPath];
            headerView.headerLabel.text=@"";
            return headerView;
        }
        return nil;
    }
}

//不选择
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

//高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

//不高亮
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.timeType==KKYearType) {
        //一个单元格的宽度
        NSInteger width=((ScreenWidth-240)/3)/7;
        return CGSizeMake((ScreenWidth-240)/3, width*6+50);
    }
    else {
        //NSInteger width = MSS_Iphone6Scale(54)-1;
        NSInteger width=(ScreenWidth)/7.0;
        NSInteger height = MSS_Iphone6Scale(60);
        return CGSizeMake(width, height);
    }
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.timeType==KKYearType) {
        return UIEdgeInsetsMake(20, 80, 10, 80);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (self.timeType==KKYearType) {
        return 40;
    }
    return 1.0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.timeType==KKYearType) {
        return CGSizeMake(MSS_SCREEN_WIDTH, 50);
    }
    return  CGSizeMake(MSS_SCREEN_WIDTH, 1);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexSection:%ld,indexRow:%ld",indexPath.section,indexPath.row);
    if (self.timeType==KKYearType) {
        self.timeType=KKMonthType;
        self.titView.segment.selectedSegmentIndex=0;
        MSSYearModel *yearModel=self.yearDataArray[indexPath.section];
        MSSCalendarHeaderModel *model=yearModel.months[indexPath.row];
        NSInteger index=[self.dataArray indexOfObject:model];
        [self setViewWithIndex:0];
        self.monthStartIndex=[NSIndexPath indexPathForRow:0 inSection:index];
        [self showCollectionViewWithStartIndexPath:self.monthStartIndex];
        [_collectionView reloadData];
    }
    else {
        MSSCalendarHeaderModel* headerItem = _dataArray[indexPath.section];
        MSSCalendarModel* calendaItem = headerItem.calendarItemArray[indexPath.row];
        NSLog(@"calendaItem:year:%ld,month:%ld,day:%ld",calendaItem.year,calendaItem.month,calendaItem.day);
        if (self.selectTimeBlock) {
            self.selectTimeBlock(calendaItem);
        }
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.timeType==KKMonthType) {
        Weak(self);
        NSArray *array=[self.collectionView visibleCells];
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithCapacity:3];
        for (MSSCalendarCollectionViewCell *cell in array) {
            NSIndexPath *indexPath=[self.collectionView indexPathForCell:cell];
            NSNumber *num=[dict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
            if (num==nil) {
                num=@1;
                [dict setObject:num forKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
            }
            else {
                num=@(num.integerValue+1);
                [dict setObject:num forKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
            }
        }
        NSArray *tempArray=dict.allValues;
        NSNumber *maxNum=[tempArray valueForKeyPath:@"@max.self"];
        __block MSSCalendarHeaderModel *maxModel=nil;
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (((NSNumber *)obj).integerValue==maxNum.integerValue) {
                maxModel=weakself.dataArray[((NSNumber *)key).integerValue];
                weakself.titView.timeLabel.text=maxModel.headerText;
                *stop=YES;
            }
        }];
        
        
    }


}

@end

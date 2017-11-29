//
//  ViewController.m
//  MSSCalendar
//
//  Created by 于威 on 16/4/3.
//  Copyright © 2016年 于威. All rights reserved.
//

#import "ViewController.h"
#import "MSSCalendarViewController.h"
#import "MSSCalendarDefine.h"
#import "MSSCalendarManager.h"
#import "NSDate+KKExtension.h"
#import "KKReservedTimeView.h"
#import "KKReserveTitleView.h"
#import "KKReservedBottomView.h"
#import "Global.h"
#define itemWidth (ScreenWidth-221)/7.0

@interface ViewController ()<MSSCalendarViewControllerDelegate>
@property (nonatomic,strong)UILabel *startLabel;
@property (nonatomic,strong)UILabel *endLabel;
@property (nonatomic,assign)NSInteger startDate;
@property (nonatomic,assign)NSInteger endDate;
@property (strong,nonatomic) KKReservedTimeView *ssview;
@property (assign)NSInteger offsetX;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.ssview.collectionView setContentOffset:CGPointMake(934, 0)];
}
- (void)createUI
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((MSS_SCREEN_WIDTH - 110) / 2, 80, 110, 50);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    btn.layer.cornerRadius = 5.0f;
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [btn setTitle:@"打开日历" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(calendarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _startLabel = [[UILabel alloc]init];
    _startLabel.backgroundColor = MSS_TodayBackgroundColor;
    _startLabel.textColor = MSS_SelectTextColor;
    _startLabel.textAlignment = NSTextAlignmentCenter;
    _startLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _startLabel.frame = CGRectMake(20, CGRectGetMaxY(btn.frame) + 20, MSS_SCREEN_WIDTH - 20 * 2, 50);
    _startLabel.text = @"开始日期";
    [self.view addSubview:_startLabel];
    
    _endLabel = [[UILabel alloc]init];
    _endLabel.backgroundColor = MSS_TodayBackgroundColor;
    _endLabel.textColor = MSS_SelectTextColor;
    _endLabel.textAlignment = NSTextAlignmentCenter;
    _endLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _endLabel.frame = CGRectMake(20, CGRectGetMaxY(_startLabel.frame) + 20, MSS_SCREEN_WIDTH - 20 * 2, 50);
    _endLabel.text = @"开始日期";
    _endLabel.text = @"结束日期";
    UIButton *testButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setFrame:CGRectMake(self.view.center.x-50, self.view.bounds.size.height-300, 100, 100)];
    [testButton addTarget:self action:@selector(onTestAction:) forControlEvents:UIControlEventTouchUpInside];
    testButton.backgroundColor=[UIColor redColor];
    [testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [testButton setTitle:@"测试" forState:UIControlStateNormal];
    [self.view addSubview:testButton];
    [self.view addSubview:_endLabel];
    
    NSDate *date=[NSDate date];
    NSDateComponents *dateComponents=[[MSSCalendarManager sharedManager]dateToComponents:date];
    MSSCalendarModel *calendarItem = [[MSSCalendarModel alloc]init];
    calendarItem.year = dateComponents.year;
    calendarItem.month = dateComponents.month;
    calendarItem.day = dateComponents.day;
    calendarItem.week = dateComponents.weekday-1;
    NSArray *beforeDates=[[MSSCalendarManager sharedManager]getDateModelsWithInterval:-15 date:date];
   NSArray *nextDates=[[MSSCalendarManager sharedManager]getDateModelsWithInterval:+15 date:date];
    NSMutableArray *monthDates=[NSMutableArray arrayWithCapacity:31];
    [monthDates addObjectsFromArray:beforeDates];
    [monthDates addObject:calendarItem];
    [monthDates addObjectsFromArray:nextDates];
    self.ssview=[[KKReservedTimeView alloc]initWithFrame:CGRectMake(0, 300, ScreenWidth, 45) dates:monthDates selectedModel:calendarItem];
    [self.view addSubview:self.ssview];
    NSInteger index=[monthDates indexOfObject:calendarItem];
    if (index>6) {
        self.offsetX=((index-6)+3)*itemWidth;
    }
    //titleView新建
    KKReserveTitleView *titleView=[[KKReserveTitleView alloc]initWithFrame:CGRectMake(0, 345, ScreenWidth, 45) style:KKTreatReserve clickButtonBlock:^(UIButton *button) {
        
    }];
    [self.view addSubview:titleView];
    //主任titleView新建
    KKReserveTitleView *titleView1=[[KKReserveTitleView alloc]initWithFrame:CGRectMake(0, 390, ScreenWidth, 45) style:KKDirectorReserve clickButtonBlock:^(UIButton *button) {
        
    }];
    [self.view addSubview:titleView1];
    
    KKReservedBottomView *bottomView=[[KKReservedBottomView alloc]initWithFrame:CGRectMake(0, 435, ScreenWidth, 81) roleType:KKDirectorReserve];
    [self.view addSubview:bottomView];
}

-(void)onTestAction:(id)sender {
}

- (void)calendarClick:(UIButton *)btn
{
    __weak ViewController *weakSelf=self;
    MSSCalendarViewController *cvc = [[MSSCalendarViewController alloc]init];
    cvc.limitMonth = 12 * 3;// 显示几个月的日历
    /*
     MSSCalendarViewControllerLastType 只显示当前月之前
     MSSCalendarViewControllerMiddleType 前后各显示一半
     MSSCalendarViewControllerNextType 只显示当前月之后
     */
    cvc.type = MSSCalendarViewControllerLastType;
    cvc.beforeTodayCanTouch = YES;// 今天之后的日期是否可以点击
    cvc.afterTodayCanTouch = YES;// 今天之前的日期是否可以点击
    /*以下两个属性设为YES,计算中国农历非常耗性能（在5s加载15年以内的数据没有影响）*/
    cvc.showChineseHoliday = NO;// 是否展示农历节日
    cvc.showChineseCalendar = NO;// 是否展示农历
    cvc.showHolidayDifferentColor = YES;// 节假日是否显示不同的颜色
    cvc.showAlertView = YES;// 是否显示提示弹窗
    cvc.delegate = self;
    cvc.selectTimeBlock = ^(MSSCalendarModel *model) {
        [weakSelf getMonthDaysWithModel:model];
    };
    [self presentViewController:cvc animated:YES completion:nil];
}

-(void)getMonthDaysWithModel:(MSSCalendarModel *)model {
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:model.dateInterval+28800];
    NSArray *nextDates=[[MSSCalendarManager sharedManager]getDateModelsWithInterval:15 date:date];
    NSArray *beforeDates=[[MSSCalendarManager sharedManager]getDateModelsWithInterval:-15 date:date];
    model.select=YES;
    NSMutableArray *monthDates=[NSMutableArray arrayWithCapacity:31];
    [monthDates addObjectsFromArray:beforeDates];
    [monthDates addObject:model];
    [monthDates addObjectsFromArray:nextDates];
    NSInteger index=[monthDates indexOfObject:model];
    [self.ssview refreshClvWithDates:monthDates selectedModel:model];
    if (index>6) {
        self.offsetX=((index-6)+3)*itemWidth;
    }
    [self.ssview.collectionView setContentOffset:CGPointMake(self.offsetX, 0)];
    
}

- (void)calendarViewConfirmClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate
{
    _startDate = startDate;
    _endDate = endDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_startDate]];
    NSString *endDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_endDate]];
    _startLabel.text = [NSString stringWithFormat:@"开始日期:%@",startDateString];
    _endLabel.text = [NSString stringWithFormat:@"结束日期:%@",endDateString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

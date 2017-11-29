//
//  ReservedTimeView.h
//  MSSCalendar
//
//  Created by kkmac on 2017/10/21.
//  Copyright © 2017年 kkmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSCalendarHeaderModel.h"


@interface KKReservedTimeView : UIView
@property(nonatomic,strong)UICollectionView *collectionView;
/**
 预约界面时间界面
 @param frame 当前view的frame
 @param dates 选中时间的前后的一段数据集
 @param model 选中时间的model
 @return 返回预约Header
 */
-(instancetype)initWithFrame:(CGRect)frame dates:(NSArray *)dates selectedModel:(MSSCalendarModel *)model;

/**
 刷新数据的方法
 @param dates 时间的数据集
 @param model 当前的对象
 */
-(void)refreshClvWithDates:(NSArray *)dates selectedModel:(MSSCalendarModel *)model;
@end

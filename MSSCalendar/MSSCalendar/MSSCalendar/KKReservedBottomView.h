//
//  KKReservedBottomView.h
//  ReservedBottomViewDemo
//
//  Created by kkmac on 2017/10/25.
//  Copyright © 2017年 ReservedBottomViewDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKReserveTitleView.h"
@interface KKReservedBottomView : UIView

/**
 实例化预约底部的view
 @param frame 当前view的frame
 @param roleType 当前的类型
 @return 预约底部视图实例
 */
-(instancetype)initWithFrame:(CGRect)frame roleType:(KKReserveType )roleType;

/**
 刷新预约底部viw
 @param count 预约人数
 @param roleType 当前的类型
 */
-(void)refreshBottomVieWithCount:(NSInteger)count roleType:(KKReserveType )roleType;
@end

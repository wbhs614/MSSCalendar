//
//  KKReserveTitleView.h
//  MSSCalendar
//
//  Created by kkmac on 2017/10/24.
//  Copyright © 2017年 TitleViewDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KKReserveType) {
    KKDirectorReserve=0,//主任预约
    KKTreatReserve=1,//治疗预约
};
@interface KKReserveTitleView : UIView

/**
 返回titleView
 @param frame 当前的titView的frame
 @param block 点击按钮的回调
 @return 返回当前的TitleView
 */
-(instancetype)initWithFrame:(CGRect)frame style:(KKReserveType)type clickButtonBlock:(void(^)(UIButton *button))block;
@end

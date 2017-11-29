//
//  MSSCircleLabel.h
//  MSSCalendar
//
//  Created by sq580 on 16/4/8.
//  Copyright © 2016年 xincheng. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MSSCircleLabel : UILabel
@property (nonatomic,assign)BOOL isToday;
@property (nonatomic,strong)UIColor *bgColor;
@property (nonatomic,assign,getter=isSelected)BOOL selected;
@end

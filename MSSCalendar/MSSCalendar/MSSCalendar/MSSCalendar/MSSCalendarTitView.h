//
//  MSSCalendarTitView.h
//  MSSCalendar
//
//  Created by kkmac on 2017/8/19.
//  Copyright © 2017年 kkmac. All rights reserved.
//

#import <UIKit/UIKit.h>
/*主界面自定义的顶部*/
@interface MSSCalendarTitView : UIView
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UISegmentedControl *segment;
-(instancetype)initWithFrame:(CGRect)frame segmentBlock:(void(^)(NSInteger index))block;
@end

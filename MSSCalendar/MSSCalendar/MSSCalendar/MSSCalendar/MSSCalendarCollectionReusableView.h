//
//  MSSCalendarCollectionReusableView.h
//  MSSCalendar
//
//  Created by sq580 on 16/4/5.
//  Copyright © 2016年 xincheng. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MSSCalendarHeaderModel.h"
@interface MSSCalendarCollectionReusableView : UICollectionReusableView

@property (nonatomic,strong)UILabel *headerLabel;

@end

#pragma makk--MSSCalendarYearCollectionReusableView indterface
@interface MSSCalendarYearCollectionReusableView : UICollectionReusableView
@property(nonatomic,strong)MSSYearModel *yearModel;


@end

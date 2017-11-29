//
//  MSSCalendarCollectionViewCell.h
//  MSSCalendar
//
//  Created by sq580 on 16/4/4.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSCircleLabel.h"

@interface MSSCalendarCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)MSSCircleLabel *dateLabel;
@property (nonatomic,strong)UILabel *subLabel;
@property (nonatomic,assign)BOOL isToday;

@end

//
//  KKReserverViewCell.h
//  MSSCalendar
//
//  Created by kkmac on 2017/10/23.
//  Copyright © 2017年 于威. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSCalendarHeaderModel.h"
@interface KKReserverViewCell : UICollectionViewCell
+(KKReserverViewCell *)collectionView:(UICollectionView *)clvView cellId:(NSString *)cellId indexPath:(NSIndexPath *)indexPath model:(MSSCalendarModel *)model;
@end

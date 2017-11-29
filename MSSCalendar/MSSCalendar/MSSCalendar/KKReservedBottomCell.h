//
//  KKReservedBottomCell.h
//  ReservedBottomViewDemo
//
//  Created by kkmac on 2017/10/25.
//  Copyright © 2017年 ReservedBottomViewDemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKReservedBottomCell : UICollectionViewCell
+(KKReservedBottomCell *)collectionView:(UICollectionView *)clvView cllId:(NSString *)cellId indexPath:(NSIndexPath *)indexPath title:(NSString *)title;
@end

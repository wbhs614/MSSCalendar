//
//  MSSCircleLabel.m
//  MSSCalendar
//
//  Created by sq580 on 16/4/8.
//  Copyright © 2016年 xincheng. All rights reserved.
//

#import "MSSCircleLabel.h"
#import "MSSCalendarDefine.h"
@implementation MSSCircleLabel

- (void)drawRect:(CGRect)rect
{
    if(_isToday)
    {
        [MSS_TodayBackgroundColor setFill];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.height / 2 startAngle:0.0 endAngle:180.0 clockwise:YES];
        [path fill];
    }
    else {
        if (_selected) {
            [MSS_SelectBackgroundColor setFill];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path addArcWithCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:self.frame.size.height / 2 startAngle:0.0 endAngle:180.0 clockwise:YES];
            [path fill];
        }
    }
    [super drawRect:rect];
}

-(void)setIsToday:(BOOL)isToday {
    _isToday=isToday;
    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)selected {
    _selected=selected;
    [self setNeedsDisplay];
}
@end

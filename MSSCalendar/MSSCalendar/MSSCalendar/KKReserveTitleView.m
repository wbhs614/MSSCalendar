//
//  KKReserveTitleView.m
//  MSSCalendar
//
//  Created by kkmac on 2017/10/24.
//  Copyright © 2017年 TitleViewDemo. All rights reserved.
//

#import "KKReserveTitleView.h"
#import "NSString+KKExtension.h"
#import <Masonry.h>
#import "Global.h"
@interface KKReserveTitleView ()
@property(nonatomic,strong)NSArray *titles;
@property(copy,nonatomic)void(^clickButtonBlock)(UIButton *button);
@property(strong,nonatomic)NSMutableArray *buttonArray;
@property(assign,nonatomic)KKReserveType roleType;
@end

@implementation KKReserveTitleView

-(NSArray *)titles {
    if (!_titles) {
        if (self.roleType==KKTreatReserve) {
          _titles=@[@"",@"序号",@"院区",@"科室",@"姓名",@"卡号",@"门诊医生",@"预约项目",@"预约医生",@"预约时间",@"顾客状态"];
        }
        else {
         _titles=@[@"",@"序号",@"院区",@"部门",@"开发员",@"姓名",@"卡号",@"年龄",@"预约项目",@"预约时间",@"顾客状态"];
        }
    }
    return _titles;
}

-(instancetype)initWithFrame:(CGRect)frame style:(KKReserveType)type clickButtonBlock:(void(^)(UIButton *button))block {
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=RGBA(195, 195, 195, 0.5);
        self.clickButtonBlock =block;
        self.roleType=type;
        if (type==KKDirectorReserve) {
            [self setupDirectView];
        }
        else {
            [self setupTreatView];
        }
    }
    return self;
}

-(void)setupTreatView {
    Weak(self);
    //逆序创建button
    self.buttonArray=[NSMutableArray arrayWithCapacity:12];
    for (NSInteger i=self.titles.count-1;i<self.titles.count;i--) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=i+1;
        NSString *title=self.titles[i];
        button.titleLabel.font=[UIFont boldSystemFontOfSize:15.0];
        [button setTitleColor:RGBA(50, 50, 50, 1.0) forState:UIControlStateNormal];
        button.backgroundColor=RGBA(234, 243, 239, 1.0);
        [button addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:title forState:UIControlStateNormal];
        [self.buttonArray addObject:button];
        if (i!=0&&i!=1&&i!=4&&i!=5) {
            NSString *content = button.titleLabel.text;
            UIFont *font = button.titleLabel.font;
            CGSize size = CGSizeMake(MAXFLOAT, 30.0f);
            CGSize buttonSize = [content boundingSizeWithFont:font maxBoundingSize:size];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 10 + 2)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, buttonSize.width + 2, 0.0, -buttonSize.width)];
            [button setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
        }
        NSLog(@"imageWidth:%f",CGRectGetWidth(button.titleLabel.frame));
        [self addSubview:button];
        if (i==self.titles.count-1){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakself).mas_offset(1);
                make.bottom.equalTo(weakself).mas_offset(-1);
                make.right.equalTo(weakself);
            }];
        }
        else if (i==0) {
            UIButton *nextButton=self.buttonArray[self.titles.count-i-2];
            //界面上面的最后一个按钮就是数据组里面的第一个
            UIButton *lastButton=[self.buttonArray firstObject];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakself);
                make.top.equalTo(weakself).mas_offset(1);
                make.bottom.equalTo(weakself).mas_offset(-1);
                make.right.equalTo(nextButton.mas_left);
                make.width.equalTo(lastButton.mas_width).multipliedBy(0.5);
            }];
        }
        else if (i>5&&i<self.titles.count-1){
            UIButton *nextButton=self.buttonArray[self.titles.count-i-2];
            UIButton *lastButton=[self.buttonArray firstObject];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakself).mas_offset(1);
                make.bottom.equalTo(weakself).mas_offset(-1);
                make.right.equalTo(nextButton.mas_left).mas_offset(-1);
                make.width.equalTo(lastButton.mas_width);
            }];
            
        }
        else {
            UIButton *nextButton=self.buttonArray[self.titles.count-i-2];
            UIButton *lastButton=[self.buttonArray firstObject];
            if (i==4||i==5) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakself).mas_offset(1);
                    make.bottom.equalTo(weakself).mas_offset(-1);
                    make.right.equalTo(nextButton.mas_left).mas_offset(-1);
                    make.width.equalTo(lastButton.mas_width).multipliedBy(0.75);
                }];
            }
            else if (i==2||i==3) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakself).mas_offset(1);
                    make.bottom.equalTo(weakself).mas_offset(-1);
                    make.right.equalTo(nextButton.mas_left).mas_offset(-1);
                    make.width.equalTo(lastButton.mas_width).multipliedBy(0.75);
                }];
            }
            else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakself).mas_offset(1);
                    make.bottom.equalTo(weakself).mas_offset(-1);
                    make.right.equalTo(nextButton.mas_left).mas_offset(-1);
                    make.width.equalTo(lastButton.mas_width).multipliedBy(0.5);
                }];
            }
        }
    }
}

-(void)onClickButton:(UIButton *)sender {
    self.clickButtonBlock(sender);
}

-(void)setupDirectView {
    Weak(self);
    //逆序创建button
    self.buttonArray=[NSMutableArray arrayWithCapacity:12];
    for (NSInteger i=self.titles.count-1;i<self.titles.count;i--) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=i+1;
        NSString *title=self.titles[i];
        button.titleLabel.font=[UIFont boldSystemFontOfSize:15.0];
        [button setTitleColor:RGBA(50, 50, 50, 1.0) forState:UIControlStateNormal];
        button.backgroundColor=RGBA(234, 243, 239, 1.0);
        [button addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:title forState:UIControlStateNormal];
        [self.buttonArray addObject:button];
        if (i!=0&&i!=1&&i!=5&&i!=6&&i!=7) {
            NSString *content = button.titleLabel.text;
            UIFont *font = button.titleLabel.font;
            CGSize size = CGSizeMake(MAXFLOAT, 30.0f);
            CGSize buttonSize = [content boundingSizeWithFont:font maxBoundingSize:size];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 10 + 2)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, buttonSize.width + 2, 0.0, -buttonSize.width)];
            [button setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
        }
        NSLog(@"imageWidth:%f",CGRectGetWidth(button.titleLabel.frame));
        [self addSubview:button];
        if (i==self.titles.count-1){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakself).mas_offset(1);
                make.bottom.equalTo(weakself).mas_offset(-1);
                make.right.equalTo(weakself);
            }];
        }
        else if (i==0) {
            UIButton *nextButton=self.buttonArray[self.titles.count-i-2];
            //界面上面的最后一个按钮就是数据组里面的第一个
            UIButton *lastButton=[self.buttonArray firstObject];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakself);
                make.top.equalTo(weakself).mas_offset(1);
                make.bottom.equalTo(weakself).mas_offset(-1);
                make.right.equalTo(nextButton.mas_left);
                make.width.equalTo(lastButton.mas_width).multipliedBy(0.5);
            }];
        }
        else if (i>7&&i<self.titles.count-1){
            UIButton *nextButton=self.buttonArray[self.titles.count-i-2];
            UIButton *lastButton=[self.buttonArray firstObject];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakself).mas_offset(1);
                make.bottom.equalTo(weakself).mas_offset(-1);
                make.right.equalTo(nextButton.mas_left).mas_offset(-1);
                make.width.equalTo(lastButton.mas_width);
            }];
            
        }
        else {
            UIButton *nextButton=self.buttonArray[self.titles.count-i-2];
            UIButton *lastButton=[self.buttonArray firstObject];
            if (i==7) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakself).mas_offset(1);
                    make.bottom.equalTo(weakself).mas_offset(-1);
                    make.right.equalTo(nextButton.mas_left).mas_offset(-1);
                    make.width.equalTo(lastButton.mas_width).multipliedBy(0.35);
                }];
            }
            if (i==4||i==6) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakself).mas_offset(1);
                    make.bottom.equalTo(weakself).mas_offset(-1);
                    make.right.equalTo(nextButton.mas_left).mas_offset(-1);
                    make.width.equalTo(lastButton.mas_width).multipliedBy(0.75);
                }];
            }
            else if (i==5||i==3||i==2) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakself).mas_offset(1);
                    make.bottom.equalTo(weakself).mas_offset(-1);
                    make.right.equalTo(nextButton.mas_left).mas_offset(-1);
                    make.width.equalTo(lastButton.mas_width).multipliedBy(0.66);
                }];
            }
            else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakself).mas_offset(1);
                    make.bottom.equalTo(weakself).mas_offset(-1);
                    make.right.equalTo(nextButton.mas_left).mas_offset(-1);
                    make.width.equalTo(lastButton.mas_width).multipliedBy(0.35);
                }];
            }
        }
    }
}


@end


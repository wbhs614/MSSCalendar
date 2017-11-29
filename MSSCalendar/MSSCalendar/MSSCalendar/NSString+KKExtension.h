//
//  NSString+KKExtension.h
//  BeautifulAgent
//
//  Created by 吴灶洲 on 2017/3/31.
//  Copyright © 2017年 kkmac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (KKExtension)
/**
 竖排文字
 */
- (NSString *)verticalString;

/**
 设置文字的行间距
 @param space 行间距
 @return 返回NSMutableAttributeSting对象
 */
-(NSMutableAttributedString *)setStringLineSpace:(float)space;

/**
 计算文字的大小
 @param font 当前文字的大小
 @param maxBoundingSize 预计文字的size
 @return 返回文字的size
 */
- (CGSize)boundingSizeWithFont:(UIFont*)font maxBoundingSize:(CGSize)maxBoundingSize;

/**
 反转字符串
 
 @return 反转好的字符串
 */
- (NSString *)stringByReversed;

/**
 去除字符串中的空格和回车

 @param str 字符串
 @return 去除掉空格和回车的字符串
 */
+ (NSString *)removeSpaceAndNewline:(NSString *)str;

/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum;

/**
 字符串去掉空格
 @return 字符串去掉空格
 */
- (NSString*)trim;
//生成md5字符串
-(NSString *)md5String;

/**
 aes256加密
 @param key 加密字符串用的key
 @return 返回加密后的字符串
 */
-(NSString *)aes256_encrypt:(NSString *)key;

/**
 aes256解密
 @param key 解密字符串用的key
 @return 返回解密以后的字符串
 */
-(NSString *)aes256_decrypt:(NSString *)key;

/**
 去掉表情符号
 @param text 过滤表情符号
 @return 不含表情符号的字符串
 */
- (NSString *)disableEmoji;
@end

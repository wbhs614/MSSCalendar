//
//  NSString+KKExtension.m
//  BeautifulAgent
//
//  Created by 吴灶洲 on 2017/3/31.
//  Copyright © 2017年 kkmac. All rights reserved.
//

#import "NSString+KKExtension.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonSymmetricKeywrap.h>
@implementation NSString (KKExtension)


/**
 竖排文字
 */
- (NSString *)verticalString {
    NSMutableString *str = [[NSMutableString alloc] initWithString:self];
    NSInteger count = str.length;
    for (int i=1; i<count; i++) {
        [str insertString:@"\n" atIndex:i*2-1];
    }
    return str;
}


/**
 设置文字的行间距
 @param space 行间距
 @return 返回NSMutableAttributeSting对象
 */
-(NSMutableAttributedString *)setStringLineSpace:(float)space {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];//设置行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    return attributedString;
}



/**
 计算文字的大小
 @param font 当前文字的大小
 @param maxBoundingSize 预计文字的size
 @return 返回文字的size
 */
- (CGSize)boundingSizeWithFont:(UIFont*)font maxBoundingSize:(CGSize)maxBoundingSize {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    return [self boundingRectWithSize:maxBoundingSize
                              options:NSStringDrawingTruncatesLastVisibleLine |
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading
                           attributes:attribute
                              context:nil].size;
}


/**
 反转字符串

 @return 反转好的字符串
 */
- (NSString *)stringByReversed{
    unsigned long len;
    len = [self length];
    unichar a[len];
    for(int i = 0; i < len; i++){
        unichar c = [self characterAtIndex:len-i-1];
        a[i] = c;
    }
    NSString *str1=[NSString stringWithCharacters:a length:len];
    return  str1;
}

/**
 去除字符串中的空格和回车
 
 @param str 字符串
 @return 去除掉空格和回车的字符串
 */
+ (NSString *)removeSpaceAndNewline:(NSString *)str{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }
    else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}


/**
 字符串去掉空格
 @return 字符串去掉空格
 */
- (NSString*)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


-(NSString *)md5String {
    //加盐
    NSString *newStr=[NSString stringWithFormat:@"%@%@%@",@"`¡£•ª¡£∞§•¶",self,@"≠–ºª•¶¶§¢¡™¢"];
    const char *cStr = [newStr UTF8String];
    unsigned char digest[16];
    unsigned int x=(int)strlen(cStr) ;
    CC_MD5( cStr, x, digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    NSLog(@"out:%@",output);
    //乱序
    NSString *prefix = [output substringFromIndex:2];
    NSString *subfix = [output substringToIndex:2];
    NSString *newString=[prefix stringByAppendingString:subfix];
    return  newString;
}

//对数据进行加密
-(NSString *)aes256_encrypt:(NSString *)key {
    const char *cChar=[self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data=[NSData dataWithBytes:cChar length:self.length];
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength=[data length];
    size_t bufferSize=dataLength+kCCKeySizeAES128;
    void *buffer=malloc(bufferSize);
    size_t numBytesEncrypted=0;
    CCCryptorStatus cryptStatus=CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding|kCCOptionECBMode, keyPtr, kCCKeySizeAES256, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesEncrypted);
    if (cryptStatus==kCCSuccess) {
        NSData *result=[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [result base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    else {
        return nil;
    }
}

//对数据进行解密
-(NSString *)aes256_decrypt:(NSString *)key {
    NSData *data=[[NSData alloc]initWithBase64EncodedData:[self dataUsingEncoding:NSASCIIStringEncoding] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength=[data length];
    size_t bufferSize=dataLength+kCCKeySizeAES256;
    void *buffer=malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus=CCCrypt(kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding|kCCOptionECBMode, keyPtr, kCCKeySizeAES256, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    if (cryptStatus==kCCSuccess) {
        NSData *result=[NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    else {
        return nil;
    }
}

//去掉表情符号
- (NSString *)disableEmoji
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:@""];
    return modifiedString;
}
@end

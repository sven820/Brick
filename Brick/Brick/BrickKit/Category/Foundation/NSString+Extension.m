//
//  NSString+YCF.m
//  MyYaoChuFaApp
//
//  Created by Hugo Xie on 14/12/12.
//  Copyright (c) 2014年 要出发. All rights reserved.
//

#import "NSString+Extension.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (Extension)

//double型转变为NSString,把double型小数点后面多余的0去掉
+(NSString *)changeDouble:(double)doubleNumber
{
    NSString *stringFloat = [NSString stringWithFormat:@"%.2f",doubleNumber];
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    NSInteger i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}

//CGFloat型转变为NSString,把CGFloat型小数点后面多余的0去掉
+(NSString *)changeFloat:(float)floatNumber
{
    NSString *stringFloat = [NSString stringWithFormat:@"%.2f",floatNumber];
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    NSInteger i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}

//检查字符串是否为空
+ (BOOL)checkIsEmptyOrNull:(NSString *) string
{
    if (string && ![string isEqual:[NSNull null]] && ![string isEqual:@"(null)"] && ![string isEqualToString:@"<null>"] && [string length] > 0)
    {
        return NO;
    }
    return YES;
}

// 检查是否是 http:// URL
+ (BOOL)checkIsHTTPURL:(NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    if (url != nil && [url.scheme isEqualToString:@"http"])
    {
        return YES;
    }
    return NO;
}

//得到中英文混合字符串长度  !!!中英文字符串
- (NSUInteger)getMixCharacterLength

{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    return [da length];
}

// 判断是否包含中文字符
- (BOOL)isContainChineseChar
{
    for (int i = 0; i < self.length; i++) {
        int ch = [self characterAtIndex:i];
        
        if (ch > 0x4e00 && ch < 0x9fff ) {
            return YES;
        }
    }
    return NO;
}
// 校验姓名字符
- (YCFNameStringCheckingStyle)checkForNameString
{
    if ([NSString checkIsEmptyOrNull:self])
    {
        return YCFNameStringCheckingEmptyOrNull;
    }
    else if([self getMixCharacterLength] < 4 ||
            [self getMixCharacterLength] > 20)
    {
        return YCFNameStringCheckingOverCharLimit;
    }
    else if([self rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound)
    {
        return YCFNameStringCheckingContainNum;
    }
    else if(![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(?!_)(?!.*?_$)[a-zA-Z\u4e00-\u9fa5]+$"] evaluateWithObject:self])
    {
        return YCFNameStringCheckingContainSpcicalChar;
    }
    
    return YCFNameStringCheckingLegal;
}

- (CGSize)sizeOfFont:(UIFont *)font
{
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : font}
                              context:nil].size;
}

-(BOOL)isWebURL
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",webUrlRegex];
    return [pre evaluateWithObject:self];
}

- (NSString *)showStrWithStarMiddle
{
    if (self.length <= 4) {
        return self;
    }
    NSMutableString *replaceStr = [NSMutableString string];
    for (int i = 0; i < self.length - 4; i++) {
        [replaceStr appendString:@"*"];
    }
    NSString *str = [self stringByReplacingCharactersInRange:NSMakeRange(2, self.length - 4) withString:replaceStr];

    return str;
}

// 校验是否是手机号
- (BOOL)checkIsPhoneNumber
{
    NSString *regex = @"^[0-9]{11}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [numberPre evaluateWithObject:self];
}
// 校验是否是省份证
- (BOOL)checkIsIdCard
{
    NSString *regex = @"^[a-zA-Z0-9]{18}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [numberPre evaluateWithObject:self];
}
// 校验是否是10-15位注册电话,可带'-'
- (BOOL)checkIsRegisterPhoneNumber
{
    NSString *regex = @"^[0-9-]{10,15}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [numberPre evaluateWithObject:self];
}

//生成随机字符串
+ (NSString *)createRandomString:(NSInteger)length
{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < length; i++)
    {
        int number = arc4random() % 36;
        if (number < 10)
        {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }
        else
        {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    
    return string;
}

- (NSString *)stringByURLEncoding
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,  (__bridge CFStringRef)self,  NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
#else
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
#endif
}

- (NSString *)stringByURLDecoding
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          (__bridge CFStringRef)self,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
#else
    return [self stringByRemovingPercentEncoding];
#endif
}

#pragma mark - XSS
-(BOOL)avoidXSSAtackWithURL:(NSString*)url
{
    if([self p_avoidXSSAtackWithSriptRex:url])
    {
        return NO;
    }
    if([self p_avoidXSSAtackWithEval:url])
    {
        return NO;
    }
    if([self p_avoidXSSAtackWithExec:url])
    {
        return NO;
    }
    if([self p_avoidXSSAtackWithimage:url])
    {
        return NO;
    }
    if([self p_avoidXSSAtackWithSimple:url])
    {
        return NO;
    }
    if([self p_avoidXSSAtackWithSQLInjection:url])
    {
        return NO;
    }
    return YES;
    
}

//检测sript
-(BOOL)p_avoidXSSAtackWithSriptRex:(NSString*)url
{
    NSString* scriptRegex = @"( \\s|\\S)*((%73)|s)(\\s)*((%63)|c)(\\s)*((%72)|r)(\\s)*((%69)|i)(\\s)*((%70)|p)(\\s)*((%74)|t)(\\s|\\S)*";
    
    NSPredicate *scriptTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",scriptRegex];
    return [scriptTest evaluateWithObject:url];
    
}

-(BOOL)p_avoidXSSAtackWithimage:(NSString *)url
{
    NSString* imageRegex = @"( \\s|\\S)*((%3C)|<)((%69)|i|I|(%49))((%6D)|m|M|(%4D))((%67)|g|G|(%47))[^\\n]+((%3E)|>)(\\s|\\S)*";
    
    NSPredicate *imageTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",imageRegex];
    return [imageTest evaluateWithObject:url];
    
}

-(BOOL)p_avoidXSSAtackWithSQLInjection:(NSString *)url
{
    NSString* SQLInjectionRegex = @"( \\s|\\S)*((%27)|(')|(%3D)|(=)|(/)|(%2F)|(\")|((%22)|(-|%2D){2})|(%23)|(%3B)|(;))+(\\s|\\S)*";
    
    NSPredicate *SQLInjectionTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",SQLInjectionRegex];
    return [SQLInjectionTest evaluateWithObject:url];
    
}

//xss攻击过滤---Eval
-(BOOL)p_avoidXSSAtackWithEval:(NSString *)url;
{
    NSString* evalRegex = @"( \\s|\\S)*((%65)|e)(\\s)*((%76)|v)(\\s)*((%61)|a)(\\s)*((%6C)|l)(\\s|\\S)*";
    
    NSPredicate *evalTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",evalRegex];
    return [evalTest evaluateWithObject:url];
    
}

//xss攻击过滤---Simple
-(BOOL)p_avoidXSSAtackWithSimple:(NSString *)url
{
    NSString* simpleRegex = @"( \\s|\\S)*((%3C)|<)((%2F)|/)*[a-z0-9%]+((%3E)|>)(\\s|\\S)*";
    
    NSPredicate *simpleTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",simpleRegex];
    return [simpleTest evaluateWithObject:url];
    
}

//xss攻击过滤---Exec
-(BOOL)p_avoidXSSAtackWithExec:(NSString *)url
{
    NSString* execRegex = @"( \\s|\\S)*(exec(\\s|\\+)+(s|x)p\\w+)(\\s|\\S)*";
    
    NSPredicate *execTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",execRegex];
    return [execTest evaluateWithObject:url];
    
}

// 安卓SDK正则表达式，匹配网络连接。
const static NSString *webUrlRegex =
    @"((?:(http|https|Http|Https|rtsp|Rtsp):\\/\\/(?:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)"
    @"\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,64}(?:\\:(?:[a-zA-Z0-9\\$\\-\\_"
    @"\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,25})?\\@)?)?"
    @"((?:(?:["
    @"a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF"
    @"]["
    @"a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF"
    @"\\-]{0,64}\\.)+"
    @"(?:"
    @"(?:aero|arpa|asia|a[cdefgilmnoqrstuwxz])"
    @"|(?:biz|b[abdefghijmnorstvwyz])"
    @"|(?:cat|com|coop|c[acdfghiklmnoruvxyz])"
    @"|d[ejkmoz]"
    @"|(?:edu|e[cegrstu])"
    @"|f[ijkmor]"
    @"|(?:gov|g[abdefghilmnpqrstuwy])"
    @"|h[kmnrtu]"
    @"|(?:info|int|i[delmnoqrst])"
    @"|(?:jobs|j[emop])"
    @"|k[eghimnprwyz]"
    @"|l[abcikrstuvy]"
    @"|(?:mil|mobi|museum|m[acdeghklmnopqrstuvwxyz])"
    @"|(?:name|net|n[acefgilopruz])"
    @"|(?:org|om)"
    @"|(?:pro|p[aefghklmnrstwy])"
    @"|qa"
    @"|r[eosuw]"
    @"|s[abcdeghijklmnortuvyz]"
    @"|(?:tel|travel|t[cdfghjklmnoprtvwz])"
    @"|u[agksyz]"
    @"|v[aceginu]"
    @"|w[fs]"
    @"|(?:\u03b4\u03bf\u03ba\u03b9\u03bc\u03ae|\u0438\u0441\u043f\u044b\u0442\u0430\u043d\u0438\u0435|\u0440\u0444|\u0441\u0440\u0431|\u05d8\u05e2\u05e1\u05d8|\u0622\u0632\u0645\u0627\u06cc\u0634\u06cc|\u0625\u062e\u062a\u0628\u0627\u0631|\u0627\u0644\u0627\u0631\u062f\u0646|\u0627\u0644\u062c\u0632\u0627\u0626\u0631|\u0627\u0644\u0633\u0639\u0648\u062f\u064a\u0629|\u0627\u0644\u0645\u063a\u0631\u0628|\u0627\u0645\u0627\u0631\u0627\u062a|\u0628\u06be\u0627\u0631\u062a|\u062a\u0648\u0646\u0633|\u0633\u0648\u0631\u064a\u0629|\u0641\u0644\u0633\u0637\u064a\u0646|\u0642\u0637\u0631|\u0645\u0635\u0631|\u092a\u0930\u0940\u0915\u094d\u0937\u093e|\u092d\u093e\u0930\u0924|\u09ad\u09be\u09b0\u09a4|\u0a2d\u0a3e\u0a30\u0a24|\u0aad\u0abe\u0ab0\u0aa4|\u0b87\u0ba8\u0bcd\u0ba4\u0bbf\u0baf\u0bbe|\u0b87\u0bb2\u0b99\u0bcd\u0b95\u0bc8|\u0b9a\u0bbf\u0b99\u0bcd\u0b95\u0baa\u0bcd\u0baa\u0bc2\u0bb0\u0bcd|\u0baa\u0bb0\u0bbf\u0b9f\u0bcd\u0b9a\u0bc8|\u0c2d\u0c3e\u0c30\u0c24\u0c4d|\u0dbd\u0d82\u0d9a\u0dcf|\u0e44\u0e17\u0e22|\u30c6\u30b9\u30c8|\u4e2d\u56fd|\u4e2d\u570b|\u53f0\u6e7e|\u53f0\u7063|\u65b0\u52a0\u5761|\u6d4b\u8bd5|\u6e2c\u8a66|\u9999\u6e2f|\ud14c\uc2a4\ud2b8|\ud55c\uad6d|xn\\-\\-0zwm56d|xn\\-\\-11b5bs3a9aj6g|xn\\-\\-3e0b707e|xn\\-\\-45brj9c|xn\\-\\-80akhbyknj4f|xn\\-\\-90a3ac|xn\\-\\-9t4b11yi5a|xn\\-\\-clchc0ea0b2g2a9gcd|xn\\-\\-deba0ad|xn\\-\\-fiqs8s|xn\\-\\-fiqz9s|xn\\-\\-fpcrj9c3d|xn\\-\\-fzc2c9e2c|xn\\-\\-g6w251d|xn\\-\\-gecrj9c|xn\\-\\-h2brj9c|xn\\-\\-hgbk6aj7f53bba|xn\\-\\-hlcj6aya9esc7a|xn\\-\\-j6w193g|xn\\-\\-jxalpdlp|xn\\-\\-kgbechtv|xn\\-\\-kprw13d|xn\\-\\-kpry57d|xn\\-\\-lgbbat1ad8j|xn\\-\\-mgbaam7a8h|xn\\-\\-mgbayh7gpa|xn\\-\\-mgbbh1a71e|xn\\-\\-mgbc0a9azcg|xn\\-\\-mgberp4a5d4ar|xn\\-\\-o3cw4h|xn\\-\\-ogbpf8fl|xn\\-\\-p1ai|xn\\-\\-pgbs0dh|xn\\-\\-s9brj9c|xn\\-\\-wgbh1c|xn\\-\\-wgbl6a|xn\\-\\-xkc2al3hye2a|xn\\-\\-xkc2dl3a5ee0h|xn\\-\\-yfro4i67o|xn\\-\\-ygbi2ammx|xn\\-\\-zckzah|xxx)"
    @"|y[et]"
    @"|z[amw]))"
    @"|(?:(?:25[0-5]|2[0-4]"
    @"[0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\\.(?:25[0-5]|2[0-4][0-9]"
    @"|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(?:25[0-5]|2[0-4][0-9]|[0-1]"
    @"[0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}"
    @"|[1-9][0-9]|[0-9])))"
    @"(?:\\:\\d{1,5})?)"
    @"(\\/(?:(?:["
    @"a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF"
    @"\\;\\/\\?\\:\\@\\&\\=\\#\\~"
    @"\\-\\.\\+\\!\\*\\'\\(\\)\\,\\_])|(?:\\%[a-fA-F0-9]{2}))*)?"
    @"(?:\\b|$)";

@end

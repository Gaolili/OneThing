 
//

#import "UIColorHex.h"
@implementation UIColor (ColorFromHex)

+ (instancetype)getColor:(NSString *)hexColor
{
    return [UIColor getColor:hexColor andAlpha:1.0f];
}

+ (instancetype)getColor:(NSString *)hexColor andAlpha:(CGFloat)alpha
{
    
    // 删除字符串中的空格
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    // 如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    
    // 颜色转化
    unsigned int red,green,blue;
    NSRange range;
    unsigned int change;
    if (!([cString length] == 6 || [cString length] == 3))
    {
        return [UIColor clearColor];
    } else if ([cString length] == 3) {
        cString = [NSString stringWithFormat:@"%@%@", cString, cString];
    }
    change = 2;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&red];
    range.location += change;
    [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&green];
    range.location += change;
    [[NSScanner scannerWithString:[cString substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:alpha];
}


@end

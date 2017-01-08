//
//  NSString+Category.m
//  OneThing
//
//  Created by juphoon on 17/1/3.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)
-(NSMutableAttributedString *)attributeWithString:(NSString *)string LineSpace:(int)space{
    NSMutableAttributedString *  attirbuteString = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    return attirbuteString;
}

-(NSMutableAttributedString *)attributeWithDefaultLineSpace{
    return [self attributeWithString:self LineSpace:12];
}

-(CGFloat)heightWithFont:(CGFloat)fontSize width:(CGFloat)widht{
    return [self boundingRectWithSize:CGSizeMake(widht, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size.height;
}

@end

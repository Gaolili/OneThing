//
//  UILabel+Category.m
//  OneThing
//
//  Created by juphoon on 17/1/3.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)
+(UILabel *)labelWithFont:(CGFloat)fontsize textColor:(UIColor*)textColor space:(CGFloat)space{
    UILabel * lab = [[UILabel alloc]init];
    lab.font = [UIFont boldSystemFontOfSize:fontsize];
    lab.textColor = textColor;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

@end

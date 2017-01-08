//
//  UIImage+TintColor.h
//  OneThing
//
//  Created by juphoon on 17/1/4.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TintColor)
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
+(UIImage*) createImageWithColor:(UIColor*) color;

@end

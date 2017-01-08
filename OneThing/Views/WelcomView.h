//
//  WelcomView.h
//  OneThing
//
//  Created by juphoon on 17/1/3.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomView : UIView
@property (nonatomic,strong)NSString * name;
- (instancetype)initWithName:(NSString *)name;
@end

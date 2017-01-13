//
//  Macro.h
//  OneThing
//
//  Created by juphoon on 17/1/3.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define NameTitle @"May I have your name please:"
#define EventTitle @"The ONE thing you plan to do this week:"

#define  WeakSelf(__param__) __weak typeof(__param__)weakSelf = self

#define IMAGE(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

#define ScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

#define  ScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...){}
#endif

#endif /* Macro_h */

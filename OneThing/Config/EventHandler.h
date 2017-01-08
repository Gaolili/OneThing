//
//  EventHandler.h
//  OneThing
//
//  Created by juphoon on 17/1/6.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventHandler : NSObject

+(instancetype)shareInstance;
-(void)addEventNotify:(NSDate *)date title:(NSString *)title;
-(void)addReminderNotify:(NSDate *)date title:(NSString *)title;

@end

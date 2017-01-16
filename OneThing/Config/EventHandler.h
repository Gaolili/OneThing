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
-(BOOL)addEventNotify:(NSDate *)date title:(NSString *)title finishBlock:(void(^)(BOOL ))block;
-(BOOL)addReminderNotify:(NSDate *)date title:(NSString *)title finishBlock:(void(^)(BOOL ))block;
-(BOOL)removeEvent;
-(BOOL)removeReminder;

- (void)getReminders:(void(^)(NSArray*))reminderBlock;
- (NSArray *)getEvents;
@end

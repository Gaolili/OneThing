//
//  EventHandler.m
//  OneThing
//
//  Created by juphoon on 17/1/6.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "EventHandler.h"
#import <EventKit/EventKit.h>
#import "AppDelegate.h"
#import "ThingModel.h"
@implementation EventHandler

static EventHandler * _eventHandler = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _eventHandler = [[EventHandler alloc]init];
        
    });
    return _eventHandler;
}


-(BOOL)addEventNotify:(NSDate *)date title:(NSString *)title

{
    //生成事件数据库对象
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    EKEventStore *eventDB = appDelegate.eventStore;
    NSLog(@"===event eventStoreIdentifier ==%@",eventDB.eventStoreIdentifier);
    
    //申请事件类型权限
  __block  BOOL isSuccess = NO;
    
    [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) { //授权是否成功
            
            EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB]; //创建一个日历事件
            
            myEvent.title     = title;  //标题
            
            myEvent.allDay = YES;
            
            myEvent.startDate = date; //开始date   required
            
            NSInteger currentWeek = [date week];
            
            myEvent.endDate   = [date dateByAddingDays:7-currentWeek];  //结束date    required
            
            [myEvent addAlarm:[EKAlarm alarmWithAbsoluteDate:date]]; //添加一个闹钟  optional
            
            [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]]; //添加calendar  required
            
            NSError *err;
            
           isSuccess =  [eventDB saveEvent:myEvent span:EKSpanFutureEvents error:&err]; //保存
            if (!error) {
                [ManagerHandler saveCurrentEventIdentifier:eventDB.eventStoreIdentifier];
                NSLog(@"add event success");
            }
            
        }
        
    }];
    return isSuccess;
    
}

-(BOOL)addReminderNotify:(NSDate *)date title:(NSString *)title

{
    
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    EKEventStore *eventDB = appDelegate.eventStore;    //申请提醒权限
    
    __block  BOOL isSuccess = NO;
    [eventDB requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            //创建一个提醒功能
            
            EKReminder *reminder = [EKReminder reminderWithEventStore:eventDB];
            //标题
            
            reminder.title = title;
            //添加日历
            
            [reminder setCalendar:[eventDB defaultCalendarForNewReminders]];
            
            NSCalendar *cal = [NSCalendar currentCalendar];
            
            [cal setTimeZone:[NSTimeZone systemTimeZone]];
            
            NSInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth |
            
            NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute |
            
            NSCalendarUnitSecond;
            NSDateComponents* dateComp = [cal components:flags fromDate:date];
            
            dateComp.timeZone = [NSTimeZone systemTimeZone];
            
            reminder.startDateComponents = dateComp; //开始时间
            
            NSInteger currentweek = [date week];
            dateComp = [cal components:flags fromDate:[date dateByAddingDays:7-currentweek]];
            
            reminder.dueDateComponents = dateComp; //到期时间
            
            reminder.priority = 1; //优先级
            
            EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date]; //添加一个车闹钟
            
            [reminder addAlarm:alarm];
            
            NSError *err;
            
            isSuccess =  [eventDB saveReminder:reminder commit:YES error:&err];

            
            if (err) {
                NSLog(@"add  Remainer Fail");
                
            }else{
                NSLog(@"add reminder success");
            }
            
            
        }
        
    }];
    return isSuccess;
}

-(BOOL)removeEvent{
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    EKEventStore *eventDB = appDelegate.eventStore;
    
    EKEvent * currentEvent  = [eventDB eventWithIdentifier:[ManagerHandler currentEventIdentifier]];
    NSError*error =nil;
    [eventDB removeEvent:currentEvent span:EKSpanThisEvent commit:YES error:&error];
    if (error) {
        NSLog(@"===remove event fail====");
        return NO;
    }
    NSLog(@"===remove event fail====");
    return YES;
 }
-(BOOL)removeReminder{
    ThingModel * currentModel = [ThingModel getCurrentThing];
    
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    EKEventStore *eventDB = appDelegate.eventStore;
    
    EKCalendar * calender = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:eventDB];
    NSPredicate * predicate  = [eventDB predicateForIncompleteRemindersWithDueDateStarting:currentModel.createDate ending:nil calendars:@[calender]];
    
   __block NSArray * allReminders = [NSArray array];
   [eventDB fetchRemindersMatchingPredicate:predicate completion:^(NSArray<EKReminder *> * _Nullable reminders) {
       allReminders = reminders;
    }];
    NSError*error =nil;
    [eventDB removeReminder:allReminders.firstObject commit:YES error:&error];
  
     if (error) {
         NSLog(@"===remove reminder fail====");
        return NO;
    }
    NSLog(@"===remove reminder success====");
    return YES;

}


@end

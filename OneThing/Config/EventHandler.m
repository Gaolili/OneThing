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



@interface EventHandler ()
@property (nonatomic,strong)NSArray * reminderArray;
@end

@implementation EventHandler

static EventHandler * _eventHandler = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _eventHandler = [[EventHandler alloc]init];
        
    });
    return _eventHandler;
}

- (BOOL)addEventNotify:(NSDate *)date title:(NSString *)title finishBlock:(void (^)(BOOL))block
{
    //生成事件数据库对象
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    EKEventStore *eventDB = appDelegate.eventStore;
    
    
    //申请事件类型权限
  __block  BOOL isSuccess = NO;
    
    if([eventDB respondsToSelector:@selector(requestAccessToEntityType:completion:)]){

      [eventDB requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        
           if (!granted) return ;  //授权是否成功
          
          dispatch_async(dispatch_get_main_queue(), ^{
              EKEvent *myEvent  = [EKEvent eventWithEventStore:eventDB]; //创建一个日历事件
              myEvent.title     = title;  //标题
              myEvent.allDay = YES;
              myEvent.startDate = date; //开始date   required
              myEvent.endDate   = [self currentWeekSunday];  //结束date    required
              [myEvent addAlarm:[EKAlarm alarmWithAbsoluteDate:[self currentWeekSunday]]]; //添加一个闹钟  optional
              [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]]; //添加calendar  required
              
              NSError *err;
              
              isSuccess =  [eventDB saveEvent:myEvent span:EKSpanFutureEvents error:&err]; //保存
              block(isSuccess);
              
              if (!err)NSLog(@"add event success");
          });
          
      }];
    }
    return isSuccess;
    
}


-(BOOL)addReminderNotify:(NSDate *)date title:(NSString *)title finishBlock:(void (^)(BOOL))block

{
    
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    EKEventStore *eventDB = appDelegate.eventStore;    //申请提醒权限
    
    __block  BOOL isSuccess = NO;
    [eventDB requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
             EKReminder *reminder = [EKReminder reminderWithEventStore:eventDB];
             reminder.title = title;
            [reminder setCalendar:[eventDB defaultCalendarForNewReminders]];
            NSCalendar *cal = [NSCalendar currentCalendar];
            [cal setTimeZone:[NSTimeZone systemTimeZone]];
            
            NSInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth |
            NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute |
            NSCalendarUnitSecond;
            NSDateComponents* dateComp = [cal components:flags fromDate:date];
            
            dateComp.timeZone = [NSTimeZone systemTimeZone];
            reminder.startDateComponents = dateComp; //开始时间
            dateComp = [cal components:flags fromDate:[self currentWeekSunday]];
            reminder.dueDateComponents = dateComp; //到期时间
            
//            reminder.completionDate = [self currentWeekSunday];
            
            reminder.priority = 1; //优先级
            EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:[self currentWeekSunday]]; //添加一个车闹钟
            [reminder addAlarm:alarm];
            NSError *err;
            isSuccess =  [eventDB saveReminder:reminder commit:YES error:&err];
            block(isSuccess);
            
            if (err) NSLog(@"add  Remainer Fail");
              
           }
        
    }];
    return isSuccess;
}

#pragma mark - evnets
- (NSArray *)getEvents{
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    EKEventStore *eventDB = appDelegate.eventStore;
    
    NSDate * monday = [self currentWeekmonday];//周一
    
    EKCalendar * calendar =[eventDB defaultCalendarForNewEvents];
    if (!calendar) return nil;
    
    NSPredicate * predicate = [eventDB predicateForEventsWithStartDate:monday endDate:[NSDate date] calendars:nil];
    NSArray * eventArray  = [eventDB eventsMatchingPredicate:predicate];
    return eventArray;
}

-(BOOL)removeEvent{
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    EKEventStore *eventDB = appDelegate.eventStore;
    NSArray * eventArray  = [self getEvents];
    if (!eventArray.count) {
        NSLog(@"no find event");
        return NO;
    }
    NSError*error =nil;
    for (EKEvent * currentEvent in eventArray ) {
        if ([currentEvent.title isEqualToString:[ThingModel getCurrentThingName]]) {
            [eventDB removeEvent:currentEvent span:EKSpanThisEvent commit:YES error:&error];
            return error ? NO : YES;
        }
     }
    return NO;
 }


- (void)getReminders:(void(^)(NSArray*))reminderBlock{
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    EKEventStore *eventDB = appDelegate.eventStore;
    
    NSPredicate * predicate =  [eventDB predicateForIncompleteRemindersWithDueDateStarting:nil ending:nil calendars:nil];
     [eventDB fetchRemindersMatchingPredicate:predicate completion:^(NSArray<EKReminder *> * _Nullable reminders) {
        reminderBlock(reminders);
     }];

}

-(BOOL)removeReminder{
    WeakSelf(self);
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    EKEventStore *eventDB = appDelegate.eventStore;
    
    NSPredicate * predicate =  [eventDB predicateForIncompleteRemindersWithDueDateStarting:nil ending:nil calendars:nil];
    __block NSArray * reminderArr = [NSArray array];
    [eventDB fetchRemindersMatchingPredicate:predicate completion:^(NSArray<EKReminder *> * _Nullable reminders) {
        reminderArr = reminders;
        [weakSelf removeReminderActcion:reminders];
    }];
    
    return YES;

}

- (BOOL)removeReminderActcion:(NSArray *)array{
    
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    EKEventStore *eventDB = appDelegate.eventStore;
    if (!array.count) return NO;
    
    NSError * removeError = nil;
    for (EKReminder * reminder in array) {
        if ([reminder.title isEqualToString:[ThingModel getCurrentThingName]]) {
            [eventDB removeReminder:reminder commit:YES error:&removeError];
         }
    }
    return removeError?  NO : YES;

}
//获取当前周的星期一
-(NSDate *)currentWeekmonday{
    NSInteger todayWeek = [[NSDate date]weekday];
    NSDate * tempDate ;
    if (todayWeek>1&&todayWeek<8) {
       tempDate = [[NSDate date] dateBySubtractingDays:todayWeek-2];
    }else{
       tempDate = [[NSDate date] dateBySubtractingDays:6];
    }
    return [self stringWithDateZero:tempDate hourMS:@"yyyy-MM-dd 00:00:00"];
}
//获取当前周的星期日
- (NSDate *)currentWeekSunday{
    NSInteger todayWeek = [[NSDate date]weekday];
    NSDate * tempDate ;
    if (todayWeek!=1) {
        tempDate = [[NSDate date] dateByAddingDays:7-todayWeek+1];
    }else{
        tempDate = [NSDate date];
    }
    return [self stringWithDateZero:tempDate hourMS:@"yyyy-MM-dd 24:00:00"];
}

- (NSDate *)stringWithDateZero:(NSDate*)date hourMS:(NSString *)hms {
    NSDateFormatter * formatter  = [[NSDateFormatter alloc] init];
    formatter.dateFormat = hms;
    NSString * dateStr = [formatter stringFromDate:date];
    return [formatter dateFromString:dateStr];
}


@end

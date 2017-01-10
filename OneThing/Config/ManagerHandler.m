//
//  ManagerHandler.m
//  OneThing
//
//  Created by juphoon on 17/1/10.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "ManagerHandler.h"
#import "ThingModel.h"
@implementation ManagerHandler
+(BOOL)shouldPresentIntroVC {
    
    return  [[self class] getUserName].length;
 
}
+(void)saveUserName:(NSString *)name{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:name forKey:@"userName"];
    [userDefault synchronize];
}
+(NSString *)getUserName{
     NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * name = [userDefault objectForKey:@"userName"];
    return name;
}
+ (void)saveCurrentEventIdentifier:(NSString *)identifier{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:identifier forKey:@"Event_identifier"];
    [userDefault synchronize];

}
+(NSString *)currentEventIdentifier{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * identifier = [userDefault objectForKey:@"Event_identifier"];
    return identifier;
}

+(void)saveReminderIdentifier:(NSString *)identifier{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:identifier forKey:@"Reminder_identifier"];
    [userDefault synchronize];

}
+(NSString *)reminderIdentifier{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * identifier = [userDefault objectForKey:@"Reminder_identifier"];
    return identifier;
}

+(void)sendCheckFinishThingNotice{
    NSString * thing =   [ThingModel getCurrentThing].thingName;
    if (!thing.length)return;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate date];
    NSDateComponents *componentsForFireDate = [calendar components:(NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal|  NSCalendarUnitHour | NSCalendarUnitMinute| NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate: now];
    [componentsForFireDate setWeekday: 1] ; //for fixing Sunday
    [componentsForFireDate setHour: 20] ; //for fixing 8PM hour
    [componentsForFireDate setMinute:0] ;
    [componentsForFireDate setSecond:0] ;
    ManagerHandler * handler = [[ManagerHandler alloc]init];
    [handler sendNotic:[NSString stringWithFormat:@"这周你的计划%@完成了吗？",thing] fireDate:[calendar dateFromComponents: componentsForFireDate]];
    
//    [handler sendNotic:[NSString stringWithFormat:@"这周你的计划%@完成了吗？",thing] fireDate: [NSDate dateWithTimeIntervalSinceNow:3.0] ];
    
    
}
+(void)sendAddThingNotice{
    NSString * thing =   [ThingModel getCurrentThing].thingName;
    if (thing.length)return;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = [NSDate date];
    NSDateComponents *componentsForFireDate = [calendar components:(NSCalendarUnitYear | NSCalendarUnitWeekdayOrdinal|  NSCalendarUnitHour | NSCalendarUnitMinute| NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate: now];
    [componentsForFireDate setWeekday: 0] ; //for fixing Sunday
    [componentsForFireDate setHour: 8] ; //for fixing 8PM hour
    [componentsForFireDate setMinute:0] ;
    [componentsForFireDate setSecond:0] ;
    ManagerHandler * handler = [[ManagerHandler alloc]init];
    [handler sendNotic:@"快来添加一个计划吧~~" fireDate:[calendar dateFromComponents: componentsForFireDate]];
    
}

- (void)sendNotic:(NSString *)content fireDate:(NSDate *)fireDate{
    NSString * thing =   [ThingModel getCurrentThing].thingName;
    if (!thing.length)return;
    
    NSString * weekThing = content;
    
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    
    localNote.fireDate = fireDate;
    localNote.alertBody = weekThing;
    localNote.alertAction = @"查看";
    localNote.hasAction = NO;
    localNote.alertTitle = @"你有一条新通知";
    localNote.applicationIconBadgeNumber = 1;
    
    localNote.repeatInterval=NSCalendarUnitWeekday;//通知重复次数
    //    localNote.repeatCalendar=[NSCalendar currentCalendar];
    localNote.userInfo =@{@"aps":@{@"alert":weekThing}};
    localNote.soundName=UILocalNotificationDefaultSoundName;
    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
//    [[UIApplication sharedApplication] presentLocalNotificationNow:localNote];
}


@end

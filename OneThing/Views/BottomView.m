//
//  BottomView.m
//  OneThing
//
//  Created by juphoon on 17/1/5.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "BottomView.h"
#import "ThingModel.h"
#import <UserNotifications/UserNotifications.h>
#import <EBForeNotification.h>

@interface BottomView ()
@property (nonatomic,strong)NSArray * imgoffArray;
@property (nonatomic,strong)NSArray * imgonArray;
@property (nonatomic,strong)ThingModel * currentThing;
@property (nonatomic,strong)UIButton * calendarsBtn;
@property (nonatomic,strong)UIButton * remindersBtn;
@property (nonatomic,strong)UIButton * noticeBtn;
@property (nonatomic,strong)UIButton * desktopBtn;
@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imgoffArray =@[@"calender_off",@"reminder_off",@"notification_off",@"wallpaper_off"];
        _imgonArray =@[@"calender_on",@"reminder_on",@"notification_on",@"wallpaper_on"];
        [self setup];
        _calendarsBtn.selected = [[EventHandler shareInstance] getEvents].count;
        [[EventHandler shareInstance] getReminders:^(NSArray * items) {
            _remindersBtn.selected = items.count;
        }];
        
        for (UILocalNotification * notification in  [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            NSString *notiID = notification.userInfo[@"kLocalNotificationID"];
            if ([notiID isEqualToString:[ThingModel getCurrentThingName]]) {
                _noticeBtn.selected = YES;
            }
        }
        
    }
    return self;
}

- (void)setup{
    WeakSelf(self);
    CGFloat offset = (ScreenWidth-300)/2;
    UIButton * lastBtn = nil;
    for (int i =0; i<4; i++) {
        UIButton * btn = [self custombuttonWithImgnormal:_imgoffArray[i] selectedImg:_imgonArray[i]];
        btn.tag = 1000 + i;
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor getColor:@"#bdc2c7"]] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        
        [self settingBtn:btn];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!lastBtn) {
                make.left.equalTo(weakSelf).offset(offset);
            }else{
                make.left.equalTo(lastBtn.mas_right).offset(36);
            }
            make.top.equalTo(weakSelf);
            make.width.height.equalTo(@(48));
        }];
        
        lastBtn = btn;
    }
}

- (void)buttonAction:(UIButton*)btn{
 
    
     if(btn.tag ==1000){
        if(!btn.selected){
           [[EventHandler shareInstance] addEventNotify:[NSDate date] title:self.currentThing.thingName finishBlock:^(BOOL success) {
               btn.selected = success;
           }];
        }else{
            //移除事件
           btn.selected = ![[EventHandler shareInstance] removeEvent];
        }
     }else if (btn.tag == 1001){
         if (!btn.selected) {
             [[EventHandler shareInstance] addReminderNotify:[NSDate date] title:self.currentThing.thingName finishBlock:^(BOOL success) {
                 btn.selected = success;
             }];
         }else{
             btn.selected = ![[EventHandler shareInstance] removeReminder];
         }
        
    }else if (btn.tag == 1002){
        //本地通知
       btn.selected = !btn.selected;
      if(btn.selected){
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [ManagerHandler sendCheckFinishThingNotice];
            }
        }];
    }else{
        [self removeNotification];
    }
    
    }else{
       // 换肤
    }
}

- (void)removeNotification{
    for (UILocalNotification * notification in  [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSString *notiID = notification.userInfo[@"kLocalNotificationID"];
        if ([notiID isEqualToString:[ThingModel getCurrentThingName]]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
         }
     }
}


- (void)settingBtn:(UIButton*)btn{
    switch (btn.tag) {
            case 1000:
            _calendarsBtn = btn;
            break;
            case 1001:
            _remindersBtn = btn;
            break;
            case 1002:
            _noticeBtn = btn;
            break;
            case 1003:
            _desktopBtn = btn;
            break;
        default:
            break;
    }
}

- (ThingModel *)currentThing{
    if (!_currentThing) {
        _currentThing = [ThingModel getCurrentThing];
    }
    return  _currentThing;
}

 - (UIButton *)custombuttonWithImgnormal:(NSString *)imgNormal selectedImg:(NSString *)selectedImg{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imgNormal] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedImg] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 24;
    btn.clipsToBounds = YES;
    return btn;
}


@end

//
//  BottomView.m
//  OneThing
//
//  Created by juphoon on 17/1/5.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "BottomView.h"
#import <UserNotifications/UserNotifications.h>
#import <EBForeNotification.h>
@interface BottomView ()
@property (nonatomic,strong)NSArray * imgoffArray;
@property (nonatomic,strong)NSArray * imgonArray;
@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imgoffArray =@[@"calender_off",@"reminder_off",@"notification_off",@"wallpaper_off"];
        _imgonArray =@[@"calender_on",@"reminder_on",@"notification_on",@"wallpaper_on"];
        [self setup];
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
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.backgroundColor = [UIColor getColor:@"#bdc2c7"];
    }else{
        btn.backgroundColor = [UIColor whiteColor];
    }
    NSLog(@"btn == %ld",(long)btn.tag);
    if(btn.tag ==1000){
    [[EventHandler shareInstance] addEventNotify:[NSDate date] title:@"测试添加事件到日历成功"];
    }else if (btn.tag == 1001){
        [[EventHandler shareInstance] addReminderNotify:[NSDate date] title:@"测试添加提醒"];

    }else if (btn.tag == 1002){
        //本地通知
 
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [self sendNotice];
            }
        }];
        
    }else{
        
    }
}


- (void)sendNotice{
    NSLog(@"===创建本地通知===");
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
 
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
    localNote.alertBody = @"这周你的事情完成了吗？";
    localNote.alertAction = @"解锁";
    localNote.hasAction = NO;
//    localNote.alertLaunchImage = @"123Abc";
    localNote.alertTitle = @"你有一条新通知";
//    localNote.soundName = @"buyao.wav";
    localNote.applicationIconBadgeNumber = 1;
    localNote.repeatInterval= NSCalendarUnitWeekday;//通知重复次数
    localNote.repeatCalendar=[NSCalendar currentCalendar];
    
    localNote.userInfo = @{@"aps":@"这周你的事情完成了吗"};
    localNote.soundName=UILocalNotificationDefaultSoundName;
    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
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

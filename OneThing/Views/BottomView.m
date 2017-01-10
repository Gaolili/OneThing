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
@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imgoffArray =@[@"calender_off",@"reminder_off",@"notification_off",@"wallpaper_off"];
        _imgonArray =@[@"calender_on",@"reminder_on",@"notification_on",@"wallpaper_on"];
        _currentThing = [ThingModel getCurrentThing];
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
    btn.backgroundColor = btn.selected ? [UIColor getColor:@"#bdc2c7"]:[UIColor whiteColor];
   
     if(btn.tag ==1000){
        if(btn.selected){
           [[EventHandler shareInstance] addEventNotify:[NSDate date] title:_currentThing.thingName];
        }else{
            //移除事件
            [[EventHandler shareInstance] removeEvent];
        }
     }else if (btn.tag == 1001){
         if (btn.selected) {
             [[EventHandler shareInstance] addReminderNotify:[NSDate date] title:_currentThing.thingName];
         }else{
             [[EventHandler shareInstance] removeReminder];
         }
        
    }else if (btn.tag == 1002){
        //本地通知
        
      if(btn.selected){
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [ManagerHandler sendCheckFinishThingNotice];
            }
        }];
    }else{
           [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
    
    }else{
       // 换肤
    }
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

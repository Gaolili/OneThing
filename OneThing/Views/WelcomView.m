//
//  WelcomView.m
//  OneThing
//
//  Created by juphoon on 17/1/3.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "WelcomView.h"

@interface WelcomView()
@property (nonatomic,strong) UILabel * hiLabel;
@property (nonatomic,strong) UILabel * welcomeLabel;
@end

@implementation WelcomView

- (instancetype)initWithName:(NSString *)name{
    if(self = [super init]){
         [self setup];
    }
    return self;
}

- (void)setup{
    _hiLabel = [[UILabel alloc]init];
    _hiLabel.numberOfLines = 0;
    _hiLabel.textColor = [UIColor grayColor];
    _hiLabel.font = [UIFont fontWithName:@"TrajanPro-Regular" size:18];
    _hiLabel.textAlignment = NSTextAlignmentCenter;
     [self addSubview:_hiLabel];
    
    _welcomeLabel = [[UILabel alloc]init];
    _welcomeLabel.font = [UIFont fontWithName:@"TrajanPro-Regular" size:24];
    _welcomeLabel.text = @"WELCOME";
    _welcomeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_welcomeLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    WeakSelf(self);
//    CGFloat textH = [_name heightWithFont:18 width:ScreenWidth];
    [_hiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.equalTo(weakSelf);
        make.height.equalTo(@(40));
     }];
    [_welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hiLabel.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];

}

- (void)setName:(NSString *)name{
    _name = name;
    _hiLabel.text = [NSString stringWithFormat:@"Hi,%@",name];
    CGFloat textH = [_name heightWithFont:18 width:ScreenWidth];
    [_hiLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(textH));
    }];
 }

@end

//
//  InputView.h
//  OneThing
//
//  Created by juphoon on 17/1/3.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputViewDelegate <NSObject>

- (void)clickSureBtnDelegateMethodTitle:(NSString *)title;

@end

@interface InputView : UIView
@property (nonatomic,weak)id<InputViewDelegate>inputDelegate;
@property (nonatomic,strong)UITextView * inputField;
- (instancetype)initWithTitle:(NSString *)title;

- (void)hiddenTitleAndBtnAnimation;
- (CGFloat)getHeight;
@end

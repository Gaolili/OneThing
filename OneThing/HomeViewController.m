//
//  HomeViewController.m
//  OneThing
//
//  Created by juphoon on 17/1/3.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "HomeViewController.h"
#import "InputView.h"
#import "WelcomView.h"
#import "BottomView.h"

@interface HomeViewController ()<InputViewDelegate>
@property (nonatomic,strong)InputView * nameInput;
@property (nonatomic,strong)WelcomView * welcomeView;
@property (nonatomic,strong)InputView * eventInput;
@property (nonatomic,strong)BottomView * bottomView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.nameInput.inputField becomeFirstResponder];
    [self.view addSubview:self.nameInput];
    self.nameInput.frame = CGRectMake(0, 0, ScreenWidth,130);
    self.nameInput.center = self.view.center;
    
    [self.view addSubview:self.eventInput];
    self.eventInput.frame = CGRectMake(0, 0, ScreenWidth, 130);
    self.eventInput.center = CGPointMake(self.view.center.x, self.view.center.y -100);
   
    self.welcomeView.frame = CGRectMake(0, 0, ScreenWidth, 200);
    self.welcomeView.center = self.view.center;
    
    [self.view addSubview:self.bottomView];
    
}

- (void)clickSureBtnDelegateMethodTitle:(NSString *)title{
    if ([title isEqualToString:NameTitle]) {
        if (self.nameInput.inputField.text.length) {
            [self nameAnimation];
        }
    }else{
        if (self.eventInput.inputField.text.length) {
            [self.eventInput hiddenTitleAndBtnAnimation];
            [self eventDisappearAnimation];
        }
     }
}

- (void)nameAnimation{
    WeakSelf(self);
    POPBasicAnimation * moveAnimat = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    moveAnimat.toValue = @(CGRectGetHeight(self.view.bounds)/2-100);
    moveAnimat.duration = 1.0f;
    moveAnimat.beginTime = CACurrentMediaTime();
    moveAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    POPBasicAnimation * alpaAnimat = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    alpaAnimat.fromValue = @(1.0);
    alpaAnimat.toValue = @(0.0);
    alpaAnimat.duration = 1.0f;
    alpaAnimat.beginTime = CACurrentMediaTime();
    alpaAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.nameInput.layer pop_addAnimation:moveAnimat forKey:@"moveAnimat" ];
    [self.nameInput.layer pop_addAnimation:alpaAnimat forKey:@"alpaAnimat"];
    [alpaAnimat setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        weakSelf.welcomeView.hidden = NO;
        [weakSelf.nameInput removeFromSuperview];
        [weakSelf welocmeAnimation];
    }];
}

- (void)welocmeAnimation{
    
    WeakSelf(self);
    self.welcomeView.name = self.nameInput.inputField.text;
    
    POPBasicAnimation * welcomAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    welcomAnim.fromValue = @(0.0);
    welcomAnim.toValue = @(1.0);
    welcomAnim.duration = 2.0;
    welcomAnim.beginTime = CACurrentMediaTime();
    welcomAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    POPBasicAnimation * welcomeMoveAnimat = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    welcomeMoveAnimat.toValue = @(CGRectGetHeight(self.view.bounds)/2 + 100);
    welcomeMoveAnimat.duration = 2.0f;
    welcomeMoveAnimat.beginTime = CACurrentMediaTime() ;
    welcomeMoveAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    POPBasicAnimation * welcomRemoveAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    welcomRemoveAnim.fromValue = @(1.0);
    welcomRemoveAnim.toValue = @(0.0);
    welcomRemoveAnim.duration = 2.0;
    welcomRemoveAnim.beginTime = CACurrentMediaTime() + 2.f;
    welcomRemoveAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    [self.welcomeView.layer pop_addAnimation:welcomeMoveAnimat forKey:@"welcomeMoveAnimat"];
    [self.welcomeView.layer pop_addAnimation:welcomAnim forKey:@"welcomAnim"];
    [self.welcomeView.layer pop_addAnimation:welcomRemoveAnim forKey:@"welcomRemoveAnim"];
    
    [welcomeMoveAnimat setCompletionBlock:^(POPAnimation * an, BOOL finished) {
        [weakSelf.welcomeView removeFromSuperview];
        weakSelf.eventInput.hidden = NO;
        [weakSelf eventAnimation];
    }];
}

- (void)eventAnimation{
    [self.eventInput.inputField becomeFirstResponder];
    POPBasicAnimation * eventAnimat = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    eventAnimat.toValue = @(CGRectGetHeight(self.view.bounds)/2-30);
    eventAnimat.duration = 1.5f;
    eventAnimat.beginTime = CACurrentMediaTime();
    eventAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    POPBasicAnimation * eventAlpaAnimat = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    eventAlpaAnimat.fromValue = @(0.0);
    eventAlpaAnimat.toValue = @(1.0);
    eventAlpaAnimat.duration = 1.5f;
    eventAlpaAnimat.beginTime = CACurrentMediaTime();
    eventAlpaAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.eventInput.layer pop_addAnimation:eventAnimat forKey:@"eventAnimat" ];
    [self.eventInput.layer pop_addAnimation:eventAlpaAnimat forKey:@"eventAlpaAnimat"];
    
}

- (void)eventDisappearAnimation{
    
    self.bottomView.hidden = NO;
    
    [self.eventInput.inputField becomeFirstResponder];
    self.eventInput.inputField.editable = NO;
    POPBasicAnimation * eventAnimat = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    eventAnimat.toValue = @(CGRectGetHeight(self.view.bounds)/2);
    eventAnimat.duration = 1.0f;
    eventAnimat.beginTime = CACurrentMediaTime();
    eventAnimat.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.eventInput.layer pop_addAnimation:eventAnimat forKey:@"eventAnimat" ];
 }

- (void)keyboardShow:(NSNotification *)not{
    //获取键盘的高度
//    NSDictionary *userInfo = [not userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
 
    
    [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect origin = self.nameInput.frame;
        origin.origin.y -= 30;
        self.nameInput.frame = origin;
    } completion:nil];
    [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect origin = self.eventInput.frame;
        origin.origin.y -= 30;
        self.eventInput.frame = origin;
    } completion:nil];
    
}

-(void)keyboardHide:(NSNotification *)not{
     [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect origin = self.nameInput.frame;
        origin.origin.y += 30;
        self.nameInput.frame = origin;
    } completion:nil];
    
    [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect origin = self.eventInput.frame;
        origin.origin.y += 30;
        self.eventInput.frame = origin;
    } completion:nil];
    
}

#pragma mark - getter and setter
- (InputView *)nameInput{
    if(!_nameInput){
        _nameInput = [[InputView alloc]initWithTitle:NameTitle];
        _nameInput.inputDelegate=self;
    }
    return _nameInput;
}

- (WelcomView *)welcomeView{
    if (!_welcomeView) {
        _welcomeView = [[WelcomView alloc] initWithName:self.nameInput.inputField.text];
         _welcomeView.hidden = YES;
        [self.view addSubview:_welcomeView];
    }
    return _welcomeView;
}

- (InputView *)eventInput{
    if (!_eventInput) {
        _eventInput = [[InputView alloc]initWithTitle:EventTitle];
        _eventInput.inputDelegate = self;
        _eventInput.hidden = YES;
    }
    return _eventInput;
}

- (BottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[BottomView alloc]initWithFrame:CGRectMake(0, ScreenHeight-72, ScreenWidth, 72)];
         _bottomView.hidden = YES;
        
    }
    return  _bottomView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

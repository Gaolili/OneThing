//
//  InputView.m
//  OneThing
//
//  Created by juphoon on 17/1/3.
//  Copyright © 2017年 juphoon. All rights reserved.
//

#import "InputView.h"


@interface InputView ()<UITextViewDelegate>
@property (nonatomic,strong)NSString * title;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UIButton * sureBtn;
@end
@implementation InputView

- (instancetype)initWithTitle:(NSString *)title{
   
    if (self = [super init]) {
        _title = title;
        [self setup];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)setup{
    UILabel * titleLabel = [UILabel labelWithFont:18 textColor:[UIColor grayColor] space:12];
    titleLabel.text = _title.capitalizedString;
    _titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    _inputField = [[UITextView alloc]init];
    _inputField.font =[UIFont fontWithName:@"TrajanPro-Regular" size:24];
    _inputField.textAlignment = NSTextAlignmentCenter;
    _inputField.delegate = self;
    _inputField.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _inputField.scrollEnabled = NO;
//    _inputField.selectable = NO;
    _inputField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self addSubview:_inputField];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.layer.cornerRadius = 20;
    _sureBtn.clipsToBounds = YES;
    [_sureBtn setImage:IMAGE(@"OK") forState:UIControlStateNormal];
    [_sureBtn setBackgroundColor:[UIColor getColor:@"#bdc2c7"]];
    [_sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureBtn];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    WeakSelf(self);
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.equalTo(weakSelf);
        make.height.equalTo(@45);

    }];
    
    [_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.height.mas_greaterThanOrEqualTo(@40);
    }];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputField.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.height.equalTo(@40);
    }];
 
}

- (void)sureBtnAction:(UIButton*)btn{
    if ([self.inputDelegate respondsToSelector:@selector(clickSureBtnDelegateMethodTitle:)]) {
        [self.inputDelegate clickSureBtnDelegateMethodTitle:_title];
    }
}

- (void)hiddenTitleAndBtnAnimation{
    POPBasicAnimation * titleHiddenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    titleHiddenAnimation.fromValue = @(1.0);
    titleHiddenAnimation.toValue = @(0.0);
    titleHiddenAnimation.duration = 1.0f;
    titleHiddenAnimation.beginTime = CACurrentMediaTime();
    titleHiddenAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    POPBasicAnimation * BtnHiddenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    BtnHiddenAnimation.fromValue = @(1.0);
    BtnHiddenAnimation.toValue = @(0.0);
    BtnHiddenAnimation.duration = 1.0f;
    BtnHiddenAnimation.beginTime = CACurrentMediaTime();
    BtnHiddenAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.titleLabel.layer pop_addAnimation:titleHiddenAnimation forKey:@"titleHiddenAnimation"];
    [self.sureBtn.layer pop_addAnimation:BtnHiddenAnimation forKey:@"BtnHiddenAnimation"];
    
}

#pragma mark - delegate
- (void)textViewDidChange:(UITextView *)textView{
    //获得textView的初始尺寸
    CGFloat width = CGRectGetWidth(textView.frame);
    CGFloat height = CGRectGetHeight(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
    textView.frame= newFrame;
    [_sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inputField.mas_bottom).offset(20);
    }];
    if (textView.text.length) {
        [_sureBtn setBackgroundColor:[UIColor getColor:@"00c957"]];
    }else{
        [_sureBtn setBackgroundColor:[UIColor getColor:@"#bdc2c7"]];
    }
    CGRect originRect = self.frame;
    originRect.size.height = CGRectGetMaxY(_sureBtn.frame);
    self.frame = originRect;
}


@end

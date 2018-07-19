//
//  ZLKeyboard.m
//  ZLKeyboardDemo
//
//  Created by zhaoliang chen on 2018/7/18.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import "ZLKeyboard.h"
#import "ZLCharKeyboard.h"
#import "ZLNumberKeyboard.h"
#import "ZLSymbolKeyboard.h"
#import "Masonry.h"
#import <sys/utsname.h>

@interface ZLKeyboard()

@property(nonatomic,weak)UITextField* zlTextField;
@property(nonatomic,weak)UITextView* zlTextView;

@property(nonatomic,strong)UIButton* btnLogo;
@property(nonatomic,strong)UIButton* btnDone;

@property(nonatomic,strong)ZLCharKeyboard* charKeyboard;
@property(nonatomic,strong)ZLNumberKeyboard* numberKeyboard;
@property(nonatomic,strong)ZLSymbolKeyboard* symbolKeyboard;

@end

@implementation ZLKeyboard

- (instancetype)initWithTextField:(UITextField*)textField {
    self = [super init];
    if (self) {
        [self setupKeyboard];
        self.zlTextField = textField;
        self.zlTextField.inputView = self;
        self.keyBoardLayoutStyle = KeyBoardLayoutStyleDefault;
    }
    return self;
}

- (instancetype)initWithTextView:(UITextView*)textView {
    self = [super init];
    if (self) {
        [self setupKeyboard];
        self.zlTextView = textView;
        self.zlTextView.inputView = self;
        self.keyBoardLayoutStyle = KeyBoardLayoutStyleDefault;
    }
    return self;
}

- (instancetype)initWithKeyboardType:(ZLKeyBoardLayoutStyle)style {
    self = [super init];
    if (self) {
        [self setupKeyboard];
        self.keyBoardLayoutStyle = style;
    }
    return self;
}

+ (instancetype)bindKeyboard:(UITextField*)textField {
    ZLKeyboard *keyboard = [[ZLKeyboard alloc]initWithTextField:textField];
    return keyboard;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"键盘释放");
}

- (void)setKeyBoardLayoutStyle:(ZLKeyBoardLayoutStyle)keyBoardLayoutStyle {
    _keyBoardLayoutStyle = keyBoardLayoutStyle;
    self.charKeyboard.hidden = YES;
    self.numberKeyboard.hidden = YES;
    self.symbolKeyboard.hidden = YES;
    switch (keyBoardLayoutStyle) {
        case KeyBoardLayoutStyleDefault:
        case KeyBoardLayoutStyleLetters:
            self.charKeyboard.hidden = NO;
            break;
        case KeyBoardLayoutStyleNumbers:
            self.numberKeyboard.hidden = NO;
            break;
        case KeyBoardLayoutStyleSymbol:
            self.symbolKeyboard.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)setupKeyboard {
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarDidOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [self setupFrame];
    
    [self setupTopView];
    
    [self setupCharKeyboard];
    
    [self setupNumberKeyboard];
    
    [self setupSymbolKeyboard];
    
    [self statusBarDidOrientationChange:nil];
}

- (void)setupFrame {
    self.frame = CGRectMake(0, 0, 0, 256+([self deviceType]==IPhone_X?30:0));
}

- (void)setupTopView {
    [self addSubview:self.btnDone];
    [self.btnDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(60);
    }];
    [self addSubview:self.btnLogo];
    [self.btnLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self.btnDone);
        make.height.mas_equalTo(40);
    }];
}

- (void)setupCharKeyboard {
    [self addSubview:self.charKeyboard];
    [self.charKeyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        if ([self deviceType] == IPhone_X) {
            make.bottom.mas_equalTo(-30);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.top.mas_equalTo(self.btnLogo.mas_bottom);
    }];
    
    __weak typeof(ZLKeyboard*) weakSelf = self;
    self.charKeyboard.onClickChar = ^(ZLKeyValue key, NSString *value) {
        if (key == KeyLetter) {
            weakSelf.zlTextField.text = [weakSelf.zlTextField.text stringByAppendingString:value];
            weakSelf.zlTextView.text = [weakSelf.zlTextView.text stringByAppendingString:value];
        } else if (key == KeyDelete) {
            NSUInteger stringLength1 = weakSelf.zlTextField.text.length;
            if (stringLength1 > 0) {
                weakSelf.zlTextField.text = [weakSelf.zlTextField.text substringToIndex:stringLength1 - 1];
            }
            NSUInteger stringLength2 = weakSelf.zlTextView.text.length;
            if (stringLength2 > 0) {
                weakSelf.zlTextView.text = [weakSelf.zlTextView.text substringToIndex:stringLength2 - 1];
            }
        } else if (key == KeySwitchNumber) {
            weakSelf.numberKeyboard.hidden = NO;
            weakSelf.charKeyboard.hidden = YES;
            weakSelf.symbolKeyboard.hidden = YES;
        } else if (key == KeySwitchSymbol) {
            weakSelf.numberKeyboard.hidden = YES;
            weakSelf.charKeyboard.hidden = YES;
            weakSelf.symbolKeyboard.hidden = NO;
        } else if (key == KeySpace) {
            weakSelf.zlTextField.text = [weakSelf.zlTextField.text stringByAppendingString:@" "];
            weakSelf.zlTextView.text = [weakSelf.zlTextView.text stringByAppendingString:@" "];
        }
    };
}

- (void)setupNumberKeyboard {
    [self addSubview:self.numberKeyboard];
    [self.numberKeyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.charKeyboard);
        make.top.left.mas_equalTo(self.charKeyboard);
    }];
    self.numberKeyboard.hidden = YES;
    
    __weak typeof(ZLKeyboard*) weakSelf = self;
    self.numberKeyboard.onClickNumber = ^(ZLKeyValue key, NSString *value) {
        if (key == KeyNumber) {
            weakSelf.zlTextField.text = [weakSelf.zlTextField.text stringByAppendingString:value];
            weakSelf.zlTextView.text = [weakSelf.zlTextView.text stringByAppendingString:value];
        } else if (key == KeyDelete) {
            NSUInteger stringLength1 = weakSelf.zlTextField.text.length;
            if (stringLength1 > 0) {
                weakSelf.zlTextField.text = [weakSelf.zlTextField.text substringToIndex:stringLength1 - 1];
            }
            NSUInteger stringLength2 = weakSelf.zlTextView.text.length;
            if (stringLength2 > 0) {
                weakSelf.zlTextView.text = [weakSelf.zlTextView.text substringToIndex:stringLength2 - 1];
            }
        } else if (key == KeySwitchLetter) {
            weakSelf.numberKeyboard.hidden = YES;
            weakSelf.charKeyboard.hidden = NO;
            weakSelf.symbolKeyboard.hidden = YES;
        } 
    };
}

- (void)setupSymbolKeyboard {
    [self addSubview:self.symbolKeyboard];
    [self.symbolKeyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.charKeyboard);
        make.top.left.mas_equalTo(self.charKeyboard);
    }];
    self.symbolKeyboard.hidden = YES;
    
    __weak typeof(ZLKeyboard*) weakSelf = self;
    self.symbolKeyboard.onClickSymbol = ^(ZLKeyValue key, NSString *value) {
        if (key == KeySymbol) {
            weakSelf.zlTextField.text = [weakSelf.zlTextField.text stringByAppendingString:value];
            weakSelf.zlTextView.text = [weakSelf.zlTextView.text stringByAppendingString:value];
        } else if (key == KeyDelete) {
            NSUInteger stringLength1 = weakSelf.zlTextField.text.length;
            if (stringLength1 > 0) {
                weakSelf.zlTextField.text = [weakSelf.zlTextField.text substringToIndex:stringLength1 - 1];
            }
            NSUInteger stringLength2 = weakSelf.zlTextView.text.length;
            if (stringLength2 > 0) {
                weakSelf.zlTextView.text = [weakSelf.zlTextView.text substringToIndex:stringLength2 - 1];
            }
        } else if (key == KeySwitchNumber) {
            weakSelf.numberKeyboard.hidden = NO;
            weakSelf.charKeyboard.hidden = YES;
            weakSelf.symbolKeyboard.hidden = YES;
        } else if (key == KeySwitchLetter) {
            weakSelf.numberKeyboard.hidden = YES;
            weakSelf.charKeyboard.hidden = NO;
            weakSelf.symbolKeyboard.hidden = YES;
        }
    };
}

- (void)onClickDone {
    if (self.zlTextField) {
        [self.zlTextField resignFirstResponder];
    }
    if (self.zlTextView) {
        [self.zlTextView resignFirstResponder];
    }
}

- (void)statusBarDidOrientationChange:(NSNotification*)sender {
    if ([self deviceType] == IPhone_X) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation >= UIInterfaceOrientationLandscapeLeft) {
            [self.btnDone mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-44);
            }];
            [self.charKeyboard mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.btnLogo.mas_bottom);
                make.left.mas_equalTo(44);
                make.right.mas_equalTo(-44);
                make.bottom.mas_equalTo(0);
            }];
        } else {
            [self.btnDone mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
            }];
            [self.charKeyboard mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.btnLogo.mas_bottom);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
        }
        [UIView animateWithDuration:0.2 animations:^{
            [self setNeedsLayout];
        }];
    }
}

- (UIButton*)btnLogo {
    if (!_btnLogo) {
        _btnLogo = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnLogo setTitle:@"关数e安全键盘" forState:UIControlStateNormal];
        [_btnLogo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnLogo.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _btnLogo;
}

- (UIButton*)btnDone {
    if (!_btnDone) {
        _btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnDone setTitle:@"完 成" forState:UIControlStateNormal];
        _btnDone.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDone setBackgroundImage:[UIImage imageNamed:@"key_pressed"] forState:UIControlStateHighlighted];
        [_btnDone addTarget:self action:@selector(onClickDone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDone;
}

- (ZLCharKeyboard*)charKeyboard {
    if (!_charKeyboard) {
        _charKeyboard = [[ZLCharKeyboard alloc]initWithFrame:CGRectZero];
    }
    return _charKeyboard;
}

- (ZLNumberKeyboard*)numberKeyboard {
    if (!_numberKeyboard) {
        _numberKeyboard = [[ZLNumberKeyboard alloc]initWithFrame:CGRectZero];
    }
    return _numberKeyboard;
}

- (ZLSymbolKeyboard*)symbolKeyboard {
    if (!_symbolKeyboard) {
        _symbolKeyboard = [[ZLSymbolKeyboard alloc]initWithFrame:CGRectZero];
    }
    return _symbolKeyboard;
}


typedef NS_ENUM(NSInteger,DeviceType) {
    
    Unknown = 0,
    Simulator,
    IPhone_1G,          //基本不用
    IPhone_3G,          //基本不用
    IPhone_3GS,         //基本不用
    IPhone_4,           //基本不用
    IPhone_4s,          //基本不用
    IPhone_5,
    IPhone_5C,
    IPhone_5S,
    IPhone_SE,
    IPhone_6,
    IPhone_6P,
    IPhone_6s,
    IPhone_6s_P,
    IPhone_7,
    IPhone_7P,
    IPhone_8,
    IPhone_8P,
    IPhone_X,
};

- (DeviceType)deviceType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //simulator
    if ([platform isEqualToString:@"i386"])          return Simulator;
    if ([platform isEqualToString:@"x86_64"])        return Simulator;
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])     return IPhone_1G;
    if ([platform isEqualToString:@"iPhone1,2"])     return IPhone_3G;
    if ([platform isEqualToString:@"iPhone2,1"])     return IPhone_3GS;
    if ([platform isEqualToString:@"iPhone3,1"])     return IPhone_4;
    if ([platform isEqualToString:@"iPhone3,2"])     return IPhone_4;
    if ([platform isEqualToString:@"iPhone4,1"])     return IPhone_4s;
    if ([platform isEqualToString:@"iPhone5,1"])     return IPhone_5;
    if ([platform isEqualToString:@"iPhone5,2"])     return IPhone_5;
    if ([platform isEqualToString:@"iPhone5,3"])     return IPhone_5C;
    if ([platform isEqualToString:@"iPhone5,4"])     return IPhone_5C;
    if ([platform isEqualToString:@"iPhone6,1"])     return IPhone_5S;
    if ([platform isEqualToString:@"iPhone6,2"])     return IPhone_5S;
    if ([platform isEqualToString:@"iPhone7,1"])     return IPhone_6P;
    if ([platform isEqualToString:@"iPhone7,2"])     return IPhone_6;
    if ([platform isEqualToString:@"iPhone8,1"])     return IPhone_6s;
    if ([platform isEqualToString:@"iPhone8,2"])     return IPhone_6s_P;
    if ([platform isEqualToString:@"iPhone8,4"])     return IPhone_SE;
    if ([platform isEqualToString:@"iPhone9,1"])     return IPhone_7;
    if ([platform isEqualToString:@"iPhone9,3"])     return IPhone_7;
    if ([platform isEqualToString:@"iPhone9,2"])     return IPhone_7P;
    if ([platform isEqualToString:@"iPhone9,4"])     return IPhone_7P;
    if ([platform isEqualToString:@"iPhone10,1"])    return IPhone_8;
    if ([platform isEqualToString:@"iPhone10,4"])    return IPhone_8;
    if ([platform isEqualToString:@"iPhone10,2"])    return IPhone_8P;
    if ([platform isEqualToString:@"iPhone10,5"])    return IPhone_8P;
    if ([platform isEqualToString:@"iPhone10,3"])    return IPhone_X;
    if ([platform isEqualToString:@"iPhone10,6"])    return IPhone_X;
    
    return Unknown;
}

@end

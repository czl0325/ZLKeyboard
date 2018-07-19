//
//  ZLSymbolKeyboard.m
//  ZLKeyboardDemo
//
//  Created by zhaoliang chen on 2018/7/19.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import "ZLSymbolKeyboard.h"
#import "Masonry.h"

@interface ZLSymbolKeyboard()

@property(nonatomic,strong)NSArray* arraySymbol;
@property(nonatomic,strong)NSMutableArray* arrayButtons;

@end

@implementation ZLSymbolKeyboard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        
        [self setupKeyboard];
    }
    return self;
}

- (void)initialize {
    self.arraySymbol = @[@"!",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"'",@"\"",@"=",@"_",@":",@";",@"?",@"~",@"|",@"·",@"+",@"-",@"\\",@"/",@"[",@"]",@"{",@"}",@"，",@".",@"<",@">",@"€",@"£",@"￥"];
}

- (void)setupKeyboard {
    UIView* temp = nil;
    for (int i=0; i<4; i++) {
        UIView* view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self).multipliedBy(0.25);
            make.left.right.mas_equalTo(self);
            if (temp) {
                make.top.mas_equalTo(temp.mas_bottom);
            } else {
                make.top.mas_equalTo(0);
            }
        }];
        
        if (i==2) {
            UIButton* delButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [delButton setBackgroundImage:[UIImage imageNamed:@"key_normal"] forState:UIControlStateNormal];
            [delButton setImage:[UIImage imageNamed:@"key_icon_del"] forState:UIControlStateNormal];
            delButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [delButton addTarget:self action:@selector(onDeleteClick) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:delButton];
            [delButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(view).dividedBy(5.2);
                make.right.mas_equalTo(-5);
                make.top.mas_equalTo(TopBottomMargin);
                make.bottom.mas_equalTo(-TopBottomMargin);
            }];
            
            UIView* view3 = [UIView new];
            [view addSubview:view3];
            [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(5);
                make.right.mas_equalTo(delButton.mas_left).offset(-5);
                make.top.mas_equalTo(TopBottomMargin);
                make.bottom.mas_equalTo(-TopBottomMargin);
            }];
            
            NSMutableArray* array = [NSMutableArray new];
            for (int j=0; j<8; j++) {
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [view3 addSubview:btn];
                [array addObject:btn];
            }
            [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:0 tailSpacing:0];
            [array mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
            }];
            [self.arrayButtons addObjectsFromArray:array];
        } else if (i==3) {
            UIButton* switch123Button = [UIButton buttonWithType:UIButtonTypeCustom];
            switch123Button.layer.cornerRadius = 8;
            [switch123Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [switch123Button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            switch123Button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
            [switch123Button setTitle:@"123" forState:UIControlStateNormal];
            [switch123Button setBackgroundImage:[UIImage imageNamed:@"key_mood_normal"] forState:UIControlStateNormal];
            [switch123Button setBackgroundImage:[UIImage imageNamed:@"key_mood_pressed"] forState:UIControlStateHighlighted];
            [switch123Button addTarget:self action:@selector(onSwitchNumbersClick) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:switch123Button];
            [switch123Button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(TopBottomMargin);
                make.bottom.mas_equalTo(-TopBottomMargin);
                make.width.mas_equalTo(view).multipliedBy(0.12);
                make.left.mas_equalTo(5);
            }];

            //#+=
            UIButton* switchSymbolButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [switchSymbolButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [switchSymbolButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            switchSymbolButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
            switchSymbolButton.layer.cornerRadius = 8;
            [switchSymbolButton setTitle:@"ABC" forState:UIControlStateNormal];
            [switchSymbolButton setBackgroundImage:[UIImage imageNamed:@"key_mood_normal"] forState:UIControlStateNormal];
            [switchSymbolButton setBackgroundImage:[UIImage imageNamed:@"key_mood_pressed"] forState:UIControlStateHighlighted];
            [switchSymbolButton addTarget:self action:@selector(onSwitchLetterClick) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:switchSymbolButton];
            [switchSymbolButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(TopBottomMargin);
                make.bottom.mas_equalTo(-TopBottomMargin);
                make.width.mas_equalTo(view).multipliedBy(0.12);
                make.right.mas_equalTo(-5);
            }];

            UIView* view4 = [UIView new];
            [view addSubview:view4];
            [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(switch123Button.mas_right).offset(5);
                make.right.mas_equalTo(switchSymbolButton.mas_left).offset(-5);
                make.top.mas_equalTo(TopBottomMargin);
                make.bottom.mas_equalTo(-TopBottomMargin);
            }];
            
            NSMutableArray* array = [NSMutableArray new];
            for (int j=0; j<7; j++) {
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [view4 addSubview:btn];
                [array addObject:btn];
            }
            [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:0 tailSpacing:0];
            [array mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
            }];
            [self.arrayButtons addObjectsFromArray:array];
        } else {
            NSMutableArray* array = [NSMutableArray new];
            for (int j=0; j<10; j++) {
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [view addSubview:btn];
                [array addObject:btn];
            }
            [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:5 tailSpacing:5];
            [array mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(TopBottomMargin);
                make.bottom.mas_equalTo(-TopBottomMargin);
            }];
            [self.arrayButtons addObjectsFromArray:array];
        }
        temp = view;
    }
    
    for (int i=0; i<self.arrayButtons.count; i++) {
        UIButton* btn = self.arrayButtons[i];
        [btn setBackgroundImage:[UIImage imageNamed:@"key_normal"] forState:UIControlStateNormal];
        [btn setTitle:self.arraySymbol[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(onClickSymbol:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)onDeleteClick {
    if (self.onClickSymbol) {
        self.onClickSymbol(KeyDelete, nil);
    }
}

- (void)onClickSymbol:(UIButton*)btn {
    if (self.onClickSymbol) {
        self.onClickSymbol(KeySymbol, self.arraySymbol[btn.tag]);
    }
}

- (void)onSwitchNumbersClick {
    if (self.onClickSymbol) {
        self.onClickSymbol(KeySwitchNumber, nil);
    }
}

- (void)onSwitchLetterClick {
    if (self.onClickSymbol) {
        self.onClickSymbol(KeySwitchLetter, nil);
    }
}

- (NSMutableArray*)arrayButtons {
    if (!_arrayButtons) {
        _arrayButtons = [NSMutableArray new];
    }
    return _arrayButtons;
}

@end

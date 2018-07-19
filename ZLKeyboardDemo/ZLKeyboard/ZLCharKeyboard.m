//
//  ZLCharKeyboard.m
//  ZLKeyboardDemo
//
//  Created by zhaoliang chen on 2018/7/18.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import "ZLCharKeyboard.h"
#import "Masonry.h"
#include <ctype.h>

@interface ZLCharKeyboard()

@property(nonatomic,strong)NSArray* lowerLetters;
@property(nonatomic,strong)NSArray* upperLetters;
@property(nonatomic,strong)NSMutableArray* arrayLetters;

@property(nonatomic,assign)BOOL isLower;

@end

@implementation ZLCharKeyboard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        [self setupKeyboard];
    }
    return self;
}

- (void)initialize {
    self.isLower = YES;
    
    self.lowerLetters = @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"];
    self.upperLetters = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
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
            UIButton* shiftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [shiftButton setBackgroundImage:[UIImage imageNamed:@"key_normal"] forState:UIControlStateNormal];
            [shiftButton setImage:[UIImage imageNamed:@"key_icon_shift_normal"] forState:UIControlStateNormal];
            [shiftButton setImage:[UIImage imageNamed:@"key_icon_shift_highlighted"] forState:UIControlStateHighlighted];
            [shiftButton setImage:[UIImage imageNamed:@"key_icon_shift_highlighted"] forState:UIControlStateSelected];
            shiftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:shiftButton];
            [shiftButton addTarget:self action:@selector(onShiftClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:shiftButton];
            [shiftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(TopBottomMargin);
                make.left.mas_equalTo(5);
                make.bottom.mas_equalTo(-TopBottomMargin);
                make.width.mas_equalTo(60);
            }];
            
            UIButton* delButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [delButton setBackgroundImage:[UIImage imageNamed:@"key_normal"] forState:UIControlStateNormal];
            [delButton setImage:[UIImage imageNamed:@"key_icon_del"] forState:UIControlStateNormal];
            [delButton addTarget:self action:@selector(onDeleteClick) forControlEvents:UIControlEventTouchUpInside];
            delButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:delButton];
            [delButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(shiftButton);
                make.right.mas_equalTo(-5);
                make.centerY.mas_equalTo(shiftButton);
            }];
            
            UIView* view3 = [UIView new];
            [view addSubview:view3];
            [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(shiftButton.mas_right).offset(5);
                make.right.mas_equalTo(delButton.mas_left).offset(-5);
                make.top.mas_equalTo(TopBottomMargin);
                make.bottom.mas_equalTo(-TopBottomMargin);
            }];
            
            NSMutableArray* array = [NSMutableArray new];
            for (int j=0; j<7; j++) {
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [view3 addSubview:btn];
                [array addObject:btn];
            }
            [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:0 tailSpacing:0];
            [array mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
            }];
            [self.arrayLetters addObjectsFromArray:array];
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
                make.width.mas_equalTo(view).multipliedBy(0.15);
                make.left.mas_equalTo(5);
            }];
            
            //#+=
            UIButton* switchSymbolButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [switchSymbolButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [switchSymbolButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            switchSymbolButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
            switchSymbolButton.layer.cornerRadius = 8;
            [switchSymbolButton setTitle:@"#+=" forState:UIControlStateNormal];
            [switchSymbolButton setBackgroundImage:[UIImage imageNamed:@"key_mood_normal"] forState:UIControlStateNormal];
            [switchSymbolButton setBackgroundImage:[UIImage imageNamed:@"key_mood_pressed"] forState:UIControlStateHighlighted];
            [switchSymbolButton addTarget:self action:@selector(onSwitchSymbolsClick) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:switchSymbolButton];
            [switchSymbolButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(TopBottomMargin);
                make.bottom.mas_equalTo(-TopBottomMargin);
                make.width.mas_equalTo(view).multipliedBy(0.15);
                make.right.mas_equalTo(-5);
            }];
            
            //空格
            UIButton* spaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            spaceButton.layer.cornerRadius = 8;
            [spaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [spaceButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            spaceButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
            [spaceButton setTitle:@"空 格" forState:UIControlStateNormal];
            [spaceButton setBackgroundImage:[UIImage imageNamed:@"key_space_normal"] forState:UIControlStateNormal];
            [spaceButton setBackgroundImage:[UIImage imageNamed:@"key_space_pressed"] forState:UIControlStateHighlighted];
            [spaceButton addTarget:self action:@selector(onClickSpace) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:spaceButton];
            [spaceButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(TopBottomMargin);
                make.bottom.mas_equalTo(-TopBottomMargin);
                make.left.mas_equalTo(switch123Button.mas_right).offset(5);
                make.right.mas_equalTo(switchSymbolButton.mas_left).offset(-5);
            }];
        } else {
            int count = 10;
            if (i==0) {
                count = 10;
            } else {
                count = 9;
            }
            NSMutableArray* array = [NSMutableArray new];
            for (int j=0; j<count; j++) {
                UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [view addSubview:btn];
                [array addObject:btn];
            }
            [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:count==9?30:5 tailSpacing:count==9?30:5];
            [array mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(TopBottomMargin);
                make.bottom.mas_equalTo(-TopBottomMargin);
            }];
            [self.arrayLetters addObjectsFromArray:array];
        }
        temp = view;
    }
    
    for (int i=0; i<self.arrayLetters.count; i++) {
        UIButton* btn = self.arrayLetters[i];
        [btn setBackgroundImage:[UIImage imageNamed:@"key_normal"] forState:UIControlStateNormal];
        [btn setTitle:self.lowerLetters[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(onClickLetter:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)onShiftClick:(UIButton*)btn {
    btn.selected = !btn.selected;
    self.isLower = !self.isLower;
    for (int i=0; i<self.arrayLetters.count; i++) {
        UIButton* b = self.arrayLetters[i];
        if (self.isLower) {
            [b setTitle:self.lowerLetters[i] forState:UIControlStateNormal];
        } else {
            [b setTitle:self.upperLetters[i] forState:UIControlStateNormal];
        }
    }
}

- (void)onDeleteClick {
    if (self.onClickChar) {
        self.onClickChar(KeyDelete, nil);
    }
}

- (void)onClickLetter:(UIButton*)button {
    if (self.onClickChar) {
        self.onClickChar(KeyLetter, button.titleLabel.text);
    }
}

- (void)onSwitchNumbersClick {
    if (self.onClickChar) {
        self.onClickChar(KeySwitchNumber, nil);
    }
}

- (void)onSwitchSymbolsClick {
    if (self.onClickChar) {
        self.onClickChar(KeySwitchSymbol, nil);
    }
}

- (void)onClickSpace {
    if (self.onClickChar) {
        self.onClickChar(KeySpace, nil);
    }
}

- (NSMutableArray*)arrayLetters {
    if (!_arrayLetters) {
        _arrayLetters = [NSMutableArray new];
    }
    return _arrayLetters;
}

@end

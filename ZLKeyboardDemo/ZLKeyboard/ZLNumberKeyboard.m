//
//  ZLNumberKeyboard.m
//  ZLKeyboardDemo
//
//  Created by zhaoliang chen on 2018/7/19.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import "ZLNumberKeyboard.h"
#import "Masonry.h"

@interface ZLNumberKeyboard()

@property(nonatomic,strong)NSArray* arrayNumber;

@end

@implementation ZLNumberKeyboard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        [self initialize];
        
        [self setupKeyboard];
    }
    return self;
}

- (void)initialize {
    self.arrayNumber = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
}

- (void)setupKeyboard {
    UIButton* temp = nil;
    NSMutableArray* array = [NSMutableArray new];
    for (int i=0; i<9; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"key_num_pressed"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"key_num_normal"] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitle:self.arrayNumber[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onClickNumber:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [array addObject:btn];
        if (i%3==2) {
            [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
            [array mas_makeConstraints:^(MASConstraintMaker *make) {
                if (temp == nil) {
                    make.top.mas_equalTo(0);
                } else {
                    make.top.mas_equalTo(temp.mas_bottom);
                }
                make.height.mas_equalTo(self).multipliedBy(0.25);
            }];
            temp = btn;
            array = [NSMutableArray new];
        }
    }
    for (int i=0; i<3; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"key_num_pressed"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"key_num_normal"] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (i==0) {
            btn.tag = 10;
            [btn setTitle:@"ABC" forState:UIControlStateNormal];
        } else if (i==1) {
            btn.tag = 9;
            [btn setTitle:@"0" forState:UIControlStateNormal];
        } else if (i==2) {
            btn.tag = 11;
            [btn setImage:[UIImage imageNamed:@"key_icon_del"] forState:UIControlStateNormal];
        }
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onClickNumber:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [array addObject:btn];
        if (i==2) {
            [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
            [array mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(temp.mas_bottom);
                make.height.mas_equalTo(self).multipliedBy(0.25);
            }];
        }
    }
}

- (void)onClickNumber:(UIButton*)btn {
    if (btn.tag < 10) {
        if (self.onClickNumber) {
            self.onClickNumber(KeyNumber, self.arrayNumber[btn.tag]);
        }
    } else if (btn.tag == 10) {
        if (self.onClickNumber) {
            self.onClickNumber(KeySwitchLetter, nil);
        }
    } else if (btn.tag == 11) {
        if (self.onClickNumber) {
            self.onClickNumber(KeyDelete, nil);
        }
    }
}

@end

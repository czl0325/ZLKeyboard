//
//  ViewController.m
//  ZLKeyboardDemo
//
//  Created by zhaoliang chen on 2018/7/18.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import "ViewController.h"
#import "ZLKeyboard.h"
#import "Masonry.h"
#import "ViewController1.h"

@interface ViewController ()
{
    UITextField* textField;
    ZLKeyboard *keyboard;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    textField = [UITextField new];
    textField.placeholder = @"点击弹出自定义键盘";
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.borderWidth = 1;
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    keyboard = [[ZLKeyboard alloc]initWithTextField:textField];
    keyboard.keyBoardLayoutStyle = KeyBoardLayoutStyleDefault;
    [ZLKeyboard bindKeyboard:textField];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ViewController1* vc1 = [[ViewController1 alloc]init];
    [self.navigationController pushViewController:vc1 animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

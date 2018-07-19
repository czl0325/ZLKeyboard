//
//  ZLKeyboard.h
//  ZLKeyboardDemo
//
//  Created by zhaoliang chen on 2018/7/18.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZLKeyBoardLayoutStyle)
{
    KeyBoardLayoutStyleDefault=-1,      //默认字母
    KeyBoardLayoutStyleNumbers=0,       //数字
    KeyBoardLayoutStyleLetters=1,       //字母
    KeyBoardLayoutStyleSymbol           //符号
};

@interface ZLKeyboard : UIView

/**
 *  键盘属性
 */
@property (nonatomic, assign) ZLKeyBoardLayoutStyle keyBoardLayoutStyle;

- (instancetype)initWithTextField:(UITextField*)textField;

- (instancetype)initWithTextView:(UITextView*)textView;

- (instancetype)initWithKeyboardType:(ZLKeyBoardLayoutStyle)type;

+ (instancetype)bindKeyboard:(UITextField*)textField;


@end

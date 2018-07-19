//
//  ZLCharKeyboard.h
//  ZLKeyboardDemo
//
//  Created by zhaoliang chen on 2018/7/18.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLKeyboardConfig.h"

@interface ZLCharKeyboard : UIView

@property(nonatomic,copy)void (^onClickChar)(ZLKeyValue key, NSString* value);

@end

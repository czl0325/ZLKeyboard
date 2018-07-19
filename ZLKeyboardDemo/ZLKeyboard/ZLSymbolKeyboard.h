//
//  ZLSymbolKeyboard.h
//  ZLKeyboardDemo
//
//  Created by zhaoliang chen on 2018/7/19.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLKeyboardConfig.h"

@interface ZLSymbolKeyboard : UIView

@property(nonatomic,copy)void (^onClickSymbol)(ZLKeyValue key, NSString* value);

@end

//
//  ZLKeyboardConfig.h
//  ZLKeyboardDemo
//
//  Created by zhaoliang chen on 2018/7/19.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#ifndef ZLKeyboardConfig_h
#define ZLKeyboardConfig_h

typedef NS_ENUM(NSInteger, ZLKeyValue)
{
    KeyLetter                   = 0,        //字母
    KeyNumber                   = 1,        //数字
    KeySymbol                   = 2,        //符号
    KeySwitchCase               = 4,        //切换大小写
    KeySwitchLetter             = 5,        //切换成字母
    KeySwitchNumber             = 6,        //切换成数字
    KeySwitchSymbol             = 7,        //切换成符号
    KeyDelete                   = 8,        //删除按钮
    KeySpace                    = 9,        //空格按钮
};

#define TopBottomMargin 4


#endif /* ZLKeyboardConfig_h */

//
//  ZZIQKeyBoard.m
//  萌宝派
//
//  Created by charles on 15/8/12.
//  Copyright (c) 2015年 shanghaizhizhen. All rights reserved.
//

#import "ZZIQKeyBoard.h"
#import "IQKeyboardManager.h"

@interface ZZIQKeyBoard ()
@property(nonatomic ,strong)IQKeyboardManager *manager;
@end
@implementation ZZIQKeyBoard

+(void)load{
    [super load];
   [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
singleton_implementation(ZZIQKeyBoard);
-(IQKeyboardManager *)manager{
    if (!_manager) {
        _manager = [IQKeyboardManager sharedManager];
        _manager.enable = NO;
        _manager.shouldResignOnTouchOutside = YES;
        _manager.shouldToolbarUsesTextFieldTintColor = YES;
        _manager.enableAutoToolbar = YES;
    }
    return _manager;
}
-(void)disOpenWithKeyBoard{
    /**
     *  键盘三方
     */
    self.manager.enable = NO;
    self.manager.enableAutoToolbar = NO;
}

-(void)openWithKeyBoard{
    
    self.manager.enable = YES;
    self.manager.enableAutoToolbar = YES;
}
/**
 *  出现箭头切换
 */
-(void)arrowSwitchIQKeyBoard{

    
}
@end

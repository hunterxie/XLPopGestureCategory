//
//  UINavigationController+XLPopGesture.h
//  PatchBoard
//
//  Created by xll on 2017/7/12.
//  Copyright © 2017年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (XLPopGesture)
//在当前控制器viewDidLoad内写  可以控制当前控制器是否可以侧滑   默认是开启的 要想默认关闭
@property(nonatomic,assign)BOOL enablePopGest;
@end



@interface UINavigationController (XLPopGesture)

@property(nonatomic)BOOL enableInteractivePopGest;

@end

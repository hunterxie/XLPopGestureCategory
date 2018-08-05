//
//  UINavigationController+XLPopGesture.m
//  PatchBoard
//
//  Created by xll on 2017/7/12.
//  Copyright © 2017年 teason. All rights reserved.
//

#import "UINavigationController+XLPopGesture.h"
#import <objc/runtime.h>


static void ExchangedMethod(SEL originalSelector, SEL swizzledSelector, Class class) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark    实现控制器的类别扩展
static char vcEnablePop_AssociateKey;
static char vcStatus_AssociateKey;
@interface UIViewController()
@property(nonatomic,copy)NSString *isSetPop;//如果未设置过  默认是开启侧滑的 如果用户设置过当前控制器  就会以用户设置的为准
@end

@implementation UIViewController(XLPopGesture)


+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        ExchangedMethod(@selector(viewWillDisappear:), @selector(s_viewWillDisappear:), class);
        ExchangedMethod(@selector(viewDidDisappear:), @selector(s_viewDidDisappear:), class);
        ExchangedMethod(@selector(viewDidAppear:), @selector(s_viewDidAppear:), class);
    });
}


-(void)s_viewDidLoad
{
    [self s_viewDidLoad];
    self.enablePopGest = YES;
}
-(void)s_viewWillDisappear:(BOOL)animated
{
    [self s_viewWillDisappear:animated];
    self.navigationController.enableInteractivePopGest = YES;
}
-(void)s_viewDidDisappear:(BOOL)animated
{
    [self s_viewDidDisappear:animated];
    self.navigationController.enableInteractivePopGest = YES;
}
-(void)s_viewDidAppear:(BOOL)animated
{
    [self s_viewDidAppear:animated];
    if (self.isSetPop && [self.isSetPop isEqualToString:@"1"]) {
        self.navigationController.enableInteractivePopGest = self.enablePopGest;
    }
    else
    {
        self.navigationController.enableInteractivePopGest = YES;
    }
}
-(void)setEnablePopGest:(BOOL)enablePopGest
{
    objc_setAssociatedObject(self, &vcEnablePop_AssociateKey, @(enablePopGest), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.isSetPop = @"1";
}
-(BOOL)enablePopGest
{
    return [objc_getAssociatedObject(self, &vcEnablePop_AssociateKey) boolValue];
}
-(void)setIsSetPop:(NSString *)isSetPop
{
    objc_setAssociatedObject(self, &vcStatus_AssociateKey, isSetPop, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)isSetPop
{
    return objc_getAssociatedObject(self, &vcStatus_AssociateKey);
}
@end

#pragma mark    实现导航的类别扩展
static char currentVC_AssociateKey;
static char enablePopGest_AssociateKey;
@interface UINavigationController()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property(nonatomic,weak)UIViewController* currentShowVC;



@end

@implementation UINavigationController (XLPopGesture)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        ExchangedMethod(@selector(viewDidLoad), @selector(s_viewDidLoad), class);
        ExchangedMethod(@selector(pushViewController:animated:), @selector(s_pushViewController:animated:), class);
    });
}
-(void)s_viewDidLoad
{
    [self s_viewDidLoad];
    
    self.enableInteractivePopGest = YES;
    
    self.delegate = self;
    
    self.interactivePopGestureRecognizer.delegate = self;
}
-(void)s_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
     [self s_pushViewController:viewController animated:animated];
    // fix 'nested pop animation can result in corrupted navigation bar'
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}
#pragma mark - UINavigationController Delegate
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 1)
    {
        self.currentShowVC = nil;
    }
    else
    {
        self.currentShowVC = viewController;
    }
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
#pragma mark - UIGestureRecognizer Delegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController && self.enableInteractivePopGest); //the most important
    }
    return YES;
}

#pragma mark  get set方法

-(void)setCurrentShowVC:(UIViewController *)currentShowVC
{
    objc_setAssociatedObject(self, &currentVC_AssociateKey, currentShowVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIViewController *)currentShowVC
{
   return  objc_getAssociatedObject(self, &currentVC_AssociateKey);
}
-(void)setEnableInteractivePopGest:(BOOL)enableInteractivePopGest
{
    objc_setAssociatedObject(self, &enablePopGest_AssociateKey, @(enableInteractivePopGest), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)enableInteractivePopGest
{
    return [objc_getAssociatedObject(self, &enablePopGest_AssociateKey) boolValue];
}

@end

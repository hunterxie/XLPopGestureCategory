//
//  SecViewController.m
//  XLPopGestureDemo
//
//  Created by xll on 2018/8/5.
//  Copyright © 2018年 xll. All rights reserved.
//

#import "SecViewController.h"
#import "UINavigationController+XLPopGesture.h"
@interface SecViewController ()

@end

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.enablePopGest = NO;//不允许侧滑
    self.enablePopGest = YES;//允许侧滑
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

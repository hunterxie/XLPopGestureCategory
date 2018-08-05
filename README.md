# XLPopGestureCategory
一行代码关闭当前页面系统侧滑，不影响其他页面，同时解决了系统侧滑功能在开关过程中出现卡主问题<br>
孙源大神FDFullscreenPopGesture的这个库能够完美解决导航侧滑问题，本人更喜欢使用系统的边缘侧滑，更加流畅。
```
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.enablePopGest = NO;//不允许侧滑
    self.enablePopGest = YES;//允许侧滑
    // Do any additional setup after loading the view.
}
```
完毕~

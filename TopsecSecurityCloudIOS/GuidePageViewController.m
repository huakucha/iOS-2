//
//  GuidePageViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/9/22.
//  Copyright © 2016年 topsec. All rights reserved.
//  安全云服务平台

#import "GuidePageViewController.h"
#import "TopsecGuideUntil.h"
#import "TSCLoginViewController.h"

@interface GuidePageViewController ()<TopsecGuideUntilDelegate>
@property  TopsecGuideUntil  *introView;

@end

@implementation GuidePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.introView = [[TopsecGuideUntil alloc] initWithFrame:self.view.frame];
    self.introView.delegate = self;
    self.introView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.introView];
}


#pragma mark - ABCIntroViewDelegate Methods

-(void)onDoneButtonPressed{
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
#pragma mark  增加取消进入引导页标示
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:true forKey:@"loginfirst"];//先默认都启动引导页
    [userDefaults synchronize];
    
#pragma make 主界面
        TSCLoginViewController *homeview = [[TSCLoginViewController alloc]init];
        [self presentViewController:homeview animated:NO completion:nil];
        //[self.introView removeFromSuperview];
    }];
}



@end

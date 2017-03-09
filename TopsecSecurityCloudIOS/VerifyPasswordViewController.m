//
//  VerifyPasswordViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/10/10.
//  Copyright © 2016年 topsec. All rights reserved.
//  密码验证界面

#import "VerifyPasswordViewController.h"
#import "NumLockViewController.h"

@interface VerifyPasswordViewController ()

@end

@implementation VerifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //接收通知操作
    //通知用于改变 rootController
  //  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeClick) name:@"SwitchRnootVCNotificatio" object:nil];
    //进入到显示密码验证界面
    NumLockViewController * numLockv = [[NumLockViewController alloc]init];
    [self presentViewController:numLockv animated:YES completion:nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)removeClick
//{
    
  //  [self.view removeFromSuperview];

//}
@end

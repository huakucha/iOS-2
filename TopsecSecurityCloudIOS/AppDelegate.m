//
//  AppDelegate.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/8/9.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "AppDelegate.h"
//自定义广告启动页
#import "SplashScreen.h"
//第一次登陆进入引导页界面
#import "GuidePageViewController.h"
//密码验证界面
#import "NumLockViewController.h"
//登陆界面
#import "TSCLoginViewController.h"
#import "FirstViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
     [UIApplication sharedApplication].statusBarHidden = NO;
       [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
#pragma 判断是否是第一次登陆
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    //沙盒中 Boolean 值默认为 false
#pragma 验证流程  先验证是否第一次登陆  再验证是否开启应用锁  最后验证是否开启广告界面
    Boolean  loginFirst = [userDefault boolForKey:@"loginfirst"];     //判断是否是第一次登陆
    NSString * lockpassword = [userDefault objectForKey:@"numberPasswordValueKey"];
    //NSString * lockswitch =[userDefault objectForKey:@"numberPasswordStateKey"]; //判断是否开启应用锁
    NSNumber * num = [userDefault objectForKey:@"numberPasswordStateKey"];
    BOOL show = [num boolValue];
    //Boolean  advertiSing = [userDefault boolForKey:@"advertising"];   //判断是否开启广告界面
    //首次安装或第一次登陆 loginFirst 默认为 false；
    if(loginFirst){
        
        if(show&&lockpassword.length==4){//进入密码验证界面
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:true forKey:@"intopassword"];//先默认都启动引导页
            [userDefaults synchronize];
            self.window.rootViewController = [[NumLockViewController alloc]init];
            //self.window.rootViewController=[[FirstViewController alloc]init];
            
            
            [self.window makeKeyAndVisible];
            
            
        }else{
            NSLog(@"不是第一次登陆");
            NSLog(@"本地密码%@",lockpassword);
            self.window.rootViewController = [[TSCLoginViewController alloc] init];
            //self.window.rootViewController=[[FirstViewController alloc]init];
            
        }
        
    }else{
        NSLog(@"第一次登陆");//进入引导页及使用界面
        self.window.rootViewController = [[GuidePageViewController alloc]init];
    }
    
    
    
    
    
#pragma 进入广告启动页界面
#pragma 进入引导页界面
#pragma 进入登陆界面
#pragma 进入密码输入界面
    
    //通知用于改变  作用是判断通过点击app进入后 如果开启密码验证
    //密码界面验证通过后进入登陆界面
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeClick) name:@"SwitchRnootVCNotificatio" object:nil];
    
    return YES;
}
-(void)removeClick
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:false forKey:@"intopassword"];//先默认都启动引导页
    [userDefaults synchronize];
    
    self.window.rootViewController = [[TSCLoginViewController alloc] init];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    //当按下home键 执行流程
    //applicationWillResignActive -> applicationDidEnterBackground
    //判断是否开启应用锁
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * num = [defaults objectForKey:@"numberPasswordStateKey"];
    BOOL show = [num boolValue];
    NSString * lockpassword = [defaults objectForKey:@"numberPasswordValueKey"];
    if(show&&lockpassword.length==4){
#pragma mark 关闭键盘
        [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
        self.window.rootViewController = [[NumLockViewController alloc]init];
        [self.window makeKeyAndVisible];
        
    }
    
    
    
    
    //NumLockViewController *verifypassword = [[NumLockViewController alloc]init];
    //[self.window addSubview:verifypassword.view];
    //[self.window.screen. presentViewController:verifypassword animated:YES completion:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   // exit(0);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
}

@end

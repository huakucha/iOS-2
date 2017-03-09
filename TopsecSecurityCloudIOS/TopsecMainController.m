//
//  TopsecMainController.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/9/28.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "TopsecMainController.h"
#import "SplashScreen.h"
#import "UIImage+MRExtension.h"
#import "MRNavigationController.h"
#import "LockViewController.h"
#import "FirstViewController.h"
//我的界面
#import "MySettingInfoController.h"
//首页
#import "HomepageController.h"
//重点关注
#import "ImportentTasklistViewController.h"
// 全局主题颜色
#define MRGlobalBg MRRGBColor(245, 80, 83)
@interface TopsecMainController ()<UITabBarDelegate>

@end

@implementation TopsecMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子控制器
    [self addChildController:[[ FirstViewController alloc] init] imageName:@"TabBar_home_23x23_" selectedImage:@"TabBar_home_23x23_selected" title:@"首页"];
    
    [self addChildController:[[ImportentTasklistViewController alloc] init] imageName:@"TabBar_gift_23x23_" selectedImage:@"TabBar_gift_23x23_selected" title:@"云安全新闻动态"];
    
    //[self addChildController:[[SplashScreen alloc] init] imageName:@"TabBar_category_23x23_" selectedImage:@"TabBar_category_23x23_selected" title:@"报警任务"];
    
    [self addChildController:[[MySettingInfoController alloc] init] imageName:@"TabBar_me_boy_23x23_" selectedImage:@"TabBar_me_boy_23x23_selected" title:@"我的"];
    
}


/**
 *	@brief	设置TabBarItem主题
 */

+ (void)initialize {
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:245/255.0f green:80/255.0f blue:83/255.0f alpha:1];
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
}

/**
 *	@brief	添加子控制器
 *
 *	@param 	childVC 	子控制期器
 *	@param 	imageName 	默认图片
 *	@param 	selectedName 	选中图片
 *	@param 	title 	标题
 */
- (void)addChildController:(UIViewController *)childVC imageName:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    
    // 设置文字和图片
    childVC.title = title;
    childVC.tabBarItem.image = [UIImage mr_imageOriginalWithName:image];
    childVC.tabBarItem.selectedImage = [UIImage mr_imageOriginalWithName:selectedImage];
    
    // 包装一个导航控制器，添加导航控制器为tabBarController的子控制器
    MRNavigationController *nav = [[MRNavigationController alloc] initWithRootViewController:childVC];
    
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end

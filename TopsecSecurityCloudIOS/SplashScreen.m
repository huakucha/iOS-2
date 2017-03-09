//
//  SplashScreen.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/9/21.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "SplashScreen.h"
@interface SplashScreen ()

@end

@implementation SplashScreen
@synthesize advertisingImage;
@synthesize bottomViewContent;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*
     广告位置占屏幕3/4 底部为固定位置1/4
     */
    
    advertisingImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height/4)*3)];
    advertisingImage.backgroundColor = [UIColor whiteColor];
    
    bottomViewContent = [[UIView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height/4)*3, self.view.frame.size.width, self.view.frame.size.height/4)];
    
    
#pragma mark 把控件增加到view中
    [self.view addSubview:advertisingImage];
    [self.view addSubview:bottomViewContent];
    UILabel *appLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];


    
    
    
    
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

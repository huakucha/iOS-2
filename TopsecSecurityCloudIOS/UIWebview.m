//
//  UIWebview.m
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 2016/11/28.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "UIWebview.h"

@interface UIWebview ()<UIWebViewDelegate>

@end

@implementation UIWebview

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView * webview = [[UIWebView alloc]initWithFrame:self.view.frame];
    webview.delegate = self;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.10.10.101:8088/main/ErrorIndex.html"]]];
    [self.view addSubview:webview];
    webview.scalesPageToFit = YES;
    
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

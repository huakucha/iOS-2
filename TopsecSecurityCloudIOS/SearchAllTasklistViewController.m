//
//  SearchAllTasklistViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 16/11/3.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "SearchAllTasklistViewController.h"
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface SearchAllTasklistViewController ()

@end

@implementation SearchAllTasklistViewController
@synthesize typebutton;
@synthesize typetext;
- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏navigationBar 隐藏头部标题
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
#pragma mark 类别view
    UIView  *searchview = [[UIView alloc]initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, (self.view.frame.size.height)/16)];
    [self.view addSubview:searchview];
    //title
    UILabel *titleType = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3, (self.view.frame.size.height)/16)];
    titleType.text = @"监测类型:";
    titleType.textColor = [UIColor grayColor];
    titleType.textAlignment = NSTextAlignmentCenter;
    [searchview addSubview:titleType];
    //button
    typebutton  = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3+5, 0, (self.view.frame.size.width/3)*2-10, ((self.view.frame.size.height)/16))];
    typebutton.text = @"全部任务";
    typebutton.textAlignment = NSTextAlignmentCenter;
    typebutton.backgroundColor = [UIColor whiteColor];
    typebutton.layer.borderColor = [UIColor colorWithRed:250/255.0f green:167/255.0f blue:28/255.0f alpha:1].CGColor;
    [searchview addSubview:typebutton];
    typebutton.layer.cornerRadius = 5;
    typebutton.layer.borderWidth = 1;
    //image
    int xzhou = (self.view.frame.size.width-5) - (self.view.frame.size.height)/16;
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(xzhou, 0, (self.view.frame.size.height)/16, (self.view.frame.size.height)/16)];
    [image setImage:[UIImage imageNamed:@"drow_down_jiantou"]];
    [searchview addSubview:image];
    
#pragma mark 名称name
    UIView  *searchviewtwo = [[UIView alloc]initWithFrame:CGRectMake(0, 110+((self.view.frame.size.height)/16), self.view.frame.size.width, (self.view.frame.size.height)/16)];
    [self.view addSubview:searchviewtwo];
    //title
    UILabel *titleTypename = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3, (self.view.frame.size.height)/16)];
    titleTypename.text = @"任务名称:";
    titleTypename.textColor = [UIColor grayColor];
    titleTypename.textAlignment = NSTextAlignmentCenter;
    [searchviewtwo addSubview:titleTypename];
    //输入内容
    typetext = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3+5, 0, (self.view.frame.size.width/3)*2-10, ((self.view.frame.size.height)/16))];
    [searchviewtwo addSubview:typetext];
    typetext.backgroundColor=[UIColor whiteColor]; //背景色
    //设置边框宽度
    typetext.layer.borderWidth = 1.0;
    //设置边框颜色
    typetext.layer.borderColor = [UIColor colorWithRed:250/255.0f green:167/255.0f blue:28/255.0f alpha:1].CGColor;
    //设置圆角
    typetext.layer.cornerRadius = 5.0;
    
#pragma mark 查询按钮
   UIButton *_safeExitButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 100+((self.view.frame.size.height)/2), self.view.frame.size.width-40,  38)];
    _safeExitButton.backgroundColor = [UIColor colorWithRed:250/255.0f green:167/255.0f blue:28/255.0f alpha:1];
    [_safeExitButton setTitle:@"查     询" forState:UIControlStateNormal];
    [_safeExitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_safeExitButton.layer setCornerRadius:2.0]; //设置矩形四个圆角半径
    _safeExitButton.layer.borderWidth =5.0;
    _safeExitButton.layer.borderColor = [UIColor colorWithRed:250/255.0f green:167/255.0f blue:28/255.0f alpha:1].CGColor;
    //增加点击事件
    //[_safeExitButton addTarget:self action:@selector(exitClickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_safeExitButton];

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

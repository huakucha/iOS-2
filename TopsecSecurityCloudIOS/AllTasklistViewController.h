//
//  AllTasklistViewController.h
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 16/11/3.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllTasklistViewController : UIViewController
@property(nonatomic,strong)UIImageView      *Topbg;//1/9
@property(nonatomic,strong)UIImageView      *backbg;
@property(nonatomic,strong)UILabel          *Toptext;
//查询按钮
@property(nonatomic,strong)UIImageView      *searchImage;
#pragma mark 主体控件
@property (nonatomic,strong ) UITableView *tableView;
@end

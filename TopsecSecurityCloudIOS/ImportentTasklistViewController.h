//
//  ImportentTasklistViewController.h
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 16/11/2.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImportentTasklistViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
#pragma mark 主体控件
@property (nonatomic,strong ) UITableView *tableView;
@end

//
//  FirstViewController.h
//  TopsecSecurityCloudIOS
//
//  Created by topsec on 17/2/8.
//  Copyright © 2017年 topsec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * Roottabveiw;
@property (nonatomic,strong) UICollectionView * collectionView;
@end

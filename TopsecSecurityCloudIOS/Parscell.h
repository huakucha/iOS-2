//
//  Parscell.h
//  TopsecSecurityCloudIOS
//
//  Created by topsec on 17/1/16.
//  Copyright © 2017年 topsec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entity+CoreDataClass.h"
@interface Parscell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TaskidLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLable;
@property (weak, nonatomic) IBOutlet UIImageView *IconImage;
@property (weak, nonatomic) IBOutlet UILabel *BeforLable;
@property (weak, nonatomic) IBOutlet UILabel *AddrssLable;
@property(nonatomic,strong)  Entity * tg;
@end

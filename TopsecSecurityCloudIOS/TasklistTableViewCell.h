//
//  TasklistTableViewCell.h
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 16/11/2.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TasklistCellData.h"
@interface TasklistTableViewCell : UITableViewCell
@property (strong ,nonatomic) TasklistCellData *data;
@property (strong, nonatomic) IBOutlet UIImageView *cellbg;    //背景
@property (strong, nonatomic) IBOutlet UIImageView *imageType;
@property (strong, nonatomic) IBOutlet UILabel *taskName;
@property (strong, nonatomic) IBOutlet UILabel *taskContent;
@property (strong, nonatomic) IBOutlet UILabel *lableTime;
@property (strong, nonatomic) IBOutlet UILabel *lableTimeafter;






@end

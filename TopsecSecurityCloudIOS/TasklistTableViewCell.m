//
//  TasklistTableViewCell.m
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 16/11/2.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "TasklistTableViewCell.h"

@implementation TasklistTableViewCell

-(void)setData:(TasklistCellData *)data{
    _data =data;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

//
//  Parscell.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec on 17/1/16.
//  Copyright © 2017年 topsec. All rights reserved.
//

#import "Parscell.h"

@implementation Parscell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTg:(Entity *)tg{
    
    //1. 给成员属性赋值
    _tg = tg;
    self.TaskidLabel.text=tg.uuid;
    self.TaskidLabel.numberOfLines=0;
    self.AddrssLable.text=tg.tasktage;
    //2.更改控件中的内容
    //2.1 图片
    
    
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  LxjPopMenuitem.h
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 16/11/2.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PopMenuItemWidth            70.0f
#define PopMenuItemHeight           (PopMenuItemWidth + 25)
@interface LxjPopMenuitem : UIControl

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, strong) UIImage  *icon;
@property (nonatomic, strong) UIColor  *textColor;

@property (nonatomic, assign) CGFloat animationTime;

+ (instancetype)item;
+ (instancetype)itemWithTitle:(NSString*)title image:(UIImage*)image;
@end


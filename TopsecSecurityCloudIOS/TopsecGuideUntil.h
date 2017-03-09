//
//  TopsecGuideUntil.h
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/9/23.
//  Copyright © 2016年 topsec. All rights reserved.
//  安全云服务器平台

#import <UIKit/UIKit.h>

@protocol TopsecGuideUntilDelegate <NSObject>

-(void)onDoneButtonPressed;

@end

@interface TopsecGuideUntil : UIView
@property id<TopsecGuideUntilDelegate> delegate;

@end

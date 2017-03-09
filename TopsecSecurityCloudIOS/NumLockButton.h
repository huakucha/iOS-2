//
//  NumLockButton.h
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/10/10.
//  Copyright © 2016年 topsec. All rights reserved.
//  密码验证界面

#import <UIKit/UIKit.h>

@interface NumLockButton : UIButton

@property (nonatomic, readonly, assign) NSUInteger number;
@property (nonatomic, readonly, copy) NSString *letters;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *lettersLabel;

@property (nonatomic, strong) UIColor *backgroundColorBackup;
- (instancetype)initWithNumber:(NSUInteger)number letters:(NSString *)letters;

@end

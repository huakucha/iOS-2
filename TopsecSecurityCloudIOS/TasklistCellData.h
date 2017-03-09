//
//  TasklistCellData.h
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 16/11/2.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TasklistCellData : NSObject
@property(nonatomic,strong) NSNumber * history;
@property(nonatomic,strong) NSNumber * status;

@property(nonatomic,strong) NSString * defName;
@property(nonatomic,strong) NSString * groupId;
@property(nonatomic,strong) NSString * uuid;
@property(nonatomic,strong) NSString * displayName;
@property(nonatomic,strong) NSString * defIcon;
@property(nonatomic,strong) NSString * ip;


/**
 *  初始化当前模型对象的类方法
 *
 *  @param dict 传入一个字典数据
 *
 *  @return 返回当前模型对象
 */
+ (instancetype)tgWithDict:(NSDictionary *)dict;


+ (NSArray *)tgWitharry:(NSArray *)myarry;
@end

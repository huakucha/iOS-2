//
//  TasklistCellData.m
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 16/11/2.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "TasklistCellData.h"

@implementation TasklistCellData
-(instancetype)initWithDict:(NSDictionary *)dict{
    
    //1.初始化对象
    self = [super init];
    //2.判断对象是否为nil
    if (self) {
        //3.字典转模型
        [self setValuesForKeysWithDictionary:dict];
    }
    //4.返回数据
    return self;
    
}


/**
 *  初始化当前模型对象的类方法
 *
 *  @param dict 传入一个字典数据
 *
 *  @return 返回当前模型对象
 */
+ (instancetype)tgWithDict:(NSDictionary *)dict{
    //调用上面实例化的初始化方法,传入字典数据
    return [[self alloc]initWithDict:dict];
}



+(instancetype)tgWitharry:(NSArray *)myarry{
    
    
    //3. 创建临时数组
    NSMutableArray* nmArray = [NSMutableArray array];
    
    //4.遍历字典数组
    for (NSDictionary *dict in myarry) {
        //5.往可变数组中添加一个模型类
        [nmArray addObject:[self tgWithDict:dict]];
    }
    
    //6.返回存放模型对象的数组
    return nmArray;
    
    
}

@end

//
//  VarintUtil.h
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/9/7.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VarintUtil : NSObject

-(NSMutableData*)writeVarintData:(NSData*) orgData;

-(NSData*)readVarintData:(NSData *)varintData;
@end

//
//  ProtobufUtil.h
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/9/7.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPBProtocolBuffers.h"
#import "VarintUtil.h"
#import "CoreProto.pbobjc.h"
@interface ProtobufUtil : NSObject

-(GPBAny*)pack : (GPBMessage *)msg;

-(NSMutableData*)protobuf2VarintData : (GPBMessage *)msg;

-(ServerMessage *)varintData2ServerMessage : (NSData* )data;

@end

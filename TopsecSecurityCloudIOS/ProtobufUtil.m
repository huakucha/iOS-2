//
//  ProtobufUtil.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/9/7.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "ProtobufUtil.h"
#import "TopsecCorephoto.pbobjc.h"

@implementation ProtobufUtil


-(GPBAny*)pack : (GPBMessage *)msg {
    
    NSData* nsdata=[msg data];
    
    GPBAny* any =[[GPBAny alloc] init];
    
    any.value=nsdata;
    any.typeURL=[NSString stringWithFormat:@"type.googleapis.com/%@",[msg descriptor].name];
    
    return any;
    
}


-(NSMutableData*)protobuf2VarintData : (GPBMessage *)msg{
    
    VarintUtil* varintUtil=[[VarintUtil alloc]init];
    return [varintUtil writeVarintData:[msg data]];
}


-(TopsecServerMessage *)varintData2ServerMessage : (NSData* )data{
    
    VarintUtil* varintUtil=[[VarintUtil alloc]init];
    
    NSData* orgData=[varintUtil readVarintData:data];
    
    TopsecServerMessage * serverMsg =[TopsecServerMessage parseFromData:orgData error:nil];
    return serverMsg;
}


//    [da ap]

//    NSMutableData * da66 =da;


@end

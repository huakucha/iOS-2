//
//  SocketClient.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/9/7.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "SocketClient.h"

@implementation SocketClient


-(void)OpenSocketClienr:(id)socketDelegt onIp:(NSString*)topscip onPort:(UInt16)port{
    //self.socketclient = [[AsyncSocket alloc]initWithDelegate:self];
    //[self.socketclient connectToHost:topscip onPort:port error:nil];//服务器地址链接
    //self.socketclient.delegate = self;
}

-(void)SendSocketClienr:(GPBMessage*)messageBody{
    ProtobufUtil *protoUtil=[[ProtobufUtil alloc]init];
    NSLog(@"要传送的值:%@",messageBody);
    [self.socketclient writeData:[protoUtil protobuf2VarintData:messageBody] withTimeout:10.0f tag:101];
    [self.socketclient readDataWithTimeout:-1 tag:0];

}



@end

//
//  SocketClient.h
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/9/7.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "GPBProtocolBuffers.h"
#import "AsyncSocket.h"
#import "ProtobufUtil.h"
@interface SocketClient : NSObject
@property(nonatomic,retain) AsyncSocket *socketclient;

//打开socket
-(void)OpenSocketClienr:(id)socketDelegt onIp:(NSString*)topscip onPort:(UInt16)port;
//发送数据
-(void)SendSocketClienr:(GPBMessage*)messageBody;
@end

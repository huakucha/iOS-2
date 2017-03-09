//
//  ViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/8/9.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "CoreProto.pbobjc.h"
#import "VarintUtil.h"

#import "FooProto.pbobjc.h"
#import "AsyncSocket.h"
#import "SocketClient.h"
#import "ProtobufUtil.h"
#import "GCDAsyncSocket.h"
@interface ViewController ()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *_sslSocket;
}
//定义变量
@property(nonatomic,retain) NSTimer *heartTimer;
@property(nonatomic,retain) AsyncSocket *ay;
@property(nonatomic,retain) IBOutlet UITextField *msgTF;
@property(nonatomic,retain) IBOutlet UITextView *showTV;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     socket 建立
     */
    _sslSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //http 80
    //https 443
    [_sslSocket connectToHost:@"10.10.10.101" onPort:8101 error:nil];
}



#pragma 内存溢出处理
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"TCP链接成功建立 %@:%d", host, port);
    
    // 配置 SSL/TLS 设置信息
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
    //允许自签名证书手动验证
    [settings setObject:@YES forKey:GCDAsyncSocketManuallyEvaluateTrust];
    //GCDAsyncSocketSSLPeerName
    [settings setObject:@"mbpserverv1" forKey:GCDAsyncSocketSSLPeerName];
#pragma mark - p12
    
    NSData *pkcs12data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mbp-clientv1" ofType:@"p12"]];
    CFDataRef inPKCS12Data = (CFDataRef)CFBridgingRetain(pkcs12data);
    CFStringRef password = CFSTR("N92pnxhDj52S1r");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import(inPKCS12Data, options, &items);
    CFRelease(options);
    CFRelease(password);
    
    if(securityError == errSecSuccess)
        NSLog(@"Success opening p12 certificate.");
    
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef myIdent = (SecIdentityRef)CFDictionaryGetValue(identityDict,
                                                                  kSecImportItemIdentity);
    
    SecIdentityRef  certArray[1] = { myIdent };
    CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
    
    [settings setObject:(id)CFBridgingRelease(myCerts) forKey:(NSString *)kCFStreamSSLCertificates];
    //[settings setObject:NSStreamSocketSecurityLevelNegotiatedSSL forKey:(NSString *)kCFStreamSSLLevel];
    //[settings setObject:(id)kCFBooleanTrue forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
    //[settings setObject:@"CONNECTION ADDRESS" forKey:(NSString *)kCFStreamSSLPeerName];
    
#pragma mark 后台验证
    // 如果不是自签名证书，而是那种权威证书颁发机构注册申请的证书
    // 那么这个settings字典可不传。
    [sock startTLS:settings]; // 开始SSL握手
    
}
- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust
completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler{
    //服务器自签名证书:
    //openssl req -new -x509 -nodes -days 365 -newkey rsa:1024  -out tv.diveinedu.com.crt -keyout tv.diveinedu.com.key
    //Mac平台API(SecCertificateCreateWithData函数)需要der格式证书，分发到终端后需要转换一下
    //openssl x509 -outform der -in tv.diveinedu.com.crt -out tv.diveinedu.com.der
    NSString *certFilePath1 = [[NSBundle mainBundle] pathForResource:@"mbp-serverv1" ofType:@"cer"];
    NSData *certData1 = [NSData dataWithContentsOfFile:certFilePath1];
    
    OSStatus status = -1;
    SecTrustResultType result = kSecTrustResultDeny;
    
    if(certData1)
    {
        SecCertificateRef   cert1;
        cert1 = SecCertificateCreateWithData(NULL, (__bridge_retained CFDataRef) certData1);
        // 设置证书用于验证
        SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)[NSArray arrayWithObject:(__bridge id)cert1]);
        // 验证服务器证书和本地证书是否匹配
        status = SecTrustEvaluate(trust, &result);
    }
    else
    {
        NSLog(@"local certificates could not be loaded");
        completionHandler(NO);
    }
    
    if ((status == noErr && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified)))
    {
        //成功通过验证，证书可信
        completionHandler(YES);
    }
    else
    {
        CFArrayRef arrayRefTrust = SecTrustCopyProperties(trust);
        NSLog(@"error in connection occured\n%@", arrayRefTrust);
        completionHandler(NO);
    }
    
    
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock{
    
    NSLog(@"SSL握手成功，安全通信已经建立连接");
    
#pragma CoreProto.proto
    MobileMessage * mobileMessage= [[MobileMessage alloc]init];
    mobileMessage.version =1;
    mobileMessage.type =2;
    mobileMessage.mobileId=@"3";
    mobileMessage.mobileToken =@"666";
    
    //前提要实现嵌套类的必要属性
    FooUuid * fooUuid = [[FooUuid alloc]init];
    fooUuid.uuid=@"hello";
    
    FooMessage1 * fooMessage1=[[FooMessage1 alloc]init];
    fooMessage1.uuid =fooUuid;
    fooMessage1.username =@"xiaohong";
    fooMessage1.password=@"8888888";
    fooMessage1.sex =1;
    NSLog(@"ggggggg%@",fooMessage1);
    
    FooMessage2 *fooMessage2 = [[FooMessage2 alloc]init];
    fooMessage2.uuid =fooUuid;
    fooMessage2.html =@"httpios";
    
#pragma 压缩二进制
    ProtobufUtil *protoUtil=[[ProtobufUtil alloc]init];
    [mobileMessage.payloadArray addObject: [protoUtil pack: fooMessage1 ]];
    [mobileMessage.payloadArray addObject: [protoUtil pack: fooMessage2 ]];
    /*
     #pragma socket建立
     //建立socket链接
     self.ay = [[AsyncSocket alloc]initWithDelegate:self];
     [self.ay connectToHost:@"10.10.10.119" onPort:8101 error:nil];//服务器地址链接
     self.ay.delegate = self;
     
     #pragma socket发送
     [self.ay writeData:[protoUtil convert2VarintData:mobileMessage] withTimeout:10.0f tag:101];
     [self.ay readDataWithTimeout:-1 tag:0];
     */
#pragma socket发送
    [sock writeData:[protoUtil protobuf2VarintData:mobileMessage] withTimeout:10.0f tag:101];
    [sock readDataWithTimeout:-1 tag:0];
    
}
//读返回数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"%@",data);
    ProtobufUtil* protobufUtil=[[ProtobufUtil alloc]init];
    NSLog(@"-------------%@",data);
    ServerMessage * mod2 =[protobufUtil varintData2ServerMessage:data];
    NSLog(@"-----------ddd--%@",mod2);
    //解压缩注意解压强转
    GPBAny * angl = mod2.payloadArray[0];
    NSData *da8 =angl.value;
    FooMessage1 *mg8 =[FooMessage1 parseFromData:da8 error:nil];
    NSLog(@"返回数据了%@",mg8);
    
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    
    NSLog(@"disconnect  err:%@",err);
}

@end

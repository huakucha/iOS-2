//
//  ImportentTasklistViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 16/11/2.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "ImportentTasklistViewController.h"
//tableview 空间信息
#import "TasklistTableViewCell.h"
#import "TasklistCellData.h"
#import "MJRefresh.h"
#import "ZJSegmentStyle.h"
#import "ZJScrollPageView.h"
#import "TestViewController.h"
#import "GCDAsyncSocket.h"
#import "AsyncSocket.h"

//protobuffer
#import "TopsecCorephoto.pbobjc.h"
#import "PhoneInformation.pbobjc.h"
#import "CmpInterface.pbobjc.h"
//转换二进制工具
#import "ProtobufUtil.h"
#import "MBProgressHUD.h"

@interface ImportentTasklistViewController ()<ZJScrollPageViewDelegate>{

GCDAsyncSocket *_sslSocket;


}
@property (nonatomic,strong) NSMutableArray  *tgArry;
@property(strong, nonatomic)NSArray<NSString *> *titles;
@property(strong, nonatomic)NSArray<UIViewController *> *childVcs;
@end

@implementation ImportentTasklistViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /*
     socket 建立
     */
    _sslSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //http 80
    //https 443
    //[_sslSocket connectToHost:@"10.10.10.101" onPort:8101 error:nil];
    [_sslSocket connectToHost:@"10.10.10.101" onPort:8101 withTimeout:10 error:nil];
    //return;
    

    
    
    
//
//    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:path];
//    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"ErrorPage"
//                                                          ofType:@"html"];
//    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
//                                                    encoding:NSUTF8StringEncoding
//                                                       error:nil];
//    [webView loadHTMLString:htmlCont baseURL:baseURL];
//    
//    
//       [self.view addSubview:webView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
    style.showLine = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    
    
    self.titles = @[@"行业资讯",
                    @"安全云",
                    @"天融信",
                    
                    ];
    

    
    
    
    
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
    
    [self.view addSubview:scrollPageView];

    
    
    
    
    
    
    
    
    
    
    
    
    
}
- (NSInteger)numberOfChildViewControllers {
    return self.titles.count;
}


- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    
    if (!childVc) {
        childVc = [[TestViewController alloc] init];
    }
    
    
    if (index%2==0) {
        childVc.view.backgroundColor = [UIColor blueColor];
    } else {
        childVc.view.backgroundColor = [UIColor greenColor];
        
    }
    
    NSLog(@"%ld-----%@",(long)index, childVc);
    
    return childVc;
}

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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)socketDidSecure:(GCDAsyncSocket *)sock{
    
    NSLog(@"SSL握手成功，安全通信已经建立连接");
    
#pragma CoreProto.proto
    TopsecMobileMessage * mobileMessage= [[TopsecMobileMessage alloc]init];
    mobileMessage.version =1;
    mobileMessage.type =1;
    mobileMessage.mobileId=@"3";
    mobileMessage.mobileToken =@"666";
    mobileMessage.whereport = @"login";
    mobileMessage.whereServer = @"news";
    
    
#pragma mark Phone_information 手机基本信息
    
    PhoneInformationRequest *phInfor = [[PhoneInformationRequest alloc]init];
    phInfor.phoneType = @"ios";
    phInfor.phoneVersion = 1;
    phInfor.longItude = @"11.11";
    phInfor.latItude  = @"22.22";
    phInfor.requestTime = @"2016-11-22";
    
    
    //    message NewsPhoneRequest{
    //        string phonegtg      = 17;
    //        string phoneNewType  = 18;
    //        int32  phonePageNo   = 19;
    //        int32  phonePageSize = 20;
    //
    //    }
    
    
    NewsPhoneRequest *news=[[NewsPhoneRequest alloc]init];
    news.phonegtg =@"哈哈";
    news.phoneNewType=@"hydt";
    news.phonePageNo=1;
    news.phonePageSize=10;
    
    
    
    
    
#pragma mark cmp_interface.proto  接口信息 首页请求登录
//    CmpPhoneLoginRequest *loginRequest = [[CmpPhoneLoginRequest alloc]init];
//    loginRequest.phoneDeviceId=@"www.baidu.com";
//    loginRequest.loginName=user.text;
//    loginRequest.loginPassword=pwd.text;
//    
    
#pragma 压缩二进制
    //把接口信息转换二进制 放入PhoneInformationRequest
    NSData* nsdatahomeRequest=[news data];
    phInfor.binaryPortInfor = nsdatahomeRequest;
    //把手机信息转换二进制 放入TopsecMobileMessage
    NSData* nsdataphInfor=[phInfor data];
    
    mobileMessage.binaryContent = nsdataphInfor;
    
    
#pragma socket发送
    ProtobufUtil *protoUtil=[[ProtobufUtil alloc]init];
    [sock writeData:[protoUtil protobuf2VarintData:mobileMessage] withTimeout:-1 tag:101];
    [sock readDataWithTimeout:-1 tag:0];
    
}
//读返回数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"返回数据%@",data);
    
    ProtobufUtil* protobufUtil=[[ProtobufUtil alloc]init];
    NSLog(@"-------------%@",data);
    TopsecServerMessage * mod2 =[protobufUtil varintData2ServerMessage:data];
    
    int version = mod2.version;
    int type    = mod2.type;
    NSString *mobileid = mod2.mobileId;
    NSString *whereport = mod2.whereport;
    
 
    
    NSLog(@"-----------+++ddd--%@",mod2);
//    //解压缩注意解压强转
//    //GPBAny * angl = mod2.payloadArray[0];
//    //NSData *da8 =angl.value;
    NewsServerPhoneResponse *mg8 =[NewsServerPhoneResponse parseFromData:mod2.binaryContent error:nil];
    NSLog(@"------------------%@",mg8);
    //    NSString *suuu = mg8.tokenId;
//    //    TopsecMainController *homeview = [[TopsecMainController alloc]init];
//    //    [self presentViewController:homeview animated:YES completion:nil];
//    if([@"成功" isEqualToString:suuu]){
//        
//        [HUD hideAnimated:YES afterDelay:0];
//        
//        TopsecMainController *homeview = [[TopsecMainController alloc]init];
//        [self presentViewController:homeview animated:YES completion:nil];
//        ProtobufUtil *protoUtil=[[ProtobufUtil alloc]init];
//        NewsPhoneRequest *news=[[NewsPhoneRequest alloc]init];
//        news.phonegtg =@"alibaba";
//        news.phoneNewType=@"hydt";
//        news.phonePageNo=1;
//        news.phonePageSize=10;
//        
//        [sock writeData:[protoUtil protobuf2VarintData:news] withTimeout:10.0f tag:101];
//        [sock readDataWithTimeout:-1 tag:0];
//        
//    }else{
//        [HUD hideAnimated:YES afterDelay:0];
//        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        HUD.removeFromSuperViewOnHide = YES;
//        HUD.mode = MBProgressHUDModeIndeterminate;
//        HUD.label.text = @"账号或密码错误";
//        HUD.minSize = CGSizeMake(132.f, 108.0f);
//        [HUD hideAnimated:YES afterDelay:0];
//        
//    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

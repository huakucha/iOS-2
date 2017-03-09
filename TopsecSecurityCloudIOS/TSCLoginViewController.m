//
//  TSCLoginViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/9/26.
//  Copyright © 2016年 topsec. All rights reserved.
//  安全云服务平台


#import "TSCLoginViewController.h"
#import "SVProgressHUD.h"
#import "TopsecMainController.h"
#import "Reachability.h"
#import "AppDelegate.h"
// 提示问题
#import "HHAlertView.h"



//网络交互
#import "GCDAsyncSocket.h"
#import "AsyncSocket.h"

//protobuffer
#import "TopsecCorephoto.pbobjc.h"
#import "PhoneInformation.pbobjc.h"
#import "CmpInterface.pbobjc.h"
//转换二进制工具
#import "ProtobufUtil.h"
#import "MBProgressHUD.h"

@interface TSCLoginViewController ()<UITextFieldDelegate,HHAlertViewDelegate,GCDAsyncSocketDelegate>
{
    UIImageView *View;
    UIView *bgView;
    UITextField *pwd;
    UITextField *user;
    MBProgressHUD *HUD;
    GCDAsyncSocket *_sslSocket;
}
@property(nonatomic,retain) NSTimer *heartTimer;
@property(nonatomic,retain) AsyncSocket *ay;


@property (nonatomic, strong) Reachability *conn;
@end

@implementation TSCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:true forKey:@"logining"];//先默认都启动引导页
    [userDefaults synchronize];
    
    
    
    //提示框
    //[[HHAlertView shared] setDelegate:self];
    // Do any additional setup after loading the view.
#pragma mark 背景
    //View=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //View.image=[UIImage imageNamed:@"bg4"];
    //[self.view addSubview:View];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0];
#pragma mark 头部
    //为了显示背景图片自定义navgationbar上面的三个按钮
    UIView *headviewbg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headviewbg.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:headviewbg];
    
    UIButton *but =[[UIButton alloc]initWithFrame:CGRectMake(5, 7, 35, 35)];
    [but setImage:[UIImage imageNamed:@"goback_back_orange_on"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clickaddBtn:) forControlEvents:UIControlEventTouchUpInside];
    //[headviewbg addSubview:but];
    
    UILabel *lanel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 44)];
    lanel.text=@"个人登录";
    lanel.textColor=[UIColor whiteColor];
    lanel.textAlignment = NSTextAlignmentCenter;
    [headviewbg addSubview:lanel];
    
#pragma mark 帐号 密码 登陆 创建
    [self createTextFields];
    [self createLoginButtons];
    
//#pragma mark 判断是否越狱  判断cydia的URL scheme
//    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]){
//        NSLog(@"The device is jail broken!");
//        //是越狱
//        
//        
//        
//    }else{
//        NSLog(@"The device is NOT jail broken!");
//        //不是越狱
//        
//    }
    
}




//创建帐号 密码 背景
-(void)createTextFields
{
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"SVProgressHUDWillAppearNotification" object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syw) name:@"SVProgressHUDDidDisappearNotification" object:nil];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.label.text = @"安全验证中";
    HUD.minSize = CGSizeMake(132.f, 108.0f);
#pragma mark 判断是否越狱  判断cydia的URL scheme
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]){
        NSLog(@"The device is jail broken!");
        //是越狱
        [HUD hideAnimated:YES afterDelay:2];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.label.text = @"设备已越狱危险";
        HUD.minSize = CGSizeMake(132.f, 108.0f);
        [HUD hideAnimated:YES afterDelay:1];
        
        
    }else{
        NSLog(@"The device is NOT jail broken!");
        //不是越狱
        [HUD hideAnimated:YES afterDelay:0];
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.label.text = @"设备安全未越狱";
        HUD.minSize = CGSizeMake(132.f, 108.0f);
        
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)]];
// 
//        
////        // 2.设定尺寸
//        effectView.frame = CGRectMake(HUD.center.x-66, HUD.center.y-54, 132.f, 108.0f);
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:effectView.bounds];
//        label.text = @"设备安全未越狱";
//        label.font = [UIFont systemFontOfSize:18.f];
//        label.textAlignment = NSTextAlignmentCenter;
//        UIVisualEffectView *subEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)effectView.effect]];
//        subEffectView.frame = effectView.bounds;
//        
//        // 将子模糊view添加到effectView的contentView才能生效
//        [effectView.contentView addSubview:subEffectView];
//        
//        // 再把要显示特效的控件添加到子模糊view上
//        [subEffectView.contentView addSubview:label];
//
//        
//        //effectView.backgroundColor= [UIColor yellowColor];
//        // 3.添加到view当中
//        [HUD addSubview:effectView];

        
        
        
        [HUD hideAnimated:YES afterDelay:1];
        
        
        
        
        
        
        
        
        
        
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
   
        
    CGRect frame=[UIScreen mainScreen].bounds;
    bgView=[[UIView alloc]initWithFrame:CGRectMake(10, 75, frame.size.width-20, 100)];
    bgView.layer.cornerRadius=3.0;
    bgView.alpha=0.7;
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    
    user=[self createTextFielfFrame:CGRectMake(60, 10, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入帐号"];
    //user.text=@"13419693608";
    //user.keyboardType=UIKeyboardTypeNumberPad;
    user.delegate = self;
    user.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    pwd=[self createTextFielfFrame:CGRectMake(60, 60, 200, 30) font:[UIFont systemFontOfSize:14]  placeholder:@"密码" ];
    pwd.delegate = self;
    pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwd.keyboardType=UIKeyboardTypeWebSearch;
    //pwd.text=@"123456";
    //密文样式
    pwd.secureTextEntry=YES;
    
    
    UIImageView *userImageView=[self createImageViewFrame:CGRectMake(20, 10, 25, 25) imageName:@"ic_landing_nickname" color:nil];
    UIImageView *pwdImageView=[self createImageViewFrame:CGRectMake(20, 60, 25, 25) imageName:@"mm_normal" color:nil];
    UIImageView *line1=[self createImageViewFrame:CGRectMake(20, 50, bgView.frame.size.width-40, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    [bgView addSubview:user];
    [bgView addSubview:pwd];
    
    [bgView addSubview:userImageView];
    [bgView addSubview:pwdImageView];
    [bgView addSubview:line1];
    [HUD hideAnimated:YES afterDelay:2];
   // [SVProgressHUD dismissWithDelay:2];
    
}
//创建登陆按钮


-(void)test{


[self.view setUserInteractionEnabled:NO];






}
-(void)syw{


[self.view setUserInteractionEnabled:YES];



}
-(void)createLoginButtons
{
    UIButton *landBtn=[self createButtonFrame:CGRectMake(10, 190, self.view.frame.size.width-20, 37) backImageName:nil title:@"登录" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:19] target:self action:@selector(loginButtonClick)];
    landBtn.backgroundColor=[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    landBtn.layer.cornerRadius=5.0f;
    
    //fogotPwdBtn.backgroundColor=[UIColor lightGrayColor];
    
    
#define Start_X 60.0f           // 第一个按钮的X坐标
#define Start_Y 440.0f           // 第一个按钮的Y坐标
#define Width_Space 50.0f        // 2个按钮之间的横间距
#define Height_Space 20.0f      // 竖间距
#define Button_Height 50.0f    // 高
#define Button_Width 50.0f      // 宽
    
    
    [self.view addSubview:landBtn];
    
    //登录问题
    
    UILabel *errorLogin = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height -40, self.view.frame.size.width, 20)];
    errorLogin.textAlignment = NSTextAlignmentCenter;
    errorLogin.text = @"登录遇到问题?";
    errorLogin.textColor = [UIColor colorWithRed:169/255.0f green:80/255.0f blue:30/255.0f alpha:0.5f];
    errorLogin.font = [UIFont fontWithName:@"Helvetica" size:12];
    [self.view addSubview:errorLogin];
    
    //增加事件
    errorLogin.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableClickerror:)];
    
    [errorLogin addGestureRecognizer:labelTapGestureRecognizer];
    
    
    
    
    
}

-(UIButton *)createButtonFrame:(CGRect)frame backImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    if (imageName)
    {
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    if (font)
    {
        btn.titleLabel.font=font;
    }
    
    if (title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (target&&action)
    {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 退出方法
-(void)clickaddBtn:(UIButton *)button
{
    self.view.backgroundColor=[UIColor whiteColor];
    exit(0);
}

#pragma mark 登陆方法
//登录
-(void)loginButtonClick
{ self.conn = [Reachability reachabilityForInternetConnection];
   [self.conn startNotifier];
    [self checkNetworkState];

    [user resignFirstResponder];
    [pwd resignFirstResponder];
   //[SVProgressHUD showWithStatus:@"正在验证..."];
   // [SVProgressHUD showInfoWithStatus:@"正在验证..."];
   // [self mbProgressHUDUntil:@"正在登录"];

     //[SVProgressHUD   showSuccessWithStatus:@"正在验证..."];
    if ([user.text isEqualToString:@""])
    {
        [self mbProgressHUDUntil:@"请输入账号"];
        [HUD hideAnimated:YES afterDelay:2];
        
        return;
    }
    else if (user.text.length <1)
    {
        //[SVProgressHUD showInfoWithStatus:@"亲,帐号长度至少3位"];
        //[SVProgressHUD dismissWithDelay:2];
        return;
    }
    else if ([pwd.text isEqualToString:@""])
    {
        [self mbProgressHUDUntil:@"请输入密码"];
        [HUD hideAnimated:YES afterDelay:2];
        return;
    }
   else {
#pragma make 主界面
#pragma 检查网络
        [self mbProgressHUDUntil:@"正在登录"];
        self.conn = [Reachability reachabilityForInternetConnection];
        [self.conn startNotifier];
        [self checkNetworkState];
        
        /*
         socket 建立
         */
        _sslSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        //http 80
        //https 443
        //[_sslSocket connectToHost:@"10.10.10.101" onPort:8101 error:nil];
        [_sslSocket connectToHost:@"10.10.10.101" onPort:8101 withTimeout:10 error:nil];
        //return;
        
        
        
        //TopsecMainController *homeview = [[TopsecMainController alloc]init];
        //[self presentViewController:homeview animated:YES completion:nil];
        
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
#pragma mark 输入框及背景方法
-(UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.font=font;
    
    textField.textColor=[UIColor grayColor];
    
    textField.borderStyle=UITextBorderStyleNone;
    
    textField.placeholder=placeholder;
    
    return textField;
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

#pragma mark 键盘弹出框 关闭
-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [user resignFirstResponder];
    [pwd resignFirstResponder];
}
#pragma mark 网络验证检查结果
- (void)checkNetworkState
{
    // 1.检测wifi状态
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:{
            isExistenceNetwork = NO;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无网络" message:@"\n\n" preferredStyle:UIAlertControllerStyleAlert];
            //这里就可以设置子控件的frame,但是alert的frame不可以设置
                      //这跟 actionSheet有点类似了,因为都是UIAlertController里面的嘛
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //控制台中打印出输入的内容
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            //添加按钮
            [alert addAction:ok];
            [alert addAction:cancel];
            //以modal的方式来弹出
            [self presentViewController:alert animated:YES completion:^{ }];
            
            break;}
        case ReachableViaWiFi:{
            isExistenceNetwork = YES;
            NSLog(@"WIFI");
            
            
            
            break;}
        case ReachableViaWWAN:{
            isExistenceNetwork = YES;
            NSLog(@"3G");
            break;}
    }
}
#pragma mark 安全退出按钮
-(void)exitClickButtonlogin{
    //AppDelegate *app = [UIApplication sharedApplication].delegate;
    //UIWindow *window = app.window;
    //[UIView animateWithDuration:1.0f animations:^{
    //window.alpha = 0;
    //window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    //} completion:^(BOOL finished) {
    exit(0);
    //}];
    
}
//键盘事件 操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == user) {
        //self.usernameTextfield放弃第一响应者，而self.passwordTextfield变为第一响应者
        [user resignFirstResponder];
        
    } else if(textField == pwd) {
        [user resignFirstResponder];
        [pwd resignFirstResponder];
        [self loginButtonClick];
        
        
    }
    return YES;
}
//登录遇到问题 提示
-(void)lableClickerror:id{
    
    [HHAlertView showAlertWithStyle:HHAlertStyleWraning inView:self.view Title:@"提示" detail:@"拨打客服电话：400-00-000" cancelButton:@"否" Okbutton:@"是"];
    
}
- (void)didClickButtonAnIndex:(HHAlertButton)button
{
    if (button == HHAlertButtonOk) {
        NSLog(@"ok Button is seleced use delegate");
        NSString *phoneNumber = @"400-00-000";
        NSMutableString *strphone = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest  requestWithURL:[NSURL URLWithString:strphone]]];
        [self.view addSubview:callWebview];
    }
    else
    {
        NSLog(@"cancel Button is seleced use delegate");
    }
    
}

//是否越狱提示
-(void)brokePhoneAlert{
    //UIAlertController
    
    
    
    
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
    mobileMessage.whereServer = @"cas";
    
    
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
    news.phonegtg =@"alibaba";
    news.phoneNewType=@"hydt";
    news.phonePageNo=1;
    news.phonePageSize=10;
    
    
    
    
    
#pragma mark cmp_interface.proto  接口信息 首页请求登录
    CmpPhoneLoginRequest *loginRequest = [[CmpPhoneLoginRequest alloc]init];
    loginRequest.phoneDeviceId=@"www.baidu.com";
    loginRequest.loginName=user.text;
    loginRequest.loginPassword=pwd.text;
    
    
#pragma 压缩二进制
    //把接口信息转换二进制 放入PhoneInformationRequest
    NSData* nsdatahomeRequest=[loginRequest data];
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
    NSLog(@"-----------+++ddd--%@",mod2);
    
    
    
    //解压缩注意解压强转
    //GPBAny * angl = mod2.payloadArray[0];
    //NSData *da8 =angl.value;
    CmpServerLoginResponse *mg8 =[CmpServerLoginResponse parseFromData:mod2.binaryContent error:nil];
    NSLog(@"-----%@",mg8);
    
    NSString *suuu = mg8.tokenId;
//    TopsecMainController *homeview = [[TopsecMainController alloc]init];
//    [self presentViewController:homeview animated:YES completion:nil];
    if([@"成功" isEqualToString:suuu]){
        
        [HUD hideAnimated:YES afterDelay:0];
        
        TopsecMainController *homeview = [[TopsecMainController alloc]init];
        [self presentViewController:homeview animated:YES completion:nil];
        
        [_sslSocket disconnect];
    }else{
        [HUD hideAnimated:YES afterDelay:0];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.label.text = @"账号或密码错误";
        HUD.minSize = CGSizeMake(132.f, 108.0f);
        [HUD hideAnimated:YES afterDelay:0];

    }
    
}

-(void)mbProgressHUDUntil:(NSString *)title {
    
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.label.text = title;
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)]];
//    
//    
//    // 2.设定尺寸
//    effectView.frame = CGRectMake(HUD.center.x-66, HUD.center.y-54, 132.f, 108.0f);
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:effectView.bounds];
//    label.text = title;
//    label.font = [UIFont systemFontOfSize:18.f];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor =[UIColor blackColor ];
//    UIVisualEffectView *subEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)effectView.effect]];
//    subEffectView.frame = effectView.bounds;
//    
//    // 将子模糊view添加到effectView的contentView才能生效
//    [effectView.contentView addSubview:subEffectView];
//    
//    // 再把要显示特效的控件添加到子模糊view上
//    [subEffectView.contentView addSubview:label];
//    
//    
//    //effectView.backgroundColor= [UIColor yellowColor];
//    // 3.添加到view当中
//    [HUD addSubview:effectView];
//    
    

    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    [HUD hideAnimated:YES afterDelay:0];
//    [SVProgressHUD showWithStatus:@"网络连接异常"];
//    [SVProgressHUD dismissWithDelay:2];
    [self mbProgressHUDUntil:@"暂无响应"];
    [HUD hideAnimated:YES afterDelay:1];
    NSLog(@"disconnect  err:%@",err);
}



@end

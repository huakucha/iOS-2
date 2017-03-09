//
//  LXJTopsecViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 2016/11/22.
//  Copyright © 2016年 topsec. All rights reserved.
//

    #import "LXJTopsecViewController.h"
    #import "GCDAsyncSocket.h"
    #import "AsyncSocket.h"

    //protobuffer
    #import "TopsecCorephoto.pbobjc.h"
    #import "PhoneInformation.pbobjc.h"
    #import "CmpInterface.pbobjc.h"
    //转换二进制工具
    #import "ProtobufUtil.h"

    #import "Entity+CoreDataClass.h"
    #import "Parscell.h"
    #import "MJRefresh.h"
    #define kWidth [UIScreen mainScreen].bounds.size.width
    #define kHeight [UIScreen mainScreen].bounds.size.height
    @interface LXJTopsecViewController ()<GCDAsyncSocketDelegate,UITableViewDelegate,UITableViewDataSource>
    {
     GCDAsyncSocket *_sslSocket;
          NSManagedObjectContext *_context;
    }
    //定义变量
    @property(nonatomic,retain) NSTimer *heartTimer;
    @property(nonatomic,retain) AsyncSocket *ay;
    @property(nonatomic,strong)UITableView *Pastabview;
    @end

    @implementation LXJTopsecViewController

    - (void)viewDidLoad {
        [super viewDidLoad];
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        
        // 上下文关连数据库
        
        // model模型文件
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        // 持久化存储调度器
        // 持久化，把数据保存到一个文件，而不是内存
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // 告诉Coredata数据库的名字和路径
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *sqlitePath = [doc stringByAppendingPathComponent:@"company.sqlite"];
        NSLog(@"%@",sqlitePath);
        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
        
        context.persistentStoreCoordinator = store;
        _context = context;

        
        
        
        //[self delete];

       _Pastabview = [[UITableView alloc] initWithFrame:CGRectMake(0, -34, kWidth, kHeight+34)];
        
        _Pastabview.delegate=self;
        
        _Pastabview.dataSource=self;
        self.Pastabview.rowHeight =92;
        
        
       
        
        
        self.Pastabview.backgroundColor =[UIColor whiteColor];
        self.Pastabview.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        // Enter the refresh status immediately
        [self.Pastabview.mj_header beginRefreshing];

        self.Pastabview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [self.view addSubview:_Pastabview];
        
        
        // Do any additional setup after loading the view.
        /*
         socket 建立
         
         
         */
        _sslSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        //http 80
        //https 443
        [_sslSocket connectToHost:@"10.10.10.101" onPort:8101 error:nil];

    }


    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
    //    if (_tgArry==nil) {
    //        
    //        
    //        return 5;
    //        
    //    }else{
    //        return _tgArry.count;}
        return 10;
    }

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        static NSString *identifier = @"Parscell";
        Parscell * dcell  = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (dcell == nil) {
            
            dcell = [[[NSBundle mainBundle] loadNibNamed:@"pars" owner:nil options:nil] lastObject];
            
        }
        
        NSMutableArray *tgArry=[self redmod];
        
        if (tgArry.count>0){
           Entity  *danda =tgArry[indexPath.row];
            dcell.tg = danda;
            dcell.selectionStyle = UITableViewCellAccessoryNone;
        }
      
        return dcell;
        
        
        
    }
    -(void)loadMoreData{



      [self.Pastabview.mj_footer endRefreshingWithNoMoreData];



    }

    -(void)loadNewData{



        [self.Pastabview reloadData];


        [self.Pastabview.mj_header endRefreshing];


    }


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
        mobileMessage.whereport = @"cmphome";
        mobileMessage.whereServer = @"cmp";
        
        
    #pragma mark Phone_information 手机基本信息
       
        PhoneInformationRequest *phInfor = [[PhoneInformationRequest alloc]init];
        phInfor.phoneType = @"ios";
        phInfor.phoneVersion = 1;
        phInfor.longItude = @"11.11";
        phInfor.latItude  = @"22.22";
        phInfor.requestTime = @"2016-11-22";
        
        
        

    #pragma mark cmp_interface.proto  接口信息 首页请求登录
        CmpPhoneHomeRequest *homeRequest = [[CmpPhoneHomeRequest alloc]init];
        homeRequest.token = @"deviceID";
        homeRequest.taskType = @"全部任务";
        homeRequest.pageSize = 10;
        homeRequest.pageIndex =1;
        homeRequest.taskName = @"全部任务";
        
        
    #pragma 压缩二进制
        //把接口信息转换二进制 放入PhoneInformationRequest
        NSData* nsdatahomeRequest=[homeRequest data];
        phInfor.binaryPortInfor = nsdatahomeRequest;
        //把手机信息转换二进制 放入TopsecMobileMessage
        NSData* nsdataphInfor=[phInfor data];
        mobileMessage.binaryContent = nsdataphInfor;
        
        
    #pragma socket发送
        ProtobufUtil *protoUtil=[[ProtobufUtil alloc]init];
        [sock writeData:[protoUtil protobuf2VarintData:mobileMessage] withTimeout:10.0f tag:101];
        [sock readDataWithTimeout:-1 tag:0];
        
    }
    //读返回数据
    - (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
        NSLog(@"返回数据%@",data);
        
        ProtobufUtil* protobufUtil=[[ProtobufUtil alloc]init];
        NSLog(@"-------------%@",data);
        TopsecServerMessage * mod2 =[protobufUtil varintData2ServerMessage:data];
        NSLog(@"-----------ddd--%@",mod2);
        //解压缩注意解压强转
        //GPBAny * angl = mod2.payloadArray[0];
        //NSData *da8 =angl.value;
        CmpServerHomeResponse *mg8 =[CmpServerHomeResponse parseFromData:mod2.binaryContent error:nil];
        NSLog(@"返回数据了%@",mg8);
        //NSMutableArray *ary =mg8. homefamily.hometaskitemArray;
       // NSLog(@"===========%lu",(unsigned long)ary.count);
        /*
         bool success = 10;
         int32  dataTotal= 11;
         int32  pageSize = 12;
         int32  pageIndex = 13;
         int32  endIndex  = 14;
         int32  pageTotal = 15;
         HomeFamily homefamily= 16;
         
         
         string uuid=101;
         string taskName = 102;
         string target   = 103;
         string taskStatus = 104;
         
        -
         
         
         
         */
        Boolean cmpSuccess= mg8.success;
        int     dataTotal = mg8.dataTotal;
        int     pageSize = mg8.pageSize;
        int     pageIndex = mg8.pageIndex;
        int     pageTotal = mg8.pageTotal;
        
        HomeFamily  *homefamily = mg8.homefamily;
        for(int i = 0;i<homefamily.hometaskitemArray_Count;i++){
            NSString *uuid = [homefamily.hometaskitemArray[i] uuid];
            NSString *taskName = [homefamily.hometaskitemArray[i] taskName];
            NSString *target = [homefamily.hometaskitemArray[i] target];
            NSString *taskStatus = [homefamily.hometaskitemArray[i] taskStatus];

            Entity * emp1 = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:_context];
            
            emp1.uuid=taskName;
            emp1.tasktage=target;
            NSLog(@"名称%@",taskName);
            NSLog(@"%@",emp1.uuid);
            NSError *error = nil;
            [_context save:&error];
            
            if (error) {
                NSLog(@"%@",error);
            }
          
        }
        
        
        
        
    //    NSDictionary *dic=mg8. homefamily.hometaskitemArray[1];
    //    Entity * emp = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:_context];
       // emp.uuid = [dic objectForKey:@"uuid"];
       // NSLog(@"-----%@",dic);

      // emp.uuid =@"hahahahaha";
        // for (int i = 0; i < 5; i++) {
            // Entity * emp = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:_context];
            // NSDictionary *dic=mg8. homefamily.hometaskitemArray[1];
           //  emp.uuid = [dic objectForKey:@"uuid"];
    //         NSError *error = nil;
    //         [_context save:&error];
    //         
    //         if (error) {
    //             NSLog(@"%@",error);
    //         }
           //  NSLog(@"=========%@",emp.uuid);
        // }
        

    }



    -(id)redmod{

        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:_context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setIncludesPropertyValues:NO];
        [request setEntity:entity];
        NSError *error = nil;
        NSArray *datas = [_context executeFetchRequest:request error:&error];



        return datas;


    }



    -(void)delete{

    //    /**
    //     1.查询到要删除的内容
    //     2.获取输入的内容
    //     */
    //    NSString * deleteContent = @"";
    //    
    //    /** 查询要删除带有输入的关键字的对象 */
    //   NSPredicate *pre = [NSPredicate predicateWithFormat:@"depart.name = %@",@"android"];
    //    
    //   // AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
    //    
    //    /** 被管理对象上下文--(获取所有被管理对象的实体) */
    //   // NSManagedObjectContext * context = delegate.managedObjectContext;
    //    
    //    /** 根据上下文获取查询数据库实体的请求参数---要查询的entity(实体) */
    //    NSEntityDescription * des = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:_context];
    //    
    //    /** 查询请求 */
    //    NSFetchRequest * request = [NSFetchRequest new];
    //    
    //    /** 根据参数获取查询内容 */
    //    request.entity = des;
    //    
    //    request.predicate = pre;
    //    
    //    /**
    //     1.获取所有被管理对象的实体---根据查询请求取出实体内容
    //     2.获取的查询内容是数组
    //     3.删掉所有查询到的内容
    //     3.1.这里是模糊查询 即 删除包含要查询内容的字母的内容
    //     */
    //    NSArray * array = [_context executeFetchRequest:request error:NULL];
    //    
    //    /** 对查询的内容进行操作 */
    //    for (Entity * p in array) {
    //        [_context deleteObject:p];
    //    }
    //    NSLog(@"删除完成");
    //    NSError *error = nil;
    //    [_context save:&error];
    //
    //
    //    [_context deleteObject:];
    //    // 将结果同步到数据库
    //    NSError *error = nil;
    //    [_context save:&error];
    //    if (error) {
    //        [NSException raise:@"删除错误" format:@"%@", [error localizedDescription]];
    //    }


        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:_context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setIncludesPropertyValues:NO];
        [request setEntity:entity];
        NSError *error = nil;
        NSArray *datas = [_context executeFetchRequest:request error:&error];
        if (!error && datas && [datas count])
        {
            for (NSManagedObject *obj in datas)
            {
                [_context deleteObject:obj];
                
            }
            if (![_context save:&error])
            {
                NSLog(@"error:%@",error);
            }
        }




    }








    - (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
        
        
        NSLog(@"disconnect  err:%@",err);
    }

    @end

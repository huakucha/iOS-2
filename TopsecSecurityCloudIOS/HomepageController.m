//
//  onceViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec on 16/10/25.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "HomepageController.h"
#import "TopsecMainController.h"
#import "SplashScreen.h"
#import "UIImage+MRExtension.h"
#import "MRNavigationController.h"
#import "LockViewController.h"
//tableview 空间信息
#import "TasklistTableViewCell.h"
#import "TasklistCellData.h"
#import "MJRefresh.h"
//popMenu
#import "LxjPopMenuView.h"
//collectionview
#import "CollectionViewCell.h"
//更多信息
#import "AllTasklistViewController.h"
//重要任务
#import "ImportentTasklistViewController.h"
#import "Fg_tableView.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kAppViewW 80
#define kAppViewH 80
#define kColCount 4
#define kStartY   15
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
//lxj add height
#define SCREEN_HEIGHT_AVERAGE ([UIScreen mainScreen].bounds.size.height)/13

//首页请求界面
#import "LXJTopsecViewController.h"



@interface HomepageController ()<UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate,UITableViewDelegate,LXJPopMenuViewSelectDelegate>
{
    NSMutableArray *_collectionArray;// 九宫格数据源
}
@property(nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray  *tgArry;
@property (strong, nonatomic) UIScrollView *rootView;
@property (weak, nonatomic) UIView *topView;
@property (weak, nonatomic) Fg_tableView *tableView;
@property (weak, nonatomic) UIView * msView;
@end

@implementation HomepageController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tgArry==nil) {
        
        
        return 5;
        
    }else{
        return _tgArry.count;}
}

- (void)viewDidLoad {
   // [UIApplication sharedApplication].statusBarHidden = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:false forKey:@"logining"];//先默认都启动引导页
    [userDefaults synchronize];
    
    
    
#pragma mark 头部view
       /*self.navigationController.navigationBar.translucent = NO;
    //隐藏navigationBar 隐藏头部标题
    self.navigationController.navigationBar.hidden = YES;
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT_AVERAGE)];
    topview.backgroundColor=[UIColor orangeColor];
    UILabel * lab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/5, SCREEN_HEIGHT_AVERAGE)];
    lab.text=@"名称";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    [topview addSubview:lab];
    
    UISearchController *       searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchController.delegate = self;
    searchController.searchResultsUpdater= self;
    searchController.obscuresBackgroundDuringPresentation = YES;
    
    
    
    searchController.searchBar.frame = CGRectMake(self.view.frame.size.width/5, (SCREEN_HEIGHT_AVERAGE/2)-15, (self.view.frame.size.width/5)*3.5, 30);
    searchController.searchBar.backgroundColor = [UIColor orangeColor];
    searchController.searchBar.layer.cornerRadius = 14;
    searchController.searchBar.layer.masksToBounds = YES;
    [searchController.searchBar.layer setBorderWidth:8];
    [searchController.searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
    searchController.searchBar.placeholder = @"搜索 后期维护中。。";
    [topview addSubview:searchController.searchBar];
    [self.view addSubview:topview];
    */
    #define MIDDLE_HEIGHT_AVERAGE 4*([UIScreen mainScreen].bounds.size.height)/117
#pragma mark  中部布局
    

    UIView   *midview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT_AVERAGE, SCREEN_WIDTH, MIDDLE_HEIGHT_AVERAGE*3)];
    midview.backgroundColor = [UIColor whiteColor];
    //中间布局 总体分为九分
//#define MIDDLE_HEIGHT_AVERAGE 4*([UIScreen mainScreen].bounds.size.height)/117
    //中间第一个view
    UIView *midFirstview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MIDDLE_HEIGHT_AVERAGE)];
    midFirstview.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.f alpha:1.0];
    [midview addSubview:midFirstview];
    /*
     控件内容  1
     */
    UIImageView *alarmImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, (MIDDLE_HEIGHT_AVERAGE/2)-7, 16, 14)];
    [alarmImage setImage:[UIImage imageNamed:@"home_alarm"]];
    [midFirstview addSubview:alarmImage];
    
    UILabel     *alarmNumber = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, SCREEN_WIDTH-50, MIDDLE_HEIGHT_AVERAGE)];
    alarmNumber.textAlignment = NSTextAlignmentLeft;
    alarmNumber.text = @"当前共有报警111个，请及时查看";
    alarmNumber.textColor = [UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1.0];
    alarmNumber.font=[UIFont fontWithName:@"Helvetica" size:13.f];
    [midFirstview addSubview:alarmNumber];
    //中间第2个view
    UIView *midSecondview = [[UIView alloc]initWithFrame:CGRectMake(0, MIDDLE_HEIGHT_AVERAGE, SCREEN_WIDTH, MIDDLE_HEIGHT_AVERAGE*2)];
    midSecondview.backgroundColor = [UIColor whiteColor];
    [midview addSubview:midSecondview];
    /*
     控件内容  2
     */
    UIView *leftTypecolorType = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, MIDDLE_HEIGHT_AVERAGE*2)];
    leftTypecolorType.backgroundColor = [UIColor colorWithRed:68/255.0f green:148/255.0f blue:242/255.f alpha:1.0f];
    [midSecondview addSubview:leftTypecolorType];
    
    UILabel *jianceTypename = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/2, MIDDLE_HEIGHT_AVERAGE*2)];
    jianceTypename.text = @"服务类型";
    jianceTypename.textColor = [UIColor grayColor];
    [midSecondview addSubview:jianceTypename];
    
    UIButton *typeButtonMore1 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - (MIDDLE_HEIGHT_AVERAGE*3), MIDDLE_HEIGHT_AVERAGE*(2/3), MIDDLE_HEIGHT_AVERAGE*3, MIDDLE_HEIGHT_AVERAGE*2)];
    [typeButtonMore1 setTitle:@"更多 >" forState:UIControlStateNormal];
    [typeButtonMore1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    typeButtonMore1.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [midSecondview addSubview:typeButtonMore1];
    //增加事件
    [typeButtonMore1 addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
//    self.rootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MIDDLE_HEIGHT_AVERAGE*3, kWidth,1000)];
//    self.rootView.contentSize = CGSizeMake(0, kHeight * 5);
//   // self.rootView.scrollIndicatorInsets = UIEdgeInsetsMake(310, 0, 0, 0);
//    self.rootView.delegate = self;
//    self.rootView.backgroundColor=[UIColor redColor];
//    [self.view addSubview:self.rootView];
    self.rootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MIDDLE_HEIGHT_AVERAGE*3-20, kWidth,kHeight-MIDDLE_HEIGHT_AVERAGE*3+20)];
    self.rootView.contentSize = CGSizeMake(0, kHeight * 2);
    //self.rootView.scrollIndicatorInsets = UIEdgeInsetsMake(310, 0, 0, 0);
    self.rootView.delegate = self;
    self.rootView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.rootView];

    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, MIDDLE_HEIGHT_AVERAGE*6)];
    self.topView = topView;
    topView.backgroundColor = [UIColor yellowColor];
    [self.rootView addSubview:topView];

    
    
    
    
    
    //中间第3个view  collectionView
    UIView *midThreeview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MIDDLE_HEIGHT_AVERAGE*4)];
    midThreeview.backgroundColor = [UIColor whiteColor];
   // [midview addSubview:midThreeview];
    self.msView=midThreeview;
    [_topView addSubview:self.msView];
    
    /**
     *  创建collectionView self自动调用setter getter方法
     */
    [midThreeview addSubview:self.collectionView];
    /**
     *  加载的数据
     */
    NSArray *imgArray = [NSArray arrayWithObjects:@"jiance",@"jiance",@"jiance",@"jiance", nil];
    //collectionView数据
    _collectionArray = [imgArray mutableCopy];
    
    
    
    /*
     控件内容  3
     */
    //中间第4个view
    UIView *midFourview = [[UIView alloc]initWithFrame:CGRectMake(0, MIDDLE_HEIGHT_AVERAGE*4, SCREEN_WIDTH, MIDDLE_HEIGHT_AVERAGE*2)];
    midFourview.backgroundColor = [UIColor whiteColor];
    
    UIView *leftTypecolorType1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, MIDDLE_HEIGHT_AVERAGE*2)];
    leftTypecolorType1.backgroundColor = [UIColor colorWithRed:247/255.0f green:101/255.0f blue:105/255.f alpha:1.0f];
    [midFourview addSubview:leftTypecolorType1];
    
    UILabel *jianceTypename1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/2, MIDDLE_HEIGHT_AVERAGE*2)];
    jianceTypename1.text = @"实时任务";
    jianceTypename1.textColor = [UIColor grayColor];
    [midFourview addSubview:jianceTypename1];
    
    UIButton *typeButtonMore2 = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - (MIDDLE_HEIGHT_AVERAGE*3), MIDDLE_HEIGHT_AVERAGE*(2/3), MIDDLE_HEIGHT_AVERAGE*3, MIDDLE_HEIGHT_AVERAGE*2)];
    [typeButtonMore2 setTitle:@"更多 >" forState:UIControlStateNormal];
    [typeButtonMore2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    typeButtonMore2.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [midFourview addSubview:typeButtonMore2];
    //[midview addSubview:midFourview];
    [topView addSubview:midFourview];
    //增加事件
    [typeButtonMore2 addTarget:self action:@selector(moreButtonClick2) forControlEvents:UIControlEventTouchUpInside];

    //加入到view
    [self.view addSubview:midview];
#pragma mark  底部布局
    UIView   *bootview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT_AVERAGE*5, SCREEN_WIDTH, (SCREEN_HEIGHT_AVERAGE)*8)];
    //bootview.backgroundColor = [UIColor colorWithRed:114/255.0f green:114/255.0f blue:114/255.0f alpha:1.0f];
    bootview.backgroundColor = [UIColor blackColor];
    //[self.view addSubview:bootview];
    // 表格控件在创建时必须指定样式，只能使用以下实例化方法
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT_AVERAGE)*8) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //_tableView.center=self.view.center;
    _tableView.backgroundColor =[UIColor colorWithRed:230.0f/255.0f green:245.0f/255.0f blue:253.0f/255.0f alpha:1];
    //_tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-6, 50)];
    self.tableView.rowHeight =105;
    
   // [bootview addSubview:_tableView];
    
    
    
    // Do any additional setup after loading the view.
    
    Fg_tableView * tableView = [[Fg_tableView alloc] initWithFrame:CGRectMake(0,  MIDDLE_HEIGHT_AVERAGE*6, kWidth, kHeight * 5 -  MIDDLE_HEIGHT_AVERAGE*3) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.rootView addSubview:tableView];
    
    
    
    
}




//初次加载
-(void)tableviewfirst{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewdeviceData)];
    //[self.tableView.mj_header beginRefreshing];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"taskhome";
    TasklistTableViewCell * dcell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (dcell == nil) {
        
        dcell = [[[NSBundle mainBundle] loadNibNamed:@"TasklistTableViewCell" owner:nil options:nil] lastObject];
        
    }
    if (self.tgArry.count>0){
        TasklistCellData *danda =self.tgArry[indexPath.row];
        dcell.data = danda;
        dcell.selectionStyle = UITableViewCellAccessoryNone;
    }
    return dcell;
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark 更多点击事件
-(void)moreButtonClick{
[[[UIApplication sharedApplication]keyWindow]endEditing:YES];//关闭键盘
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSInteger i = 1; i < 7; i++) {
        NSString *string = [NSString stringWithFormat:@"%ld",i];
        LxjPopMenuitem *item = [LxjPopMenuitem itemWithTitle:string image:[UIImage imageNamed:@"jiance"]];
        [array addObject:item];
    }
    
    LxjPopMenuView *jkpop = [LxjPopMenuView menuViewWithItems:array];
    jkpop.delegate = self;
    [jkpop show];
}
#pragma mark App JKPopMenuViewSelectDelegate
- (void)popMenuViewSelectIndex:(NSInteger)index
{
    
}

//更多界面
#pragma mark 更多点击事件
-(void)moreButtonClick2{
    AllTasklistViewController *AllTasklist = [[AllTasklistViewController alloc]init];
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];//关闭键盘
    AllTasklist.title = @"全部任务";
    [self.navigationController pushViewController:AllTasklist animated:NO];
}
-(void)viewDidAppear:(BOOL)animated{
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];//关闭键盘

    //隐藏navigationBar 隐藏头部标题
    //self.navigationController.navigationBar.hidden = YES;
}

/*
 collectionview
 基础控件
 
 lxj 首页初次使用collectionview
 */

#pragma mark 创建collectionView
- (UICollectionView*)collectionView{
    if(_collectionView == nil){
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 1);//头部大小
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
        
        //定义每个UIcollectionView的大小
        flowLayout.itemSize = CGSizeMake((self.view.frame.size.width -20)/4, (self.view.frame.size.width-20)/4);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 5;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 0;
        //定义每个UICollectionView 的边距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);//上下左右
        
        //注册cell 和reusableview 相当于头部
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1.0];

        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        
    }
    return _collectionView;
}
#pragma mark - UICollectionView delegate dataSource
#pragma mark 定义展示的UICollectionViewCell的个数

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_collectionArray count];
}

#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    
    cell.imageView.image = [UIImage imageNamed:_collectionArray[indexPath.item]];
    switch (indexPath.item) {
        case 0:
            //cell.text.text = [NSString stringWithFormat:@"Cell %ld",indexPath.item];
            cell.text.text = @"域名解析";
            break;
        case 1:
            //cell.text.text = [NSString stringWithFormat:@"Cell %ld",indexPath.item];
            cell.text.text = @"串改监测";
            break;
        case 2:
            //cell.text.text = [NSString stringWithFormat:@"Cell %ld",indexPath.item];
            cell.text.text = @"可用性监测";
            break;
        case 3:
            //cell.text.text = [NSString stringWithFormat:@"Cell %ld",indexPath.item];
            cell.text.text = @"敏感关键字";
            break;
            
        default:
            break;
    }
    
    
    //按钮事件就不实现了……
    return cell;
}

#pragma mark 头部显示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    
    return headerView;
}

#pragma mark UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择%ld",indexPath.item);
    switch (indexPath.item) {
        case 0:
            //LXJTopsecViewController
            [self homeRequest];
            break;
            
        default:
            break;
    }
    
    
    
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    CGFloat y = scrollView.contentOffset.y;
//    if (y <= 0  ) {
//        CGRect newFrame = self.topView.frame;
//        newFrame.origin.y = y;
//        self.topView.frame = newFrame;
//        
//        newFrame = self.tableView.frame;
//        newFrame.origin.y = y +MIDDLE_HEIGHT_AVERAGE*6 ;
//        self.tableView.frame = newFrame;
//        
//        //偏移量给到tableview，tableview自己来滑动
//        self.tableView.contentOffsetY = y;
//        
//        //滑动太快有时候不正确，这里是保护imageView 的frame为正确的。
//        newFrame = self.msView.frame;
//        newFrame.origin.y = 0;
//        self.msView.frame = newFrame;
//    } else {
//        //视差处理
//        CGRect newFrame = self.msView.frame;
//        newFrame.origin.y = y/2;
//        self.msView.frame = newFrame;
//    }
//}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    // 松手时判断是否刷新
    CGFloat y = scrollView.contentOffset.y;
    if (y < - 64) {
        [self.tableView startRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            
            
            [self.tableView endRefreshing];
        });
    }
}


//首页请求测试
-(void)homeRequest{
    LXJTopsecViewController *AllTasklistLXJTopsecViewController = [[LXJTopsecViewController alloc]init];
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];//关闭键盘
    AllTasklistLXJTopsecViewController.title = @"全部任务";
    [self.navigationController pushViewController:AllTasklistLXJTopsecViewController animated:NO];

}











@end

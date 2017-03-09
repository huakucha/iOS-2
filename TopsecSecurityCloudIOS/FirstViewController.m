//
//  FirstViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec on 17/2/8.
//  Copyright © 2017年 topsec. All rights reserved.
//

#import "FirstViewController.h"
  #import "MJRefresh.h"

#import "SDCycleScrollView.h"
#import "CollectionViewCell.h"
#import "LxjPopMenuView.h"
#import "LXJTopsecViewController.h"
#import "FistCell.h"
#define IMAGES @[@"http://static.newnewle.com/bundles/webappindex/upload/user/img/ddf806c52b4fffed8d10ea22fe0aefa7.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/fbcd050542555e6a4d35cc92f4fc5cec.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/d3e7c20acb70b2554825e4fa35919da8.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/f58cf571f152660ef09b150f9b3b1f0c.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/725621ddcb287ffcb0bc3524e62dfc21.jpeg",@"http://static.newnewle.com/bundles/webappindex/upload/user/img/fe899e8d631d586224edb11fb0842df7.jpeg"]


@interface FirstViewController ()<UIScrollViewDelegate, SDCycleScrollViewDelegate,UICollectionViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout ,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate,UITableViewDelegate,LXJPopMenuViewSelectDelegate>
{NSMutableArray *_collectionArray;}
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:false forKey:@"logining"];//先默认都启动引导页
    [userDefaults synchronize];
    
    
    
        if (_Roottabveiw==nil) {
            
            UITableView *tab =[[UITableView alloc]init];
            tab.frame  =CGRectMake(0, -22, kWidth, kHeight);
            tab.delegate=self;
            tab.dataSource=self;
            tab.rowHeight=88;
            _Roottabveiw=tab;
            
            self.Roottabveiw.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
            
            // Enter the refresh status immediately
            [self.Roottabveiw.mj_header beginRefreshing];
            
            self.Roottabveiw.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            
            
            
            self.Roottabveiw.tableHeaderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];

            [self.view addSubview:_Roottabveiw];
            SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, 80) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
                        cycleScrollView2.currentPageDotColor = [UIColor whiteColor];
        
            cycleScrollView2.delegate=self;
            
            [self.Roottabveiw.tableHeaderView addSubview:cycleScrollView2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cycleScrollView2.imageURLStringsGroup = IMAGES;
                
                
            });
            UIView * moreview = [[UIView alloc]initWithFrame:CGRectMake(0, 80, kWidth, 20)];
            moreview.backgroundColor=[UIColor redColor];
            [self.Roottabveiw.tableHeaderView addSubview:moreview];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"服务"];
            
             [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,str.length)]; //设置字体颜色
            
             [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:16.0] range:NSMakeRange(0, str.length)]; //设置字体字号和字体类别

            
            
            UILabel *morelab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth/2, 20)];
            morelab.attributedText  = str;
          
           
            [moreview addSubview:morelab];
            UIButton * morebtn =[[UIButton alloc]initWithFrame:CGRectMake(kWidth-70, 0, 60, 20)];
            [moreview addSubview:morebtn];
            [morebtn setTitle:@"更多 >" forState:UIControlStateNormal];
            morebtn.titleLabel.font= [UIFont fontWithName:@"Arial-BoldItalicMT" size:16];
            morebtn.contentHorizontalAlignment=UIViewContentModeRight;
            [morebtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
          
                       //增加事件
            [morebtn addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *ChooseView=[[UIView alloc]initWithFrame:CGRectMake(0, 100, kWidth, 80)];
            [self.Roottabveiw.tableHeaderView addSubview:ChooseView];
            
            
            
            [ChooseView addSubview:self.collectionView];
            
            
            NSArray *imgArray = [NSArray arrayWithObjects:@"jiance",@"jiance",@"jiance",@"jiance", nil];
            //collectionView数据
            _collectionArray = [imgArray mutableCopy];
            
            UIView*endview=[[UIView alloc]initWithFrame:CGRectMake(0, 178, kWidth, 20)];
            endview.backgroundColor=[UIColor yellowColor];
            [self.Roottabveiw.tableHeaderView addSubview:endview];
            UILabel * endlab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth/4, 20)];
            endlab.text=@"通告";
            endlab.font=[UIFont fontWithName:@"Arial-BoldItalicMT" size:16];

            [endview addSubview:endlab];
            
            
            
           
        }
    
    
    // Do any additional setup after loading the view.
}

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

-(void)homeRequest{
    LXJTopsecViewController *AllTasklistLXJTopsecViewController = [[LXJTopsecViewController alloc]init];
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];//关闭键盘
    AllTasklistLXJTopsecViewController.title = @"全部任务";
    [self.navigationController pushViewController:AllTasklistLXJTopsecViewController animated:NO];
    
}

- (UICollectionView*)collectionView{
    if(_collectionView == nil){
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 1);//头部大小
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 80) collectionViewLayout:flowLayout];
        // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //定义每个UIcollectionView的大小
        flowLayout.itemSize = CGSizeMake((self.view.frame.size.width -20)/4, (self.view.frame.size.width-20)/4);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 0;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 0;
        //定义每个UICollectionView 的边距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//上下左右
        
        //注册cell 和reusableview 相当于头部
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
//        _collectionView.backgroundColor = [UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1.0];
        _collectionView.backgroundColor=[UIColor whiteColor];
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




- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{


    NSLog(@"==================");




}

-(void)loadMoreData{
    
    
    
    [self.Roottabveiw.mj_footer endRefreshingWithNoMoreData];
    
    
    
}

-(void)loadNewData{
    
    self.Roottabveiw.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    [self.Roottabveiw reloadData];
    
    
    [self.Roottabveiw.mj_header endRefreshing];
    
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{




    return 10;



}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FistCell";
   FistCell * dcell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (dcell == nil) {
        
        dcell = [[[NSBundle mainBundle] loadNibNamed:@"fist" owner:nil options:nil] lastObject];
        
    }

    return dcell;
    
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

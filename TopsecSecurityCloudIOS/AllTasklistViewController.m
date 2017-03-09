//
//  AllTasklistViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 16/11/3.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "AllTasklistViewController.h"
//tableview 空间信息
#import "TasklistTableViewCell.h"
#import "TasklistCellData.h"
#import "MJRefresh.h"
#import "SearchAllTasklistViewController.h"
@interface AllTasklistViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray  *tgArry;
@end

@implementation AllTasklistViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tgArry==nil) {
        
        
        return 13;
        
    }else{
        return _tgArry.count;}
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //隐藏navigationBar 隐藏头部标题
    self.navigationController.navigationBar.hidden = NO;
    //self.navigationController.navigationBar.topItem.title = @"liuxiuji";
#pragma mark 头部增加右侧按钮图片
    UIBarButtonItem *searchrightButton = [[UIBarButtonItem alloc]
                                          initWithTitle:@""
                                          style:UIBarButtonItemStyleDone
                                          target:self
                                          action:@selector(doClicksearchAction)];
    [searchrightButton setImage:[UIImage imageNamed:@"search_right_image"]];
    self.navigationItem.rightBarButtonItem = searchrightButton;
    
#pragma mark 主体tableview
    // 表格控件在创建时必须指定样式，只能使用以下实例化方法
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //_tableView.center=self.view.center;
    _tableView.backgroundColor =[UIColor colorWithRed:230.0f/255.0f green:245.0f/255.0f blue:253.0f/255.0f alpha:1];
    //_tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-6, 50)];
    self.tableView.rowHeight =105;
    
    [self.view addSubview:_tableView];

    
    
    
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
 查询跳转事件
 */
-(void)doClicksearchAction{
    SearchAllTasklistViewController *searchTasklist = [[SearchAllTasklistViewController alloc]init];
    searchTasklist.title = @"任务查询";
    [self.navigationController pushViewController:searchTasklist animated:NO];


}
@end

//
//  MyInformationViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 2016/11/14.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "MyInformationViewController.h"
#import "InformationEditView.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface MyInformationViewController ()<UITableViewDataSource,UITableViewDelegate>{

    UITableView *userInformationTableView;
    NSArray     *userInformationDataSourceTop;
    NSArray     *userInformationDataSourceTopContent;
    NSArray     *userInformationDataSourceBottom;
    NSArray     *userInformationDataSourceBottomContent;

}



@end

@implementation MyInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f];
#pragma mark tableview 初始化
    userInformationTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:userInformationTableView];
    userInformationTableView.delegate=self;
    userInformationTableView.dataSource=self;
    //userInformationTableView.bounces=NO;
    userInformationTableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    userInformationTableView.separatorStyle = NO;
    //personalTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线
    userInformationDataSourceTop=@[@"头像",@"用户名",@"性别"];
    userInformationDataSourceTopContent=@[@"",@"测试一",@"男"];
    
    userInformationDataSourceBottom=@[@"部门",@"工号",@"邮箱",@"地址"];
    userInformationDataSourceBottomContent=@[@"安全云服务平台",@"1111",@"test_toppse@topsec.com.cn",@"1111"];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数 也就是section数
    return 2;
}
//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return userInformationDataSourceTop.count;
    }else if(section==1){
        return userInformationDataSourceBottom.count;
    }else{
        return 0;    
    }
}
//每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
}
//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 20;
}
//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 40;
    }
    return 40;
}



//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"Informationcell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
//        NSIndexPath *indexPat = [NSIndexPath indexPathForRow:1 inSection:0];
//        UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//        img.backgroundColor=[UIColor redColor];
//        UITableViewCell *cell = [userInformationTableView cellForRowAtIndexPath:indexPat];
        
//        [cell.contentView addSubview:img];
        if(indexPath.section==0){
        
            if (indexPath.row==0) {
                UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(kWidth-30, 5, 20, 20)];
                  img.backgroundColor=[UIColor redColor];
                [cell.contentView addSubview:img];

            }
        
        
        
        
        }
        
    }
    
    
    
    if (indexPath.section==0) {
        
                //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        cell.textLabel.text=[userInformationDataSourceTop objectAtIndex:indexPath.row];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        cell.detailTextLabel.text = [userInformationDataSourceTopContent objectAtIndex:indexPath.row];
        if(indexPath.row ==1){//性别修改
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        }

        
    }else if (indexPath.section==1) {
        cell.textLabel.text=[userInformationDataSourceBottom objectAtIndex:indexPath.row];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        cell.detailTextLabel.text = [userInformationDataSourceBottomContent objectAtIndex:indexPath.row];

        
    }else{
       
    }
    return cell;
}

//点击取消阴影
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){//个人信息
        NSLog(@"个人信息");
        //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        switch (indexPath.row) {
            case 0:
            {NSLog(@"用户名");
                
              
                
                
                
                
                break;}
            case 1:
                NSLog(@"性别");
                [self changeSex];

                break;
            default:
                break;
        }

        
    }else if(indexPath.section==1)//个人资料 和 帮助
    {
        switch (indexPath.row) {
            case 0:
                NSLog(@"部门");
                
                break;
            case 1:
                NSLog(@"工号");
                break;
            case 2:
                NSLog(@"邮箱");
                break;
            default:
                break;
        }
        
    }else
    {
        NSLog(@"没有");
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//性别选择界面
-(void)changeSex{
    InformationEditView *personSex = [[InformationEditView alloc]init];
    personSex.title = @"性别选择";
    [self.navigationController pushViewController:personSex animated:NO];

}
@end

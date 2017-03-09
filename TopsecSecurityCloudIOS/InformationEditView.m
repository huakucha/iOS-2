//
//  InformationEditView.m
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 2016/11/15.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "InformationEditView.h"

@interface InformationEditView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *sexTableView;
    NSArray *sexSource;
    NSArray *sexImageSource;

}
@end

@implementation InformationEditView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#pragma mark tableview 初始化
    sexTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:sexTableView];
    sexTableView.delegate=self;
    sexTableView.dataSource=self;
    //sexTableView.bounces=NO;
    sexTableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    sexTableView.separatorStyle = NO;
    //personalTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线
    sexSource=@[@"男",@"女"];
    sexImageSource = @[];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数 也就是section数
    return 1;
}

//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return sexSource.count;
    
}
//每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
}
//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 40;
    }
    return 40;
}
//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}
//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"Informationcellsex";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    
    
    if (indexPath.section==0) {
        
        cell.textLabel.text=[sexSource objectAtIndex:indexPath.row];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        if(indexPath.row ==0){//男
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(20, 39, self.view.frame.size.width-10, 1)];
            xian.backgroundColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
            [cell.contentView addSubview:xian];
        }
        else if(indexPath.row ==1){//男
            //cell.image = [UIImage imageNamed:@"check_ok"];
            
            //UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(20, 39, self.view.frame.size.width-10, 1)];
            //xian.backgroundColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
            //[cell.contentView addSubview:xian];
        }
        
    }else{
            }
    return cell;
}

//点击取消阴影
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){//个人信息
        //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        switch (indexPath.row) {
            case 0:
                [self.navigationController popViewControllerAnimated:YES];
                break;
            case 1:
                [self.navigationController popViewControllerAnimated:YES];
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

@end

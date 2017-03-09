//
//  MySettingInfoController.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/10/13.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "MySettingInfoController.h"
//密码设置
#import "LockViewController.h"
//个人信息
#import "MyInformationViewController.h"
//help
#import "UIWebview.h"
@interface MySettingInfoController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView *personalTableView;
    NSArray *dataSource;
    NSArray *imageSource;
}
@end

@implementation MySettingInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarHidden = NO;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
#pragma mark tableview 初始化
    personalTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:personalTableView];
    personalTableView.delegate=self;
    personalTableView.dataSource=self;
    personalTableView.bounces=NO;
    personalTableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    personalTableView.separatorStyle = NO;
    //personalTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线
    dataSource=@[@"个人资料",@"帮助"];
    imageSource = @[@"topsec_cmp.png",@"topsec_cmp.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数 也就是section数
    return 3;
}

//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section==1) {
        return dataSource.count;
    }else{
        return 1;
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
    if (section==2) {
        return 40;
    }
    return 20;
}
//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80;
    }
    return 40;
}

//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    
    
    if (indexPath.section==0) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userinfo"];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(12,0, 80, 80)];
        imageView.image=[UIImage imageNamed:@"topsec_people_moren.png"];
        imageView.layer.masksToBounds =YES;
        
        imageView.layer.cornerRadius =40;
         imageView.tag = 101;
        [cell.contentView addSubview:imageView];
        
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 0, self.view.frame.size.width-100, 40)];
        nameLabel.text=@"测试一";
        [cell.contentView addSubview:nameLabel];
        
        UILabel *emailLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 40, self.view.frame.size.width-100, 40)];
        emailLabel.text=@"ceshi@topsec.com.cn";
        [cell.contentView addSubview:emailLabel];
        
    }else if (indexPath.section==1) {
        cell.textLabel.text=[dataSource objectAtIndex:indexPath.row];
        UIImage *myset = [UIImage imageNamed:[imageSource objectAtIndex:indexPath.row]];
        cell.imageView.image = myset;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        if(indexPath.row ==0){
            UIView *xian = [[UIView alloc]initWithFrame:CGRectMake(40, 39, self.view.frame.size.width-50, 1)];
            xian.backgroundColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
            [cell.contentView addSubview:xian];
        }
        
        
    }else{
        cell.textLabel.text=@"设置";
        UIImage *myviewset = [UIImage imageNamed:@"topsec_cmp.png"];
        cell.imageView.image = myviewset;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    }
    return cell;
}

//点击取消阴影
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0){//个人信息
        NSLog(@"个人信息");
        //取消点击阴影
        //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //拍照
        UIAlertAction *takingPictures = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //do something
            [self openCamera];
        }];
        [alert addAction:takingPictures];
        //相册 Photo album
        UIAlertAction *photoAlbum = [UIAlertAction actionWithTitle:@"相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //do something
            [self openPics];
        }];
        [alert addAction:photoAlbum];
        //取消
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            //do something
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        
        
        
    }else if(indexPath.section==1)//个人资料 和 帮助
    {
        switch (indexPath.row) {
            case 0:
                [self personInfoemation];
            NSLog(@"个人资料");
               
                break;
            case 1:
                [self helpInfoemation];
            NSLog(@"帮助");
                break;
            default:
                break;
        }

    }else if(indexPath.section==2)//设置
    {
        NSLog(@"设置");
        LockViewController *lockview = [[LockViewController alloc]init];
        lockview.title = @"设置";
        [self.navigationController pushViewController:lockview animated:NO];

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
//跳转到个人信息设置界面
-(void)personInfoemation{
    MyInformationViewController *personInfoeview = [[MyInformationViewController alloc]init];
    personInfoeview.title = @"个人资料";
    [self.navigationController pushViewController:personInfoeview animated:NO];
}

//跳转到webview
-(void)helpInfoemation{
    UIWebview *Webview = [[UIWebview alloc]init];
    Webview.title = @"帮助";
    [self.navigationController pushViewController:Webview animated:NO];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
// 打开相机
- (void)openCamera {
    // UIImagePickerControllerCameraDeviceRear 后置摄像头
    // UIImagePickerControllerCameraDeviceFront 前置摄像头
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        NSLog(@"没有摄像头");
        return ;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    // 编辑模式
    imagePicker.allowsEditing = YES;
    
    [self  presentViewController:imagePicker animated:YES completion:^{
    }];
    
    
}
// 打开相册
- (void)openPics {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self  presentViewController:imagePicker animated:YES completion:^{
    }];
    
    
}


// 选中照片

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@", info);
    UIImageView  *imageView = (UIImageView *)[self.view viewWithTag:101];
    // UIImagePickerControllerOriginalImage 原始图片
    // UIImagePickerControllerEditedImage 编辑后图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    imageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
@end

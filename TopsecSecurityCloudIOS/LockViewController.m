//
//  LockViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec on 16/9/30.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "LockViewController.h"

#import "LZPasswordViewController.h"
#import "LZNumberTool.h"
#import "HHAlertView.h"
#import "AppDelegate.h"

@interface LockViewController ()<UITableViewDelegate,UITableViewDataSource,HHAlertViewDelegate>
{
    UITableView *_tableView;
    BOOL _isTurnOn;
    //安全退出按钮
    UIButton    *_safeExitButton;
    
}
@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //提示框
    [[HHAlertView shared] setDelegate:self];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0];
    
    _isTurnOn = [LZNumberTool getNumberPasswordEnableState];
    //self.title = @"设置密码选项";
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-65) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    _tableView = table;
    [self.view addSubview:table];
#pragma mark 安全退出按钮
    _safeExitButton = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-60, self.view.frame.size.width-40,  38)];
    _safeExitButton.backgroundColor = [UIColor redColor];
    [_safeExitButton setTitle:@"安全退出" forState:UIControlStateNormal];
    [_safeExitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    [_safeExitButton.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    //增加点击事件
    [_safeExitButton addTarget:self action:@selector(exitClickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_safeExitButton];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else  if (section == 1) {
        return 1;
    }else {
        
        return 3;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return _isTurnOn?3:2;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    if (section == 0) {
//        return @"设置选项";
//    } else {
//        return @"示例";
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        if (indexPath.section == 0) {
            cell.textLabel.text = @"记住APP登录账号";
            
            UISwitch *swlogin = [[UISwitch alloc]init];
            
            //[swlogin addTarget:self action:@selector(switchChangedlogin:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = swlogin;
        }
        if (indexPath.section == 1) {
            cell.textLabel.text = @"设置本地密码";
            
            UISwitch *sw = [[UISwitch alloc]init];
            
            [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = sw;
        }
        
    }
    
    if (indexPath.section == 1) {
        
        UISwitch *sw = (UISwitch*)cell.accessoryView;
        sw.on = _isTurnOn;
    }
    
    
    if (indexPath.section == 2) {
        NSArray *arr = @[@"设置密码",@"验证密码",@"更改密码"];
        
        cell.textLabel.text = arr[indexPath.row];
    }
    
    
    return cell;
}

- (void)switchChanged:(UISwitch*)sw {
    
    _isTurnOn = sw.on;
    [LZNumberTool saveNumberPasswordEnableState:sw.on];
    
    
    NSLog(@"%d",[LZNumberTool getNumberPasswordEnableState]);
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        //进入密码设置界面
        LZPasswordViewController *password = [[LZPasswordViewController alloc]initWithState:indexPath.row];
        switch (indexPath.row) {
            case 0:
                password.title = @"设置密码";
                NSLog(@"设置密码");
                [self.navigationController pushViewController:password animated:YES];
                break;
            case 1:
                password.title = @"验证密码";
                NSLog(@"验证密码");
                [self.navigationController pushViewController:password animated:YES];
                break;
            case 2:
                password.title = @"更改密码";
                NSLog(@"更改密码");
                [self.navigationController pushViewController:password animated:YES];
                break;
            default:
                break;
        }

        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 安全退出按钮
-(void)exitClickButton{
    UIAlertController * alertCtr = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出吗！" preferredStyle:UIAlertControllerStyleActionSheet];
    //alertCtr.view.alpha = 0.2f;setCornerRadius
    //[alertCtr.view.layer setFrame:CGRectMake(0, 0, 100, 100)]; //设置矩形四个圆角半径
    alertCtr.view.layer.cornerRadius = 1.0f;
    
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //do something
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        UIWindow *window = app.window;
        [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
        } completion:^(BOOL finished) {
        exit(0);
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //do something
    }];
    
    [alertCtr addAction:exitAction];
    [alertCtr addAction:cancelAction];
    [self presentViewController: alertCtr animated: YES completion: nil];
}
@end

//
//  NumLockViewController.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/10/10.
//  Copyright © 2016年 topsec. All rights reserved.
//  密码验证界面

#import "NumLockViewController.h"
#import "NumLockButton.h"
#define __MainScreen_Height [[UIScreen mainScreen] bounds].size.height

@interface NumLockViewController ()
{
    NSMutableString * _numlockStr;
    NSMutableString * _rightStr;
    UIView * _dropV;
}
@end

@implementation NumLockViewController

- (void)dealloc
{
    _numlockStr = nil;
    _rightStr = nil;
    _dropV = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _numlockStr = [[NSMutableString alloc] initWithCapacity:4];
    _rightStr = [[NSMutableString alloc] initWithString:@"1234"];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:145/255.0f blue:64/255.0f alpha:1.0];
    [self initNumLockKeyboard];
    [self initSmallDrop];
    UILabel * hintLa = [[UILabel alloc] initWithFrame:CGRectMake(0, (__MainScreen_Height - 218)/2 - 80, self.view.frame.size.width, 23)];
    hintLa.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hintLa];
    hintLa.text = @"输入密码";
    hintLa.textColor = [UIColor whiteColor];
    UIButton * deleteBu = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBu setFrame:CGRectMake((self.view.frame.size.width/3)*2, __MainScreen_Height - 60, self.view.frame.size.width/3, 20)];
    [deleteBu setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBu addTarget:self action:@selector(deleteNumlock) forControlEvents:UIControlEventTouchUpInside];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg4.jpg"] ];
    self.view.backgroundColor = [UIColor colorWithRed:250/255.0f green:167/255.0f blue:28/255.0f alpha:1];
    [self.view addSubview:deleteBu];
}

- (void)deleteNumlock
{
    if (_numlockStr.length > 0)
    {
        NSString * numStr = [_numlockStr substringToIndex:_numlockStr.length - 1];
        [_numlockStr setString:numStr];
        UIImageView * dropImg = (UIImageView *)[self.view viewWithTag:_numlockStr.length + 2000];
        
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.4;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        [dropImg setImage:[UIImage imageNamed:@"drop"]];
        [[dropImg layer] addAnimation:animation forKey:@"animation"];
    }
}
#pragma mark - 初始化数字密码键盘

- (void)initNumLockKeyboard
{
    for (int i = 0; i < 10; i++)
    {
        
        NumLockButton * numBu;
        if (i == 0)
        {
            numBu = [[NumLockButton alloc] initWithNumber:i letters:@""];
            [numBu setFrame:CGRectMake((self.view.frame.size.width/2)-32, (__MainScreen_Height - 218)/2 + 228, 64, 64)];
        }
        else
        {
            numBu = [[NumLockButton alloc] initWithNumber:i letters:[self lettersForNum:i]];
            [numBu setFrame:CGRectMake((self.view.frame.size.width-238)/2 + (i-1)%3*87, (__MainScreen_Height - 218)/2+(i-1)/3*76, 64, 64)];
        }
        numBu.tag = 1000 + i;
        [numBu addTarget:self action:@selector(numButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:numBu];
        
    }
}

- (NSString *)lettersForNum:(NSUInteger)num
{
    switch (num)
    {
        case 1:
        {
            return @" ";
            break;
        }
        case 2:
        {
            return @"ABC";
            break;
        }
        case 3:
        {
            return @"DEF";
            break;
        }
        case 4:
        {
            return @"GHI";
            break;
        }
        case 5:
        {
            return @"JKL";
            break;
        }
        case 6:
        {
            return @"MNO";
            break;
        }
        case 7:
        {
            return @"PQRS";
            break;
        }
        case 8:
        {
            return @"TUV";
            break;
        }
        case 9:
        {
            return @"WXYZ";
            break;
        }
        default:
        {
            return @"";
        }
    
    }
    return nil;
}


#pragma mark - 初始化密码小圆点
- (void)initSmallDrop
{
    _dropV = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-55, (__MainScreen_Height - 218)/2 - 40, 110, 12)];
    _dropV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_dropV];
    for (int i = 0; i < 4; i ++)
    {
        UIImageView *dropImg = [[UIImageView alloc] initWithFrame:CGRectMake(i * _dropV.frame.size.width/3.5, 0, 12, 12)];
        [_dropV addSubview:dropImg];
        dropImg.tag = 2000 + i;
        [dropImg setImage:[UIImage imageNamed:@"drop"]];
    }
}

- (void)numButtonPressed:(UIButton *)sender
{
    if (_numlockStr.length < 4)
    {
        [_numlockStr appendFormat:@"%lu",sender.tag - 1000];
        NSLog(@"------%@",_numlockStr);
        UIImageView * dropImg = (UIImageView *)[self.view viewWithTag:_numlockStr.length + 2000 - 1];
    
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.4;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        [dropImg setImage:[UIImage imageNamed:@"drop_selected"]];
        [[dropImg layer] addAnimation:animation forKey:@"animation"];
        if (_numlockStr.length == 4)
        {
            //获取沙盒中设置密码的信息判断输入密码与设置的密码是否一样
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            //沙盒中 Boolean 值默认为 false
            NSMutableString * lockpassword = [userDefault objectForKey:@"numberPasswordValueKey"];
            _rightStr = lockpassword;
            
            if ([_numlockStr isEqualToString:_rightStr])
            {
#pragma mark 判断进入密码验证界面通过方式 如果switch
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                //沙盒中 Boolean 值默认为 false；
                Boolean  intopassword = [userDefault boolForKey:@"intopassword"];
                
                Boolean   loging   = [userDefault boolForKey:@"logining"];

                
                
                
                if(intopassword){//判断是点击home键刮起 还是通过点击app进入  如果是true 则是点击app进入
                    [self.view removeFromSuperview];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchRnootVCNotificatio" object:nil];
                    
                }else if(loging){
                
                    [self.view removeFromSuperview];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchRnootVCNotificatio" object:nil];
                
                }
                else{
                    //表示通过点击home键进入 密码输入正确后 移除view
                    
                    [self.view removeFromSuperview];
                    
                }


            }
            else
            {
                [self startShake:_dropV];
                [_numlockStr setString:@""];
                for (int i = 0; i < 4; i ++)
                {
                    UIImageView *dropImg = (UIImageView *)[self.view viewWithTag:2000 + i];
                    [dropImg setImage:[UIImage imageNamed:@"drop"]];
                }
            }
        }
    }
}

#pragma mark - 拖动晃动
- (void)startShake:(UIView* )imageV
{
    // 晃动次数
    static int numberOfShakes = 4;
    // 晃动幅度（相对于总宽度）
    static float vigourOfShake = 0.04f;
    // 晃动延续时常（秒）
    static float durationOfShake = 0.5f;
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 方法一：绘制路径
    CGRect frame = imageV.frame;
    // 创建路径
    CGMutablePathRef shakePath = CGPathCreateMutable();
    // 起始点
    CGPathMoveToPoint(shakePath, NULL, CGRectGetMidX(frame), CGRectGetMidY(frame));
    for (int index = 0; index < numberOfShakes; index++)
    {
        // 添加晃动路径,固定路径
        CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX(frame) - 20.0f,CGRectGetMidY(frame));
        CGPathAddLineToPoint(shakePath, NULL,  CGRectGetMidX(frame) + 20.0f,CGRectGetMidY(frame));

//         // 添加晃动路径 幅度由大变小
//         CGPathAddLineToPoint(shakePath, NULL, CGRectGetMidX(frame) - frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
//         CGPathAddLineToPoint(shakePath, NULL,  CGRectGetMidX(frame) + frame.size.width * vigourOfShake*(1-(float)index/numberOfShakes),CGRectGetMidY(frame));
    }
     // 闭合
     CGPathCloseSubpath(shakePath);
     shakeAnimation.path = shakePath;
     shakeAnimation.duration = durationOfShake;
     // 释放
     CFRelease(shakePath);
    [imageV.layer addAnimation:shakeAnimation forKey:kCATransition];
    
//    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//    shakeAnimation.duration = 0.08;
//    shakeAnimation.autoreverses = YES;
//    shakeAnimation.repeatCount = 5;
//    shakeAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(imageV.frame.origin.x - 50, imageV.frame.origin.y, imageV.frame.size.width, imageV.frame.size.height)];//[NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, -0.06, 0, 0, 1)];
//    shakeAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(imageV.frame.origin.x - 50, imageV.frame.origin.y, imageV.frame.size.width, imageV.frame.size.height)];//[NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, 0.06, 0, 0, 1)];
//    [imageV.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
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

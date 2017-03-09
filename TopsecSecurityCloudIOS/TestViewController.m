//
//  TestViewController.m
//  GunDongView
//
//  Created by 孟仁杰 on 16/8/4.
//  Copyright © 2016年 孟仁杰. All rights reserved.
//

#import "TestViewController.h"
#import "TestCell.h"

@interface TestViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *baseTableView;
@property (nonatomic, assign) NSInteger index;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _baseTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.rowHeight=88;
    [_baseTableView registerNib:[UINib nibWithNibName:@"TestCell" bundle:nil] forCellReuseIdentifier:@"TestCell"];
    [self.view addSubview:_baseTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell" forIndexPath:indexPath];
    //cell.textLabel.text = [NSString stringWithFormat:@"第%ld个，my name is ...", (long)_index];
    
    return cell;
}


- (void)setUpWhenViewWillAppearForTitle:(NSString *)title forIndex:(NSInteger)index firstTimeAppear:(BOOL)isFirstTime {
    if (isFirstTime) {
        NSLog(@"=============第%ld个", (long)index);
        _index = index;
        [self.baseTableView reloadData];
        // 可以做自己想操作的，比如网络请求
    }
}

@end

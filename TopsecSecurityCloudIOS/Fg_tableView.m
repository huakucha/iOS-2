//
//  Fg_tableView.m
//  支付宝跟新demo
//
//  Created by zgy_smile on 16/8/12.
//  Copyright © 2016年 zgy_smile. All rights reserved.
//

#import "Fg_tableView.h"
#import "MJRefresh.h"
#import "TasklistTableViewCell.h"
#import "TasklistCellData.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface Fg_tableView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray  *tgArry;
@end

@implementation Fg_tableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.dataSource = self;
        self.delegate = self;
       // self.rowHeight = (kHeight * 5 - 310) / 40;
        self.rowHeight =105;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:nil];
    }
    return self;
}

-(void)setContentOffsetY:(CGFloat)contentOffsetY {
    
    _contentOffsetY = contentOffsetY;
    if (![self.mj_header isRefreshing]) {
        
        self.contentOffset = CGPointMake(0, contentOffsetY);
    }
}

-(void)startRefreshing {
    [self.mj_header beginRefreshing];
}
-(void)endRefreshing {
    [self.mj_header endRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

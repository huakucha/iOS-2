//
//  CollectionViewCell.m
//  collectionTest
//
//  Created by 土豆vs7 on 2016/11/11.
//  Copyright © 2016年 Topsec. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
    
        self.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0];

    
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.frame)-20, CGRectGetWidth(self.frame)-20)];
        
        self.imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.imageView];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), CGRectGetWidth(self.frame), 15)];
        //self.text.backgroundColor = [UIColor whiteColor];
        self.text.textAlignment = NSTextAlignmentCenter;
        //self.text.textColor = [UIColor colorWithRed:165/255.0f green:165/255.0f blue:165/255.0f alpha:1.0];
        self.text.font=[UIFont fontWithName:@"Helvetica" size:12.f];
        [self addSubview:self.text];
        
        
        
    }
    return self;
}

@end

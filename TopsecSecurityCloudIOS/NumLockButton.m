//
//  NumLockButton.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/10/10.
//  Copyright © 2016年 topsec. All rights reserved.
//  密码验证界面

#import "NumLockButton.h"

@implementation NumLockButton

- (instancetype)initWithNumber:(NSUInteger)number letters:(NSString *)letters
{
    self = [super init];
    if (self)
    {
         _number = number;
         _letters = letters;
        [self setBackgroundImage:nil forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"passnumberbg"] forState:UIControlStateHighlighted];
//      self.backgroundColor = [UIColor blueColor];
        self.layer.cornerRadius = 64.0 / 2.0f;
        self.layer.borderWidth = 1.0f;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [[UIColor whiteColor]CGColor];
//      [self setTitle:[NSString stringWithFormat:@"%lu",number] forState:UIControlStateNormal];
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 64, 23)];
        _numberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)number];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:30.0f];
        [self addSubview:_numberLabel];
        if (letters)
        {
            _lettersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, 64, 10)];
            _lettersLabel.text = letters;
            _lettersLabel.textColor = [UIColor whiteColor];
            _lettersLabel.textAlignment = NSTextAlignmentCenter;
            _lettersLabel.font = [UIFont systemFontOfSize:9.0f];
            [self addSubview:_lettersLabel];
        }
//
//        [self tintColorDidChange];
    }
    return self;
}

- (void)pressed:(UIButton *)sender
{
}
- (void)tintColorDidChange
{
    self.layer.borderColor = [self.tintColor CGColor];
    self.numberLabel.textColor = self.tintColor;
    self.lettersLabel.textColor = self.tintColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

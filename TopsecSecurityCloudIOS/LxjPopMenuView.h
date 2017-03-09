//
//  LxjPopMenuView.h
//  TopsecSecurityCloudIOS
//
//  Created by 土豆vs7 on 16/11/2.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxjPopMenuitem.h"
typedef void (^LXJPopMenuViewSelectBlock)(NSInteger index);

@protocol LXJPopMenuViewSelectDelegate <NSObject>
-(void)popMenuViewSelectIndex:(NSInteger)index;
@end
@interface LxjPopMenuView : UIView

//为了效果好看，菜单数仅支持 12以内，2或者3倍数
@property (nonatomic, copy) NSArray *menuItems;

@property (nonatomic, copy) LXJPopMenuViewSelectBlock selectBlock;
@property (nonatomic, assign) id<LXJPopMenuViewSelectDelegate> delegate;

+ (instancetype)menuView;
+ (instancetype)menuViewWithItems:(NSArray*)items;
- (void)show;

@end

@interface UIView (Additions)
- (CABasicAnimation *)fadeIn;
- (CABasicAnimation *)fadeOut;

@end

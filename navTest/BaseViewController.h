//
//  BaseViewController.h
//  navTest
//
//  Created by jacky on 14-10-13.
//  Copyright (c) 2014年 jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
//防止controller循环引用，使用weak引用方式
@property(nonatomic,weak) BaseViewController* parentController;
//为了能够了解某个页面控制器生命周期相关信息，给该控制器取个名字
@property(nonatomic,copy)   NSString*   ctrlName;
-(void) doDismiss;
@end

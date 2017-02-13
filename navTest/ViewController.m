//
//  ViewController.m
//  navTest
//
//  Created by jacky on 14-10-13.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()
- (IBAction)ClickToEnterSecondController:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    self.ctrlName = @"mainViewCtrl";
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ClickToEnterSecondController:(id)sender {
    SecondViewController* ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"second"];
    ctrl.parentController = self;
    ctrl.ctrlName = @"SecondViewController";
    [self presentViewController:ctrl animated:YES completion:^(void)
     {
         NSLog(@"%@ present end",self.ctrlName);
     }];
}
@end

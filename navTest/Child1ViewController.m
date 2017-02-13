//
//  Child1ViewController.m
//  navTest
//
//  Created by jacky on 14-10-13.
//  Copyright (c) 2014年 jacky. All rights reserved.
//

#import "Child1ViewController.h"

@interface Child1ViewController ()
- (IBAction)returnMainViewController:(id)sender;

@end

@implementation Child1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)returnMainViewController:(id)sender {
    NSLog(@"**********************doDismiss*********************");
    [self doDismiss];
}
@end

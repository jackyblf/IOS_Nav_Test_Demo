//
//  SecondViewController.m
//  navTest
//
//  Created by jacky on 14-10-13.
//  Copyright (c) 2014年 jacky. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

- (IBAction)toChild2:(id)sender;
- (IBAction)toChild1:(id)sender;

@end

@implementation SecondViewController

- (IBAction)GCDTestClick:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSLog(@"message from other thread");
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          NSLog(@"msessage from main thread");
                                      });
                       
                   });
}

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

- (IBAction)toChild2:(id)sender {
    SecondViewController* ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"child2"];
    ctrl.parentController = self;
    ctrl.ctrlName = @"Child2ViewController";
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (IBAction)toChild1:(id)sender {
    SecondViewController* ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"child1"];
    ctrl.parentController = self;
    ctrl.ctrlName = @"Child1ViewController";
    [self presentViewController:ctrl animated:YES completion:nil];
}
@end

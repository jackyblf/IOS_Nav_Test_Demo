//
//  BaseViewController.m
//  navTest
//
//  Created by jacky on 14-10-13.
//  Copyright (c) 2014年 jacky. All rights reserved.
//

#import "BaseViewController.h"
#import "ViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) init
{
    self.ctrlName = @"";
    self.parentController = nil;
    return [super init];
}

- (void)viewDidLoad
{
    NSLog(@"%@ invoke viewDidLoad",self.ctrlName);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@ invoke viewWillAppear",self.ctrlName);
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@ invoke viewDidAppear",self.ctrlName);
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    NSLog(@"%@ invoke viewWillDisappear",self.ctrlName);
    [super viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"%@ invoke viewDidDisappear",self.ctrlName);
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"%@ invoke didReceiveMemoryWarning",self.ctrlName);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"%@ .......dealloc.......",self.ctrlName);
}

-(void)doDismiss
{
    NSLog(@"%@ dismiss begin",self.ctrlName);
    
    if([self.parentController isKindOfClass:[ViewController class]])
    {
        [self dismissViewControllerAnimated:YES completion: ^(void)
         {
             NSLog(@"%@ dismiss end",self.ctrlName);
             
             if(self.parentController)
             {
                 [self.parentController doDismiss];
             }
         }];
    }
    else
    {
        [self dismissViewControllerAnimated:NO completion: ^(void)
         {
             NSLog(@"%@ dismiss end",self.ctrlName);
             
             if(self.parentController)
             {
                 [self.parentController doDismiss];
             }
         }];
        
    }
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

@end

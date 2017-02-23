###1、背景:
2014年4月份第一次接触IOS端开发，为某银行开发一款金融app。
在开发的最后阶段，加入了需要从任意一个页面直接返回主页的功能。
悲催的是，当时没有使用UINavigationController进行导航管理，而是使用了IOS中的模态跳转方式(***presentViewController/dismissViewControllerAnimated***).

因此需要找的一种方法进行，实现如下方式的导航跳转:
####已知： 页面a-->页面b-->页面c
####求解： 页面c直接跳回到页面a，并且要求不能有内存泄露，循环依赖等

###2、解题思考:
面对上面的需求，最简单的方式是将所有控制器都改成UINavigationController，并且利用***pushViewController / popToViewController/ popToRootViewControllerAnimated*** 等方法进行完美解题。但是当时项目的页面将近100个，分成三大模块，需要大规模修改设计页面以及调整大量代码，这并不是一个现实的解决方案，不到万不得已，不能采取如此低劣手段!

我们需要一个满足如下条件的解决方案:
    
    1) 对于已经在InterfaceBuilder中完成的页面，不做任何修改
    2) 尽量少的修改代码，因为很多代码已经经过测试中心测试过，如果修改，需要全部重新测试，时间来不及。

当时通过两天的研究，深入的了解了IOS中的跳转流程和生命周期后，找到了一个相对完美的解决方案，能够满足上面提到的要求。通过一个Demo，来和大家一起分享。

###3、解题流程:

    1) 为了减少代码的修改，增加一个基类。
```
@interface BaseViewController : UIViewController

//防止controller循环引用，使用weak引用方式
@property(nonatomic,weak) BaseViewController* parentController;

//为了能够了解某个页面控制器生命周期相关信息，给该控制器取个名字
@property(nonatomic,copy)   NSString*   ctrlName;

//关键的函数，进行页面c-->跳转到主页
-(void) doDismiss;

@end
```

    2) 为了更好的了解IOS中ViewController的生命周期，我们在基类中输出相关信息来了解生命周期相关信息。

```
@implementation BaseViewController

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
```

    3) 关键的递归函数，核心是理解dismissViewControllerAnimated:completion函数中completion回调的时机点，这个是解题的钥匙。

```
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
```
                                                                                                 
    4) Demo页面结构如下图: MainViewController-->SecondViewController-->Child1ViewController,然后直接跳回到MainViewController.

    5) 所有的ViewController都继承自我们自定义的BaseViewController，具有关键的doDismiss递归方法！
     
![1.png](http://upload-images.jianshu.io/upload_images/2635028-8c073722f17bfef6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

    6) 看一下从MainViewController-->SecondViewController-->Child1ViewController-->MainViewController生命周期的相关信息:

a、启动程序，进入MainViewController：
2017-02-11 17:25:16.964 navTest[933:17086] mainViewCtrl invoke viewDidLoad
2017-02-11 17:25:16.966 navTest[933:17086] mainViewCtrl invoke viewWillAppear
2017-02-11 17:25:16.975 navTest[933:17086] mainViewCtrl invoke viewDidAppear

b、从MainViewController-->SecondViewController：
2017-02-11 17:28:29.717 navTest[933:17086] SecondViewController invoke viewDidLoad **[先newController调用viewDidLoad]**
2017-02-11 17:28:29.721 navTest[933:17086] mainViewCtrl invoke viewWillDisappear **[然后oldController调用viewWillDisappear]**
2017-02-11 17:28:29.722 navTest[933:17086] SecondViewController invoke viewWillAppear **[然后newController调用viewWillAppear]**
2017-02-11 17:28:30.229 navTest[933:17086] SecondViewController invoke viewDidAppear **[然后newController调用viewDidAppear ]**
2017-02-11 17:28:30.229 navTest[933:17086] mainViewCtrl invoke viewDidDisappear **[然后oldController调用viewDidDisappear ]**
2017-02-11 17:28:30.230 navTest[933:17086] mainViewCtrl present end 
**[最后oldController调用presentViewController完成回调被调用]** 

下面是presentViewController完成回调信息的输出代码，用来了解completion是在哪个阶段被调用的，很重要的信息哦！！！
```
- (IBAction)ClickToEnterSecondController:(id)sender {
    SecondViewController* ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"second"];
    ctrl.parentController = self;
    ctrl.ctrlName = @"SecondViewController";
    [self presentViewController:ctrl animated:YES completion:^(void)
     {
         NSLog(@"%@ present end",self.ctrlName);
     }];
}
```

c、从Child1ViewController直接返回到MainViewController的流程(跳过SecondViewController)
```
- (IBAction)returnMainViewController:(id)sender {
    NSLog(@"**********************doDismiss*********************");
    [self doDismiss];
}
```
d、2017-02-11 17:30:30.634 navTest[933:17086] **********************doDismiss********************* **[要开始调用doDismiss函数了，表示点击了返回按钮]**
2017-02-11 17:30:30.635 navTest[933:17086] Child1ViewController dismiss begin  **[输出dismiss begin，表示调用了Child1ViewController的doDismiss递归函数]** 
2017-02-11 17:30:30.637 navTest[933:17086] Child1ViewController invoke viewWillDisappear **[oldController viewWillDisappear]**
2017-02-11 17:30:30.638 navTest[933:17086] SecondViewController invoke viewWillAppear **[newController viewWillAppear]**
2017-02-11 17:30:30.641 navTest[933:17086] SecondViewController invoke viewDidAppear **[newController viewDidAppear]**
2017-02-11 17:30:30.641 navTest[933:17086] Child1ViewController invoke viewDidDisappear **[oldController viewDidDisappear ]**
2017-02-11 17:30:30.641 navTest[933:17086] Child1ViewController dismiss end **[关键时刻哦，oldController self dismissViewControllerAnimated: completion: 中的completion 回调被触发了，它是在 oldController viewDidDisappear后被触发的哦]**
2017-02-11 17:30:30.641 navTest[933:17086] SecondViewController dismiss begin **[这时候，从ChildViewController回弹到SecondViewController的流程完成了，接下来递归调用，要完成从SecondViewController回弹到MainViewController的过程，重复上面的流程而已]**
2017-02-11 17:30:30.642 navTest[933:17086] Child1ViewController .......dealloc....... **[Child1ViewController已经完全消失了，因此内存被析构了，这样确保内存不会泄露哦]**

###下面是递归部分，和上面流程一样，只是从SecondViewController回跳到MainViewController

2017-02-11 17:30:30.643 navTest[933:17086] SecondViewController invoke viewWillDisappear
2017-02-11 17:30:30.644 navTest[933:17086] mainViewCtrl invoke viewWillAppear
2017-02-11 17:30:31.156 navTest[933:17086] mainViewCtrl invoke viewDidAppear
2017-02-11 17:30:31.156 navTest[933:17086] SecondViewController invoke viewDidDisappear
2017-02-11 17:30:31.156 navTest[933:17086] SecondViewController dismiss end
2017-02-11 17:30:31.157 navTest[933:17086] mainViewCtrl dismiss begin
2017-02-11 17:30:31.157 navTest[933:17086] SecondViewController .......dealloc.......  **[SecondViewController 内存也很完美的被析构掉，目前仅剩下MainViewController还活着]**

show一下某银行APP以前模拟器中的效果截图,IOS开发还是非常令人非常愉悦的感觉！
![6976B933D3E1A75AA556C2BFEF934525.png](http://upload-images.jianshu.io/upload_images/2635028-de14cef6a37dff06.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




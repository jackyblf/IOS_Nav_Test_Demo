# IOS_Nav_Test_Demo
The demo for nav test 

1、启动程序，进入MainViewController：
2017-02-11 17:25:16.964 navTest[933:17086] mainViewCtrl invoke viewDidLoad
2017-02-11 17:25:16.966 navTest[933:17086] mainViewCtrl invoke viewWillAppear
2017-02-11 17:25:16.975 navTest[933:17086] mainViewCtrl invoke viewDidAppear

2、从MainViewController-->SecondViewController：
2017-02-11 17:28:29.717 navTest[933:17086] SecondViewController invoke viewDidLoad [先newController调用viewDidLoad]
2017-02-11 17:28:29.721 navTest[933:17086] mainViewCtrl invoke viewWillDisappear [然后oldController调用viewWillDisappear]
2017-02-11 17:28:29.722 navTest[933:17086] SecondViewController invoke viewWillAppear [然后newController调用viewWillAppear]
2017-02-11 17:28:30.229 navTest[933:17086] SecondViewController invoke viewDidAppear [然后newController调用viewDidAppear ]
2017-02-11 17:28:30.229 navTest[933:17086] mainViewCtrl invoke viewDidDisappear [然后oldController调用viewDidDisappear ]
2017-02-11 17:28:30.230 navTest[933:17086] mainViewCtrl present end
[最后oldController调用presentViewController完成回调被调用]

3、2017-02-11 17:30:30.634 navTest[933:17086] **doDismiss* [要开始调用doDismiss函数了，表示点击了返回按钮]
2017-02-11 17:30:30.635 navTest[933:17086] Child1ViewController dismiss begin [输出dismiss begin，表示调用了Child1ViewController的doDismiss递归函数]
2017-02-11 17:30:30.637 navTest[933:17086] Child1ViewController invoke viewWillDisappear [oldController viewWillDisappear]
2017-02-11 17:30:30.638 navTest[933:17086] SecondViewController invoke viewWillAppear [newController viewWillAppear]
2017-02-11 17:30:30.641 navTest[933:17086] SecondViewController invoke viewDidAppear [newController viewDidAppear]
2017-02-11 17:30:30.641 navTest[933:17086] Child1ViewController invoke viewDidDisappear [oldController viewDidDisappear ]
2017-02-11 17:30:30.641 navTest[933:17086] Child1ViewController dismiss end [关键时刻哦，oldController self dismissViewControllerAnimated: completion: 中的completion 回调被触发了，它是在 oldController viewDidDisappear后被触发的哦]
2017-02-11 17:30:30.641 navTest[933:17086] SecondViewController dismiss begin [这时候，从ChildViewController回弹到SecondViewController的流程完成了，接下来递归调用，要完成从SecondViewController回弹到MainViewController的过程，重复上面的流程而已]
2017-02-11 17:30:30.642 navTest[933:17086] Child1ViewController .......dealloc....... [Child1ViewController已经完全消失了，因此内存被析构了，这样确保内存不会泄露哦]

下面是递归部分，和上面流程一样，只是从SecondViewController回跳到MainViewController

2017-02-11 17:30:30.643 navTest[933:17086] SecondViewController invoke viewWillDisappear
2017-02-11 17:30:30.644 navTest[933:17086] mainViewCtrl invoke viewWillAppear
2017-02-11 17:30:31.156 navTest[933:17086] mainViewCtrl invoke viewDidAppear
2017-02-11 17:30:31.156 navTest[933:17086] SecondViewController invoke viewDidDisappear
2017-02-11 17:30:31.156 navTest[933:17086] SecondViewController dismiss end
2017-02-11 17:30:31.157 navTest[933:17086] mainViewCtrl dismiss begin
2017-02-11 17:30:31.157 navTest[933:17086] SecondViewController .......dealloc....... [SecondViewController 内存也很完美的被析构掉，目前仅剩下MainViewController还活着]




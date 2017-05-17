//
//  DetailViewController.m
//  ReactiveCocoaLearn
//
//  Created by 杨永刚 on 2017/5/16.
//  Copyright © 2017年 gg. All rights reserved.
//

#import "DetailViewController.h"
#import <ReactiveCocoa.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.navTitle;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signal {
    //RACSubscriber:表示订阅者，用于发送信号，这是一个协议，只要遵循这个协议，并且实现方法才能成为订阅者。通过create创建的信号，都有一个订阅者，帮助他发送数据
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //如果需要可以将subscriber保存，以防被取消
        //发送信号
        [subscriber sendNext:@1];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@2];
        });
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"默认信号发送完毕被取消");
        }];
    }];
    //RACDisposable：用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它
    //订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        
        NSLog(@"%@", x);
    }];
    [disposable dispose];//取消订阅
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

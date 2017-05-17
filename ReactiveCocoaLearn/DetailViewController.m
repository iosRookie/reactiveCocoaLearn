//
//  DetailViewController.m
//  ReactiveCocoaLearn
//
//  Created by 杨永刚 on 2017/5/16.
//  Copyright © 2017年 gg. All rights reserved.
//

#import "DetailViewController.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACReturnSignal.h>
#import "CustomView.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet CustomView *customView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.navTitle;
    if ([self.title isEqualToString:@"RACSignal"]) {
        [self signal];
    }
    if ([self.title isEqualToString:@"RACSubject"]) {
        [self subject];
    }
    if ([self.title isEqualToString:@"RACTuple和RACSequence"]) {
        [self tupleAndSequence];
    }
    if ([self.title isEqualToString:@"RACMulticastConnection"]) {
        [self multicastConnection];
    }
    if ([self.title isEqualToString:@"RACCommand"]) {
        [self command];
    }
    if ([self.title isEqualToString:@"ReactiveCocoaMacro"]) {
        [self macro];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signal {
    //RACSignal继承自RACStream
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

- (void)subject {
    //RACSubject 继承自RACSignal,信号提供者，自己可以充当信号，又能发送信号。
    //创建信号
    RACSubject *subject = [RACSubject subject];
    //订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者一%@", x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者二%@", x);
    }];
    //发送信号
    [subject sendNext:@"111"];
    
    
    [self replaySubject];
}

- (void)replaySubject {
    RACReplaySubject *replay = [RACReplaySubject subject];
    
    [replay sendNext:@"111"];
   
    RACDisposable *disposable = [replay subscribeNext:^(id x) {
         NSLog(@"replaySubject订阅者一%@", x);
    }];
    [replay sendNext:@"2222"];
//    [disposable dispose];
    
    [replay subscribeNext:^(id x) {
        NSLog(@"replaySubject订阅者二%@", x);
    }];
    
     [replay sendNext:@"3333"];
    
    [replay subscribeNext:^(id x) {
        NSLog(@"replaySubject订阅者三%@", x);
    }];
}

- (void)tupleAndSequence {
    NSArray *array = @[@1, @2, @3];
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    NSDictionary *dict = @{@"name":@"张三",@"age":@"20",@"sex":@"男"};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"%@---%@",key,value);
    }];
    
    [array.rac_sequence map:^id(id value) {
        NSLog(@"%@", value);
        return value;
    }];
}

//不理解
- (void)multicastConnection {
    //RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
    // 使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"请求一次");
        [subscriber sendNext:@"1"];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"执行完成");
        }];
    }];
    
    RACMulticastConnection *connection = [signal publish];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第三个订阅者%@",x);
    }];
    
    [connection connect];
}

- (void)command {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //命令内部传递参数
        NSLog(@"input == %@", input);
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"发送数据");
            [subscriber sendNext:@"22"];
             // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"执行完毕");
            }];
        }];
    }];
    
//    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
//        NSLog(@"拿到信号的方式二%@",x);
//    }];
    
    [[command execute:@"11"] subscribeNext:^(id x) {
        NSLog(@"拿到信号的方式一        %@",x);
    }];
    
//    [command execute:@"33"];
//    [command.executing subscribeNext:^(id x) {
//        if ([x boolValue] == YES) {
//            
//            NSLog(@"命令正在执行");
//        }
//        else {
//            
//            NSLog(@"命令完成/没有执行");
//        }
//    }];
}

- (void)macro {
    RAC(self.label, text) = _textField.rac_textSignal;
    
    //重新绑定
    [[_textField.rac_textSignal bind:^RACStreamBindBlock{
        return ^RACStream *(id value, BOOL *stop){
            return [RACReturnSignal return:[NSString stringWithFormat:@"%@", value]];
        };
    }] subscribeNext:^(id x) {
        NSLog(@"bind = %@", x);
    }];
    
    //flattenMap
    [[[_textField.rac_textSignal flattenMap:^RACStream *(id value) {
        return [RACReturnSignal return:[NSString stringWithFormat:@"flattenMap = %@", value]];
    }] flattenMap:^RACStream *(id value) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"内部Signal"];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"内部执行完毕");
            }];
        }];
        [signal subscribeNext:^(id x) {
            NSLog(@"内部 = %@", x);
        }];
        return signal;//[RACReturnSignal return:[NSString stringWithFormat:@"flattenMap2 = %@", value]];
    }] subscribeNext:^(id x) {
        NSLog(@"flattenMap2 = %@", x);
    }];
    
    [[_textField.rac_textSignal flattenMap:^RACStream *(id value) {
         return [RACReturnSignal return:[NSString stringWithFormat:@"flattenMap3 = %@", value]];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //map
    [[[_textField.rac_textSignal map:^id(id value) {
        return [NSString stringWithFormat:@"Map = %@", value];
    }] map:^id(id value) {
        return [NSString stringWithFormat:@"Map2 = %@", value];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    
    [RACObserve(self.label, text) subscribeNext:^(id x) {
        //        NSLog(@"label.text = %@", x);
    }];
    
    RACTuple *tuple = RACTuplePack(@10, @20);
    RACTupleUnpack(NSNumber *number, NSNumber *number1) = tuple;
    
    NSLog(@"%@-%@", number, number1);
    @weakify(self);
    [[self.customView rac_signalForSelector:@selector(clearText:)] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"clear");
        self.textField.text = nil;
    }];
    
    [[self.customView rac_valuesAndChangesForKeyPath:@"content" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [[self.customView.clearBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了Clear");
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘frame发生变化%@", x);
    }];
}

@end

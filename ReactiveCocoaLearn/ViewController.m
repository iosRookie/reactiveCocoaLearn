//
//  ViewController.m
//  ReactiveCocoaLearn
//
//  Created by gg on 15/5/22.
//  Copyright (c) 2015年 gg. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBut;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    RACSignal *nameSignal = [self.nameTextField.rac_textSignal map:^id(id value) {
        return @([(NSString *)value length] > 3);
    }];
    
    RACSignal *passwordSignal = [self.passwordTextField.rac_textSignal map:^id(id value) {
        return @([(NSString *)value length] > 3);
    }];
    
    RAC(self.nameTextField, backgroundColor) = [nameSignal map:^id(id value) {
        return [value boolValue] ? [UIColor whiteColor] : [UIColor yellowColor];
    }];
    

    RAC(self.passwordTextField, backgroundColor) = [passwordSignal map:^id(id value) {
        return [value boolValue] ? [UIColor whiteColor] : [UIColor yellowColor];
    }];
    
    RACSignal *signUpActiveSignal = [RACSignal
                                     combineLatest:@[nameSignal, passwordSignal]
                                     reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
                                         return @([usernameValid boolValue] && [passwordValid boolValue]);
                                    }];
    [signUpActiveSignal subscribeNext:^(id x) {
        self.confirmBut.enabled = [x boolValue];
    } error:^(NSError *error) {
        
    }];
    
    [[[[self.confirmBut rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x) {        //附加操作不做返回，不改变信号本身
           self.confirmBut.enabled = NO;
       }]
      flattenMap:^id(id value) {        //内部信号
          return [self signInSignal];
      }]
     subscribeNext:^(id x){   //订阅
         self.confirmBut.enabled = YES;
         NSLog(@"Sign in result: %@", x);
     }];
    
}

- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id subscriber){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            NSLog(@"login Success");
            [subscriber sendNext:@(YES)];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}













@end

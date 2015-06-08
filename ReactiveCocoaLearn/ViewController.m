//
//  ViewController.m
//  ReactiveCocoaLearn
//
//  Created by gg on 15/5/22.
//  Copyright (c) 2015年 gg. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>
#import <RXCollection.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *namePassword;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *logBut;
@property (strong, nonatomic) NSString *warningText;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.warningText = @"warningText";
    self.namePassword.text = @"12345@";
    
    @weakify(self);
    [[RACObserve(self, warningText) filter:^(NSString *newString) {
      self.titleLabel.text = newString;
      return YES;
      //          return [newString hasPrefix:@"Success"];
    }] subscribeNext:^(NSString *newString) {
      @strongify(self);
      self.logBut.enabled = [newString hasPrefix:@"Success"];
    }];
    
    RAC(self, self.warningText) = [RACSignal
        combineLatest:
            @[ RACObserve(self, self.namePassword.text), RACObserve(self, self.password.text) ]
               reduce:^(NSString *password, NSString *passwordConfirm) {
                 if ([passwordConfirm isEqualToString:password] && [password length] > 0) {
                     return @"Success";
                 } else if ([password length] == 0 || [passwordConfirm length] == 0) {
                     return @"Please Input";
                 } else
                     return @"Input Error";
               }];
               
    [[self.namePassword.rac_textSignal filter:^BOOL(id value) {
      NSString *text = value;
      return text.length > 3;
    }] subscribeNext:^(id x) {
      NSLog(@"%@", x);
    }];
    
    //    [self.namePassword.rac_textSignal subscribeNext:^(id x){
    //        NSLog(@"%@", x);
    //    }];
    [self.password.rac_textSignal subscribeNext:^(id x) {
      NSLog(@"%@", x);
    }];
    //
    //    RACSignal *letters = [@"A B C D E F G H I" componentsSeparatedByString:@"
    //    "].rac_sequence.signal;
    //    // Outputs: A B C D
    //    [letters subscribeNext:^(NSString *x) {
    //        NSLog(@"%@", x);
    //    }];
    
    //    __block unsigned subscriptions = 0;
    //
    //    RACSignal *loggingSignal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber>
    //    subscriber) {
    //        subscriptions++;
    //        [subscriber sendCompleted];
    //        return nil;
    //    }];
    //
    //    // Outputs:
    //    // subscription 1
    //    [loggingSignal subscribeCompleted:^{
    //        NSLog(@"subscription %u", subscriptions);
    //    }];
    //
    //    // Outputs:
    //    // subscription 2
    //    [loggingSignal subscribeCompleted:^{
    //        NSLog(@"subscription %u", subscriptions);
    //    }];
    
    NSArray *array = @[ @(1), @(2), @(3) ];
    NSArray *mapArray = [array rx_mapWithBlock:^id(id each) {
      return @(pow([each integerValue], 2));
    }];
    NSLog(@"%@", [mapArray description]);
    
    NSArray *filterArray = [array rx_filterWithBlock:^BOOL(id each) {
      return ([each integerValue] % 2 == 0);
    }];
    NSLog(@"%@", [filterArray description]);
    
    NSArray *foldArray = [array rx_foldWithBlock:^id(id memo, id each) {
      return @([memo integerValue] + [each integerValue]);
    }];
    NSLog(@"%@", [foldArray description]);
    
    RACSequence *stream = [array rac_sequence];
    id tempArray = [stream map:^id(id value) {
      return @(pow([value integerValue], 2));
    }];
    NSLog(@"%@", [stream array]);
    
    NSLog(@"%@", [tempArray array]);
    
    RACSequence *tempFold = [[[[array rac_sequence] map:^id(id value) {
      return [value stringValue];
    }] filter:^BOOL(id value) {
      return [value intValue] % 2 == 0;
    }] foldLeftWithStart:@""
                   reduce:^id(id accumulator, id value) {
                     return [accumulator stringByAppendingString:value];
                   }];
    NSLog(@"%@", [tempFold description]);
    
    [self.namePassword.rac_textSignal subscribeNext:^(id x) {
      NSLog(@"New value: %@", x);
    } error:^(NSError *error) {
      NSLog(@"Error: %@", error);
    } completed:^{
      NSLog(@"Completed.->%@", self.namePassword.text);
    }];
    
    //根据字符串中是否含有@  来判断logbut是否可用
    //    RAC(self.logBut, enabled) = [self.password.rac_textSignal map:^id(NSString *value) {
    //      return @([value rangeOfString:@"@"].location != NSNotFound);
    //    }];
    
    RACSignal *fiterSignal = [self.namePassword.rac_textSignal filter:^BOOL(id value) {
      return [value length] > 5;
    }];
    RACSignal *validEmailSignal = [self.namePassword.rac_textSignal map:^id(NSString *value) {
      return @([value rangeOfString:@"@"].location != NSNotFound);
    }];
    //    RAC(self.logBut, enabled) = validEmailSignal;
    //    RAC(self.namePassword, textColor) = [validEmailSignal map:^id(id value){
    //        if ([value boolValue]) {
    //            return [UIColor greenColor];
    //        } else {
    //            return [UIColor redColor]; }
    //    }];
    
    //在此要特别注意 self.logBut 必须是RACSignal可用的状态
    //    self.logBut.rac_command = [[RACCommand alloc] initWithEnabled:validEmailSignal
    //    signalBlock:^RACSignal *(id input){
    //         NSLog(@"Button was pressed.");
    //        return [RACSignal empty];
    //     }];
    
//    RAC(self.logInButton, enabled) = [RACSignal combineLatest:@[
//        self.usernameTextField.rac_textSignal,
//        self.passwordTextField.rac_textSignal,
//        RACObserve(LoginManager.sharedManager, loggingIn),
//        RACObserve(self, loggedIn)
//    ] reduce:^(NSString *username, NSString *password, NSNumber *loggingIn, NSNumber *loggedIn) {
//      return @(username.length > 0 && password.length > 0 && !loggingIn.boolValue &&
//               !loggedIn.boolValue);
//    }];
    
    RAC(self.logBut, enabled) = [RACSignal combineLatest:@[self.password.rac_textSignal,self.namePassword.rac_textSignal] reduce:^id(NSString *username, NSString *password){
        return @(([username length] > 5) && ([password length] >= 6));
    }];
}

- (void)setColor
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}













@end

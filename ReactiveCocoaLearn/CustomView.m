//
//  CustomView.m
//  ReactiveCocoaLearn
//
//  Created by 杨永刚 on 2017/5/17.
//  Copyright © 2017年 gg. All rights reserved.
//

#import "CustomView.h"

@interface CustomView ()

@property (weak, nonatomic) IBOutlet UIButton *clearBut;

@end

@implementation CustomView

- (IBAction)clearText:(id)sender {
    self.content = @"123";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

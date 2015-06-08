//
//  TitleCell.h
//  ReactiveCocoaLearn
//
//  Created by gg on 15/6/8.
//  Copyright (c) 2015年 gg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusModels.h"

@interface TitleCellUserData : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *describe;

@end

@interface TitleCell : UITableViewCell<NICell>

@property (nonatomic, strong) TitleCellUserData *userData;

@end

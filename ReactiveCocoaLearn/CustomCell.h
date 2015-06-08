//
//  CustomCell.h
//  NimbusCatalog
//
//  Created by gg on 15/5/18.
//  Copyright (c) 2015年 Nimbus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusCore.h"
#import "NimbusModels.h"

@class CustomCellUserData;

@interface CustomCell : UITableViewCell<NICell>

@property (nonatomic, strong)CustomCellUserData *cellData;

+ (id)createObject:(id)mdelegate userData:(id)muserData;

@end


@interface CustomCellUserData : NSObject

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *buttonStr;

@end






















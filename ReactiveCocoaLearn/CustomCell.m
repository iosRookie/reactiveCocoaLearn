//
//  CustomCell.m
//  NimbusCatalog
//
//  Created by gg on 15/5/18.
//  Copyright (c) 2015年 Nimbus. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell(){
    UILabel *titleLabel;
    UIButton *but;
}

@end


@implementation CustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor redColor]];
        titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:titleLabel];
        
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setBackgroundColor:[UIColor blueColor]];
        [self.contentView addSubview:but];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [titleLabel setFrame:CGRectMake(0, 0, 100, 40)];
    
    [but setFrame:CGRectMake(100, 0, 100, 40)];
}


-(BOOL)shouldUpdateCellWithObject:(id)object
{
    NICellObject *cellData = object;
    CustomCellUserData *data = (CustomCellUserData *)cellData.userInfo;
    titleLabel.text = data.titleStr;
    [but setTitle:data.buttonStr forState:UIControlStateNormal];
    return YES;
}

+ (id)createObject:(id)mdelegate userData:(id)muserData
{
    CustomCellUserData *data = [[CustomCellUserData alloc] init];
    NICellObject *cell = [[NICellObject alloc] initWithCellClass:[self class] userInfo:data];
    return cell;
}

+ (CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return 44;
}

@end


@implementation CustomCellUserData


@end



















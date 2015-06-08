//
//  TitleCell.m
//  ReactiveCocoaLearn
//
//  Created by gg on 15/6/8.
//  Copyright (c) 2015年 gg. All rights reserved.
//

#import "TitleCell.h"

@implementation TitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (BOOL)shouldUpdateCellWithObject:(NICellObject *)object
{
    self.userData = object.userInfo;
    TitleCellUserData *tempData = object.userInfo;
    self.textLabel.text = tempData.title;
    self.detailTextLabel.text = tempData.describe;
    return YES;
}

+(CGFloat)heightForObject:(id)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    return 80;
}

@end


@implementation TitleCellUserData


@end
//
//  MainViewController.m
//  ReactiveCocoaLearn
//
//  Created by gg on 15/6/8.
//  Copyright (c) 2015年 gg. All rights reserved.
//

#import "MainViewController.h"
#import "NimbusModels.h"
#import "TitleCell.h"

@interface MainViewController () {
    UITableView *_myTableView;
    NITableViewModel *_model;
    NITableViewActions *_actions;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _myTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_myTableView];
    
    _actions = [[NITableViewActions alloc] initWithTarget:self];
    
    NSMutableArray *contents = [@[] mutableCopy];
    
    TitleCellUserData *data = [[TitleCellUserData alloc] init];
    NICellObject *cell = [[NICellObject alloc] initWithCellClass:[TitleCell class] userInfo:data];
    data.title = @"reactivecocoa+UITextField";
    data.describe = @"在UITextField使用RAC";
    [_actions attachToClass:[NICellObject class]
            navigationBlock:NIPushControllerAction([MainViewController class])];
    [contents addObject:cell];
    
    TitleCellUserData *data1 = [[TitleCellUserData alloc] init];
    NICellObject *cell1 = [[NICellObject alloc] initWithCellClass:[TitleCell class] userInfo:data1];
    data1.title = @"reactivecocoa+delegate";
    data1.describe = @"用RAC实现Delegate";
    [contents addObject:cell1];
    
    _model = [[NITableViewModel alloc] initWithSectionedArray:contents
                                                     delegate:(id)[NICellFactory class]];
                                                     
    _myTableView.delegate = _actions;
    _myTableView.dataSource = _model;
}

@end

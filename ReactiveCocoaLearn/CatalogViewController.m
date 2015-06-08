//
// Copyright 2011-2014 NimbusKit
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "CatalogViewController.h"

#import <NIActions.h>
#import "NimbusModels.h"
#import "NimbusWebController.h"

//
// What's going on in this file:
//
// This is the root view controller of the Nimbus iPhone Catalog application. It is a table view
// controller that uses Nimbus' table view models features to populate the data source and handle
// user actions. From this controller the user can navigate to any of the Nimbus samples.
//
// You will find the following Nimbus features used:
//
// [models]
// NITableViewModel
// NITableViewActions
// NISubtitleCellObject
//
// This controller requires the following frameworks:
//
// Foundation.framework
// UIKit.framework
//

@implementation CatalogViewController {
    NITableViewModel *_model;
    NITableViewActions *_actions;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"Nimbus Catalog";
        _actions = [[NITableViewActions alloc] initWithTarget:self];
        
        NSMutableArray *contents = [@[] mutableCopy];
        
        NICellObject *cell = [CustomCell createObject:self userData:nil];
        CustomCellUserData *data = cell.userInfo;
        data.titleStr = @"123";
        data.buttonStr = @"but1";
        [_actions attachToClass:[NICellObject class]
                navigationBlock:NIPushControllerAction([CatalogViewController class])];
        [contents addObject:cell];
        
        NICellObject *cellobject = [CustomCell createObject:self userData:nil];
        CustomCellUserData *data2 = cellobject.userInfo;
        data2.titleStr = @"456";
        data2.buttonStr = @"but2";
        NIActionBlock dbBlock = ^(id object, id target, NSIndexPath *indexPath) {
            
            return YES;
        };
        
        _model = [[NITableViewModel alloc] initWithSectionedArray:contents
                                                         delegate:(id)[NICellFactory class]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = _model;
    
    self.tableView.delegate = [_actions forwardingTo:self];
}

@end

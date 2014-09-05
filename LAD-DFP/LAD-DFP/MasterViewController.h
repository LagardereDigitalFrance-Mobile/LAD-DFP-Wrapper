//
//  MasterViewController.h
//  LAD-DFP
//
//  Created by DUPUY Yann on 18/12/12.
//  Copyright (c) 2012-2014 Lagardere Active. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) BannerViewController *detailViewController;

@end

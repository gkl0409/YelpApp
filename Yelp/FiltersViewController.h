//
//  FilterTableViewController.h
//  Yelp
//
//  Created by kaden Chiang on 2015/6/24.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchCell.h"
#import "CheckCell.h"

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>
@required
- (void)filtersViewController:(FiltersViewController *) filtersViewController didChangeFilters:(NSDictionary *)filters;

@end

@interface FiltersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, FilterTableViewCellDelegate>

@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;
@end

//
//  FilterTableViewCell.h
//  Yelp
//
//  Created by kaden Chiang on 2015/6/26.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterTableViewCell;

@protocol FilterTableViewCellDelegate <NSObject>

- (void)filterTableViewCell: (FilterTableViewCell *)cell didUpdateValue: (BOOL)value;

@end

@interface FilterTableViewCell : UITableViewCell

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) id<FilterTableViewCellDelegate> delegate;
@property (nonatomic,assign) BOOL enabled;

@end

//
//  SwitchCell.h
//  Yelp
//
//  Created by kaden Chiang on 2015/6/24.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterTableViewCell.h"

@interface SwitchCell : FilterTableViewCell

@property  (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;

@end

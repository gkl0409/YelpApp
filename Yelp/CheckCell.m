//
//  CheckCell.m
//  Yelp
//
//  Created by kaden Chiang on 2015/6/24.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import "CheckCell.h"

@implementation CheckCell
@dynamic titleLabel;

- (void)awakeFromNib {
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [super setEnabled:selected];
    if (selected) {
        [self setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
}

@end

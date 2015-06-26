//
//  SwitchCell.m
//  Yelp
//
//  Created by kaden Chiang on 2015/6/24.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import "SwitchCell.h"


@interface SwitchCell ()

- (IBAction)onSwitchValueChanged:(id)sender;

@end

@implementation SwitchCell
@dynamic titleLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self.toggleSwitch setOn: selected];
}

- (IBAction)onSwitchValueChanged:(id)sender {
    [self.delegate filterTableViewCell:self didUpdateValue: self.toggleSwitch.on];
}
@end

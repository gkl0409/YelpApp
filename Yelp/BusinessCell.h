//
//  BusinessCellTableViewCell.h
//  Yelp
//
//  Created by kaden Chiang on 2015/6/24.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;

@property (weak, nonatomic) IBOutlet UILabel *reviewNum;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

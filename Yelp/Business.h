//
//  Business.h
//  Yelp
//
//  Created by kaden Chiang on 2015/6/23.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIImageView+AFNetworking.h>

@interface Business : NSObject

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ratingImgUrl;
@property NSInteger reviewCount;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *categories;
@property CGFloat distance;

- (id)initWithDictionary: (NSDictionary *)dictionary;

+ (NSArray *) businessesWithDictionaries: (NSArray *) businessDictionaries;

@end

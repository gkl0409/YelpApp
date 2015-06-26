//
//  Business.m
//  Yelp
//
//  Created by kaden Chiang on 2015/6/23.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

+ (NSArray *)businessesWithDictionaries:(NSArray *)businessDictionaries {

    if (businessDictionaries == nil) return nil;
    
    NSMutableArray *businessArray = [[NSMutableArray alloc] initWithCapacity: [businessDictionaries count]];
    for (NSDictionary *dictionary in businessDictionaries) {
        Business *business = [[Business alloc] initWithDictionary:dictionary];
        [businessArray addObject:business];
    }
    return businessArray;
}

- (id)initWithDictionary: (NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories = [categoryNames componentsJoinedByString:@", "];
        self.name = dictionary[@"name"];
        self.imageUrl = dictionary[@"image_url"];
        NSString *street = [dictionary valueForKeyPath:@"location.address"][0];
        NSString *neighborhood = [dictionary valueForKeyPath:@"location.neighborhoods"][0];
        self.address = [NSString stringWithFormat:@"%@, %@", street, neighborhood];
        self.reviewCount = [dictionary[@"review_count"] integerValue];
        self.ratingImgUrl = dictionary[@"rating_img_url"];
        self.distance = [dictionary[@"distance"] integerValue] * 0.001;
    }
    return self;
}


@end

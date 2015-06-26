//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.titleView = [[UISearchBar alloc] init];
    

    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    [self.client searchWithDict:@{@"term":@"Thai"} success:^(AFHTTPRequestOperation *operation, id response) {
//        NSLog(@"%@", response[@"businesses"]);
        self.businesses = [Business businessesWithDictionaries:response[@"businesses"]];

        // use GCD for best performance
//        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
//            NSLog(@"reload");
//        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters
{
    [self.client searchWithDict:filters success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@",response);
        self.businesses = [Business businessesWithDictionaries:response[@"businesses"]];
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.businesses.count;
    NSLog(@"count %ld", self.businesses.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell" forIndexPath:indexPath];
    
    Business *bus = self.businesses[indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString: bus.imageUrl]];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];

    [cell.imageView.layer setCornerRadius: 3];
    [cell.imageView setClipsToBounds:YES];
    cell.NameLabel.text = bus.name;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", bus.distance];
    [cell.ratingImageView setImageWithURL:[NSURL URLWithString:bus.ratingImgUrl]];
    cell.addressLabel.text = bus.address;
    cell.categoryLabel.text = bus.categories;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     UINavigationController *nvc = [segue destinationViewController];
     FiltersViewController *fvc = nvc.viewControllers[0];
     fvc.delegate = self;
 }

@end

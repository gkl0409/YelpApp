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
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableDictionary *searchParam;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.text = @"";
    self.navigationItem.titleView = self.searchBar;
    self.searchParam = [NSMutableDictionary dictionaryWithObject: self.searchBar.text forKey:@"term"];
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    [self callYelpSearchApi];
}

- (void)callYelpSearchApi
{
    if ([self.searchBar.text isEqualToString:@""]) {
        [self.searchParam removeObjectForKey:@"term"];
    } else {
        [self.searchParam setObject:self.searchBar.text forKey:@"term"];
    }
    NSLog(@"searchParam: %@", self.searchParam);
    [self.client searchWithDict:self.searchParam success:^(AFHTTPRequestOperation *operation, id response) {
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - FiltersViewControllerDelegate
- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters
{
    self.searchParam = [NSMutableDictionary dictionaryWithDictionary:filters];
    [self callYelpSearchApi];
}

# pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.businesses count];
    NSLog(@"tableView numberOfRowsInSection %ld", self.businesses.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableView cellForRowAtIndexPath %ld %ld",indexPath.section, indexPath.row);
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

# pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self callYelpSearchApi];
    
}

# pragma mark - UITableViewDelegate
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

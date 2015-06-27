//
//  FilterTableViewController.m
//  Yelp
//
//  Created by kaden Chiang on 2015/6/24.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"
#import "CheckCell.h"

@interface FiltersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *filters;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) NSArray *numOfsection;
@property (nonatomic, strong) NSArray *cellIdOfSection;
@property (nonatomic, strong) NSArray *textForFilter;
@property (nonatomic, strong) NSArray *valueForFilter;
@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self initCategories];
    self.numOfsection = @[@1, @5, @3, [[NSNumber alloc] initWithUnsignedLong:self.categories.count]];
    self.filters = [NSMutableArray arrayWithArray:@[@"0", @"", @"0", @""]];
    self.cellIdOfSection = @[@"SwitchCell", @"CheckCell", @"CheckCell", @"SwitchCell"];
    self.textForFilter = @[
                           @[@"Offering a Deal"],
                           @[@"Auto", @"100m", @"300m", @"500m", @"1km"],
                           @[@"Best Match", @"Distance", @"Highest Rated"]
                           ];
    self.valueForFilter = @[
                            @[@"1"],
                            @[@"", @"100", @"300", @"500", @"1000"],
                            @[@"0", @"1", @"2"]
                            ];
    self.selectedCategories = [NSMutableSet set];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterTableViewCell:(FilterTableViewCell *)cell didUpdateValue:(BOOL)value
{
    NSLog(@"filterTableViewCell didUpdateValue %d", value);
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    SwitchCell *switchCell = (SwitchCell *)cell;
    switch (indexPath.section) {
        case 0:
            if (switchCell.toggleSwitch.on) {
                self.filters[indexPath.section] = @"1";
            } else {
                self.filters[indexPath.section] = @"0";
            }
        case 3:
            if (switchCell.toggleSwitch.on) {
                [self.selectedCategories addObject:self.categories[indexPath.row][@"code"]];
            } else {
                [self.selectedCategories removeObject:self.categories[indexPath.row][@"code"]];
            }
        default:
            break;
    }
}


- (IBAction)onCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onApply:(id)sender
{

    NSArray *dictKeys = @[@"deals_filter", @"radius_filter", @"sort", @"category_filter"];

    NSArray *sortedCategories = [self.selectedCategories sortedArrayUsingDescriptors:
     @[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO]]
    ];
    
    self.filters[3] = [sortedCategories componentsJoinedByString:@","];
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i< dictKeys.count; i++) {
        if (![self.filters[i] isEqualToString: @""]) {
            [retDict setObject: self.filters[i] forKey:dictKeys[i]];
        }
    }

    NSLog(@"filters: %@", retDict);
    [self.delegate filtersViewController:self didChangeFilters:retDict];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.numOfsection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.numOfsection[section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: self.cellIdOfSection[indexPath.section] forIndexPath:indexPath];
    cell.delegate = self;
    switch(indexPath.section) {
        case 0:                                                                                                                                                                                                                                                                                                                                                                                                                 
        case 1:
        case 2:
            cell.titleLabel.text = self.textForFilter[indexPath.section][indexPath.row];
            break;
        case 3:
            cell.titleLabel.text = self.categories[indexPath.row][@"name"];
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SwitchCell *switchCell;
    CheckCell *checkCell;
    BOOL needSelected;
    switch(indexPath.section) {
        case 0:
            switchCell = (SwitchCell *)cell;
            needSelected = [self.filters[indexPath.section] isEqualToString: self.valueForFilter[indexPath.section][indexPath.row]];
//            NSLog(@"cell %ld %ld %d", indexPath.section, indexPath.row, needSelected);
            [switchCell setSelected:needSelected animated:NO];
            break;
        case 1:
        case 2:
            checkCell = (CheckCell *)cell;
            needSelected = [self.filters[indexPath.section] isEqualToString: self.valueForFilter[indexPath.section][indexPath.row]];
//            NSLog(@"cell %ld %ld %d", indexPath.section, indexPath.row, needSelected);
            [checkCell setSelected:needSelected animated:NO];
            break;
        case 3:
            switchCell = (SwitchCell *)cell;
            needSelected = [self.selectedCategories containsObject:self.categories[indexPath.row][@"code"]];
            [switchCell setSelected:needSelected animated:NO];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SwitchCell *switchCell;
    CheckCell *checkCell;
    switch (indexPath.section) {
        case 0:
            switchCell = (SwitchCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
            
            if (switchCell.toggleSwitch.on) {
                self.filters[indexPath.section] = @"1";
            } else {
                self.filters[indexPath.section] = @"0";
            }
        case 1:
        case 2:
            for (NSInteger i = 0; i < [self.numOfsection[indexPath.section] integerValue]; i++) {
                checkCell = (CheckCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                [checkCell setSelected:(i == indexPath.row)];
            }
            self.filters[indexPath.section] = self.valueForFilter[indexPath.section][indexPath.row];
            break;
        case 3:
            switchCell = (SwitchCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
            if (switchCell.toggleSwitch.on) {
                [self.selectedCategories addObject:self.categories[indexPath.row][@"code"]];
            } else {
                [self.selectedCategories removeObject:self.categories[indexPath.row][@"code"]];
            }
        default:
            break;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *titleOfSection = @[@"", @"Distance", @"Sort By", @"Category"];
    return titleOfSection[section];
}

- (void)initCategories {
    self.categories = @[
                        @{@"name" : @"Afghan", @"code": @"afghani"},
                        @{@"name" : @"African", @"code": @"african"},
                        @{@"name" : @"American, New", @"code": @"newamerican"},
                        @{@"name" : @"American, Traditional", @"code": @"tradamerican"},
                        @{@"name" : @"Arabian", @"code": @"arabian"},
                        @{@"name" : @"Argentine", @"code": @"argentine"},
                        @{@"name" : @"Armenian", @"code": @"armenian"},
                        @{@"name" : @"Asian Fusion", @"code": @"asianfusion"},
                        @{@"name" : @"Asturian", @"code": @"asturian"},
                        @{@"name" : @"Australian", @"code": @"australian"},
                        @{@"name" : @"Austrian", @"code": @"austrian"},
                        @{@"name" : @"Baguettes", @"code": @"baguettes"},
                        @{@"name" : @"Bangladeshi", @"code": @"bangladeshi"},
                        @{@"name" : @"Barbeque", @"code": @"bbq"},
                        @{@"name" : @"Basque", @"code": @"basque"},
                        @{@"name" : @"Bavarian", @"code": @"bavarian"},
                        @{@"name" : @"Beer Garden", @"code": @"beergarden"},
                        @{@"name" : @"Beer Hall", @"code": @"beerhall"},
                        @{@"name" : @"Beisl", @"code": @"beisl"},
                        @{@"name" : @"Belgian", @"code": @"belgian"},
                        @{@"name" : @"Bistros", @"code": @"bistros"},
                        @{@"name" : @"Black Sea", @"code": @"blacksea"},
                        @{@"name" : @"Brasseries", @"code": @"brasseries"},
                        @{@"name" : @"Brazilian", @"code": @"brazilian"},
                        @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch"},
                        @{@"name" : @"British", @"code": @"british"},
                        @{@"name" : @"Buffets", @"code": @"buffets"},
                        @{@"name" : @"Bulgarian", @"code": @"bulgarian"},
                        @{@"name" : @"Burgers", @"code": @"burgers"},
                        @{@"name" : @"Burmese", @"code": @"burmese"},
                        @{@"name" : @"Cafes", @"code": @"cafes"},
                        @{@"name" : @"Cafeteria", @"code": @"cafeteria"},
                        @{@"name" : @"Cajun/Creole", @"code": @"cajun"},
                        @{@"name" : @"Cambodian", @"code": @"cambodian"},
                        @{@"name" : @"Canadian", @"code": @"New)"},
                        @{@"name" : @"Canteen", @"code": @"canteen"},
                        @{@"name" : @"Caribbean", @"code": @"caribbean"},
                        @{@"name" : @"Catalan", @"code": @"catalan"},
                        @{@"name" : @"Chech", @"code": @"chech"},
                        @{@"name" : @"Cheesesteaks", @"code": @"cheesesteaks"},
                        @{@"name" : @"Chicken Shop", @"code": @"chickenshop"},
                        @{@"name" : @"Chicken Wings", @"code": @"chicken_wings"},
                        @{@"name" : @"Chilean", @"code": @"chilean"},
                        @{@"name" : @"Chinese", @"code": @"chinese"},
                        @{@"name" : @"Comfort Food", @"code": @"comfortfood"},
                        @{@"name" : @"Corsican", @"code": @"corsican"},
                        @{@"name" : @"Creperies", @"code": @"creperies"},
                        @{@"name" : @"Cuban", @"code": @"cuban"},
                        @{@"name" : @"Curry Sausage", @"code": @"currysausage"},
                        @{@"name" : @"Cypriot", @"code": @"cypriot"},
                        @{@"name" : @"Czech", @"code": @"czech"},
                        @{@"name" : @"Czech/Slovakian", @"code": @"czechslovakian"},
                        @{@"name" : @"Danish", @"code": @"danish"},
                        @{@"name" : @"Delis", @"code": @"delis"},
                        @{@"name" : @"Diners", @"code": @"diners"},
                        @{@"name" : @"Dumplings", @"code": @"dumplings"},
                        @{@"name" : @"Eastern European", @"code": @"eastern_european"},
                        @{@"name" : @"Ethiopian", @"code": @"ethiopian"},
                        @{@"name" : @"Fast Food", @"code": @"hotdogs"},
                        @{@"name" : @"Filipino", @"code": @"filipino"},
                        @{@"name" : @"Fish & Chips", @"code": @"fishnchips"},
                        @{@"name" : @"Fondue", @"code": @"fondue"},
                        @{@"name" : @"Food Court", @"code": @"food_court"},
                        @{@"name" : @"Food Stands", @"code": @"foodstands"},
                        @{@"name" : @"French", @"code": @"french"},
                        @{@"name" : @"French Southwest", @"code": @"sud_ouest"},
                        @{@"name" : @"Galician", @"code": @"galician"},
                        @{@"name" : @"Gastropubs", @"code": @"gastropubs"},
                        @{@"name" : @"Georgian", @"code": @"georgian"},
                        @{@"name" : @"German", @"code": @"german"},
                        @{@"name" : @"Giblets", @"code": @"giblets"},
                        @{@"name" : @"Gluten-Free", @"code": @"gluten_free"},
                        @{@"name" : @"Greek", @"code": @"greek"},
                        @{@"name" : @"Halal", @"code": @"halal"},
                        @{@"name" : @"Hawaiian", @"code": @"hawaiian"},
                        @{@"name" : @"Heuriger", @"code": @"heuriger"},
                        @{@"name" : @"Himalayan/Nepalese", @"code": @"himalayan"},
                        @{@"name" : @"Hong Kong Style Cafe", @"code": @"hkcafe"},
                        @{@"name" : @"Hot Dogs", @"code": @"hotdog"},
                        @{@"name" : @"Hot Pot", @"code": @"hotpot"},
                        @{@"name" : @"Hungarian", @"code": @"hungarian"},
                        @{@"name" : @"Iberian", @"code": @"iberian"},
                        @{@"name" : @"Indian", @"code": @"indpak"},
                        @{@"name" : @"Indonesian", @"code": @"indonesian"},
                        @{@"name" : @"International", @"code": @"international"},
                        @{@"name" : @"Irish", @"code": @"irish"},
                        @{@"name" : @"Island Pub", @"code": @"island_pub"},
                        @{@"name" : @"Israeli", @"code": @"israeli"},
                        @{@"name" : @"Italian", @"code": @"italian"},
                        @{@"name" : @"Japanese", @"code": @"japanese"},
                        @{@"name" : @"Jewish", @"code": @"jewish"},
                        @{@"name" : @"Kebab", @"code": @"kebab"},
                        @{@"name" : @"Korean", @"code": @"korean"},
                        @{@"name" : @"Kosher", @"code": @"kosher"},
                        @{@"name" : @"Kurdish", @"code": @"kurdish"},
                        @{@"name" : @"Laos", @"code": @"laos"},
                        @{@"name" : @"Laotian", @"code": @"laotian"},
                        @{@"name" : @"Latin American", @"code": @"latin"},
                        @{@"name" : @"Live/Raw Food", @"code": @"raw_food"},
                        @{@"name" : @"Lyonnais", @"code": @"lyonnais"},
                        @{@"name" : @"Malaysian", @"code": @"malaysian"},
                        @{@"name" : @"Meatballs", @"code": @"meatballs"},
                        @{@"name" : @"Mediterranean", @"code": @"mediterranean"},
                        @{@"name" : @"Mexican", @"code": @"mexican"},
                        @{@"name" : @"Middle Eastern", @"code": @"mideastern"},
                        @{@"name" : @"Milk Bars", @"code": @"milkbars"},
                        @{@"name" : @"Modern Australian", @"code": @"modern_australian"},
                        @{@"name" : @"Modern European", @"code": @"modern_european"},
                        @{@"name" : @"Mongolian", @"code": @"mongolian"},
                        @{@"name" : @"Moroccan", @"code": @"moroccan"},
                        @{@"name" : @"New Zealand", @"code": @"newzealand"},
                        @{@"name" : @"Night Food", @"code": @"nightfood"},
                        @{@"name" : @"Norcinerie", @"code": @"norcinerie"},
                        @{@"name" : @"Open Sandwiches", @"code": @"opensandwiches"},
                        @{@"name" : @"Oriental", @"code": @"oriental"},
                        @{@"name" : @"Pakistani", @"code": @"pakistani"},
                        @{@"name" : @"Parent Cafes", @"code": @"eltern_cafes"},
                        @{@"name" : @"Parma", @"code": @"parma"},
                        @{@"name" : @"Persian/Iranian", @"code": @"persian"},
                        @{@"name" : @"Peruvian", @"code": @"peruvian"},
                        @{@"name" : @"Pita", @"code": @"pita"},
                        @{@"name" : @"Pizza", @"code": @"pizza"},
                        @{@"name" : @"Polish", @"code": @"polish"},
                        @{@"name" : @"Portuguese", @"code": @"portuguese"},
                        @{@"name" : @"Potatoes", @"code": @"potatoes"},
                        @{@"name" : @"Poutineries", @"code": @"poutineries"},
                        @{@"name" : @"Pub Food", @"code": @"pubfood"},
                        @{@"name" : @"Rice", @"code": @"riceshop"},
                        @{@"name" : @"Romanian", @"code": @"romanian"},
                        @{@"name" : @"Rotisserie Chicken", @"code": @"rotisserie_chicken"},
                        @{@"name" : @"Rumanian", @"code": @"rumanian"},
                        @{@"name" : @"Russian", @"code": @"russian"},
                        @{@"name" : @"Salad", @"code": @"salad"},
                        @{@"name" : @"Sandwiches", @"code": @"sandwiches"},
                        @{@"name" : @"Scandinavian", @"code": @"scandinavian"},
                        @{@"name" : @"Scottish", @"code": @"scottish"},
                        @{@"name" : @"Seafood", @"code": @"seafood"},
                        @{@"name" : @"Serbo Croatian", @"code": @"serbocroatian"},
                        @{@"name" : @"Signature Cuisine", @"code": @"signature_cuisine"},
                        @{@"name" : @"Singaporean", @"code": @"singaporean"},
                        @{@"name" : @"Slovakian", @"code": @"slovakian"},
                        @{@"name" : @"Soul Food", @"code": @"soulfood"},
                        @{@"name" : @"Soup", @"code": @"soup"},
                        @{@"name" : @"Southern", @"code": @"southern"},
                        @{@"name" : @"Spanish", @"code": @"spanish"},
                        @{@"name" : @"Steakhouses", @"code": @"steak"},
                        @{@"name" : @"Sushi Bars", @"code": @"sushi"},
                        @{@"name" : @"Swabian", @"code": @"swabian"},
                        @{@"name" : @"Swedish", @"code": @"swedish"},
                        @{@"name" : @"Swiss Food", @"code": @"swissfood"},
                        @{@"name" : @"Tabernas", @"code": @"tabernas"},
                        @{@"name" : @"Taiwanese", @"code": @"taiwanese"},
                        @{@"name" : @"Tapas Bars", @"code": @"tapas"},
                        @{@"name" : @"Tapas/Small Plates", @"code": @"tapasmallplates"},
                        @{@"name" : @"Tex-Mex", @"code": @"tex-mex"},
                        @{@"name" : @"Thai", @"code": @"thai"},
                        @{@"name" : @"Traditional Norwegian", @"code": @"norwegian"},
                        @{@"name" : @"Traditional Swedish", @"code": @"traditional_swedish"},
                        @{@"name" : @"Trattorie", @"code": @"trattorie"},
                        @{@"name" : @"Turkish", @"code": @"turkish"},
                        @{@"name" : @"Ukrainian", @"code": @"ukrainian"},
                        @{@"name" : @"Uzbek", @"code": @"uzbek"},
                        @{@"name" : @"Vegan", @"code": @"vegan"},
                        @{@"name" : @"Vegetarian", @"code": @"vegetarian"},
                        @{@"name" : @"Venison", @"code": @"venison"},
                        @{@"name" : @"Vietnamese", @"code": @"vietnamese"},
                        @{@"name" : @"Wok", @"code": @"wok"},
                        @{@"name" : @"Wraps", @"code": @"wraps"},
                        @{@"name" : @"Yugoslav", @"code": @"yugoslav"}
                        ];
}

@end

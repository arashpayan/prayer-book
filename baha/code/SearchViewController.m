//
//  SearchViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "PrayerCell.h"
#import "PrayerDatabase.h"
#import "PrayerViewController.h"

dispatch_queue_t SEARCH_QUEUE;

@interface SearchViewController ()

@property (nonatomic, strong) NSArray *resultSet;
@property (nonatomic, strong) NSString *currQuery;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation SearchViewController

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEARCH_QUEUE = dispatch_queue_create("sh.ara.prayerbook.searchqueue", DISPATCH_QUEUE_SERIAL);
    });
    
    self.title = NSLocalizedString(@"SEARCH", nil);
	self.tabBarItem.image = [UIImage imageNamed:@"ic_search"];
    self.resultSet = [[NSMutableArray alloc] init];
	
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	CGRect appFrame = [UIScreen mainScreen].applicationFrame;
	self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(appFrame), CGRectGetHeight(appFrame)) style:UITableViewStylePlain];
	self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(appFrame), 44)];
	self.searchBar.delegate = self;
	self.searchBar.tintColor = [UIColor blackColor];
	self.table.tableHeaderView = self.searchBar;
	self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
	self.searchController.searchResultsDataSource = self;
	self.searchController.searchResultsDelegate = self;
	self.view = self.table;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIUserInterfaceIdiom idiom = UIDevice.currentDevice.userInterfaceIdiom;
    if (idiom == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskAll;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

#pragma mark - Table Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.resultSet count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"UnselectedIdentifier";
	
	PrayerCell *cell = (PrayerCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[PrayerCell alloc] initWithReuseIdentifier:MyIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	Prayer *prayer = self.resultSet[indexPath.row];
	cell.title.text = prayer.title;
	cell.subtitle.text = prayer.category;
	cell.rightLabel.text = [NSString stringWithFormat:@"%@ %@", prayer.wordCount, NSLocalizedString(@"WORDS", NULL)];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PrayerViewController *pvc = [[PrayerViewController alloc] initWithPrayer:self.resultSet[indexPath.row]];
	[[self navigationController] pushViewController:pvc animated:YES];
}

#pragma mark - UISearchBar Delegate Methods

- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText {
	self.currQuery = searchText;
    
    dispatch_async(SEARCH_QUEUE, ^{
        NSArray *keywords = [aSearchBar.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *results = [[PrayerDatabase sharedInstance] searchWithKeywords:keywords];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultSet = results;
            [self.searchController.searchResultsTableView reloadData];
        });
    });
}

@end

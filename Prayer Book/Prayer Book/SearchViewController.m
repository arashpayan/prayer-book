//
//  SearchViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "PrayerTableCell.h"
#import "PrayerDatabase.h"
#import "PrayerViewController.h"

@interface SearchViewController ()

@property (nonatomic, strong) NSArray *resultSet;
@property (nonatomic, strong) NSString *currQuery;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation SearchViewController

- (id)init {
	if (self = [super init]) {
		self.title = NSLocalizedString(@"SEARCH", nil);
		[self setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:3]];
		self.resultSet = [[NSMutableArray alloc] init];
	}
	
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
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
	
	PrayerTableCell *cell = (PrayerTableCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[PrayerTableCell alloc] initWithReuseIdentifier:MyIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	Prayer *prayer = [self.resultSet objectAtIndex:indexPath.row];
	cell.title.text = prayer.title;
	cell.subtitle.text = prayer.category;
	cell.rightLabel.text = [NSString stringWithFormat:@"%@ %@", prayer.wordCount, NSLocalizedString(@"WORDS", NULL)];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PrayerViewController *pvc = [[PrayerViewController alloc] initWithPrayer:[self.resultSet objectAtIndex:indexPath.row]];
	[[self navigationController] pushViewController:pvc animated:YES];
}

#pragma mark - UISearchBar Delegate Methods

- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText {
	self.currQuery = searchText;
	
	NSArray *keywords = [aSearchBar.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	self.resultSet = [[PrayerDatabase sharedInstance] searchWithKeywords:keywords];
}

@end

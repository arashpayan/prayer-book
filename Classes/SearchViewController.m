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


@implementation SearchViewController

@synthesize currQuery;

- (id)init {
	if (self = [super init])
	{
		self.title = NSLocalizedString(@"SEARCH", nil);
		[self setTabBarItem:[[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:3] autorelease]];
		resultSet = [[NSMutableArray alloc] init];
	}
	
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	CGRect appFrame = [UIScreen mainScreen].applicationFrame;
	table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(appFrame), CGRectGetHeight(appFrame)) style:UITableViewStylePlain];
	searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(appFrame), 44)];
	searchBar.delegate = self;
	searchBar.tintColor = [UIColor blackColor];
	table.tableHeaderView = searchBar;
	searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchController.searchResultsDataSource = self;
	searchController.searchResultsDelegate = self;
	self.view = table;
}

- (void)viewDidUnload {
	[table release];
	table = nil;
	[searchBar release];
	searchBar = nil;
	[searchController release];
	searchController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark Table Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [resultSet count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"UnselectedIdentifier";
	
	PrayerTableCell *cell = (PrayerTableCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[PrayerTableCell alloc] initWithReuseIdentifier:MyIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	Prayer *prayer = [resultSet objectAtIndex:indexPath.row];
	cell.title.text = prayer.title;
	cell.subtitle.text = prayer.category;
	cell.rightLabel.text = [NSString stringWithFormat:@"~%@ %@", prayer.wordCount, NSLocalizedString(@"WORDS", NULL)];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PrayerViewController *pvc = [[[PrayerViewController alloc] initWithPrayer:[resultSet objectAtIndex:indexPath.row] backButtonTitle:NSLocalizedString(@"SEARCH", NULL)] autorelease];
	[[self navigationController] pushViewController:pvc animated:YES];
}

#pragma mark -
#pragma mark UISearchDisplayDelegate



#pragma mark -
#pragma mark UISearchBar Delegate Methods

- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText {
	self.currQuery = searchText;
	
	NSArray *keywords = [aSearchBar.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	[resultSet release];
	resultSet = [[[PrayerDatabase sharedInstance] searchWithKeywords:keywords] retain];
}

- (void)loadSavedState:(NSArray*)savedState {
	NSString *searchString = [savedState objectAtIndex:0];
	currQuery = searchString;
}

- (void)dealloc {
    [super dealloc];
}


@end

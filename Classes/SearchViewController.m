//
//  SearchViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "PrayerTableCell.h"
//#import "Prayer.h"
#import "PrayerDatabase.h"
#import "PrayerViewController.h"


@implementation SearchViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

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
	self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 360)] autorelease];
	
	UISearchBar *searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
	searchBar.delegate = self;
	searchBar.autocapitalizationType = NO;
	searchBar.autocorrectionType = NO;
	searchBar.showsCancelButton = YES;
	searchBar.placeholder = NSLocalizedString(@"SEARCH", nil);
	[self.view addSubview:searchBar];
	
	resultsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 316) style:UITableViewStylePlain];
	resultsTable.delegate = self;
	resultsTable.dataSource = self;
	[self.view addSubview:resultsTable];
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
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[PrayerTableCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:MyIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	//NSNumber *bookmark = [bookmarks objectAtIndex:indexPath.row];
	Prayer *prayer = [resultSet objectAtIndex:indexPath.row]; //[prayerDatabase prayerWithId:[bookmark longValue]];
	[(PrayerTableCell*)cell titleLabel].text = prayer.title;
	[(PrayerTableCell*)cell categoryLabel].text = prayer.category;
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PrayerViewController *pvc = [[[PrayerViewController alloc] initWithPrayer:[resultSet objectAtIndex:indexPath.row]] autorelease];
	[[self navigationController] pushViewController:pvc animated:YES];
}


#pragma mark UISearchBar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	NSArray *keywords = [searchBar.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	[resultSet release];
	resultSet = [[[PrayerDatabase sharedInstance] searchWithKeywords:keywords] retain];
	
	[resultsTable reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	NSLog(@"searchBarCancelButtonClicked");
	searchBar.text = @"";
	[searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	NSIndexPath *selectedIndexPath = [resultsTable indexPathForSelectedRow];
	if (selectedIndexPath != nil)
		[resultsTable deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
//	NSLog(@"searchBarShouldEndEditiong");
//	return YES;
//}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[resultsTable release];
	
    [super dealloc];
}


@end

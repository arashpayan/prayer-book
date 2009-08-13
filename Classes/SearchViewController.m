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
#import "SearchView.h"


@implementation SearchViewController

@synthesize currQuery;

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
	SearchView *searchView = [[[SearchView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) searchViewController:self] autorelease];
	self.view = searchView;
	[searchView loadSaveState:currQuery];
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
		cell = [[[PrayerTableCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:MyIdentifier] autorelease];
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


#pragma mark UISearchBar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	self.currQuery = searchText;
	
	NSArray *keywords = [searchBar.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	[resultSet release];
	resultSet = [[[PrayerDatabase sharedInstance] searchWithKeywords:keywords] retain];
	
	[((SearchView*)self.view).resultsTable reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	searchBar.text = @"";
	[searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	NSIndexPath *selectedIndexPath = [((SearchView*)self.view).resultsTable indexPathForSelectedRow];
	if (selectedIndexPath != nil)
		[((SearchView*)self.view).resultsTable deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (void)loadSavedState:(NSArray*)savedState {
	NSString *searchString = [savedState objectAtIndex:0];
	currQuery = searchString;
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	CGRect newFrame = CGRectMake(0,
								 0,
								 fromInterfaceOrientation == UIInterfaceOrientationPortrait ? 480 : 320,
								 fromInterfaceOrientation == UIInterfaceOrientationPortrait ? 220 : 367);
	self.view.frame = newFrame;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end

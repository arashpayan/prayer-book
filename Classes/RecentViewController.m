//
//  RecentViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/27/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "RecentViewController.h"
#import "PrayerViewController.h"


@implementation RecentViewController


- (id)init {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		prayerDatabase = [PrayerDatabase sharedInstance];
		
		self.title = @"Recents";
		[self setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2]];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear"
																				  style:UIBarButtonItemStylePlain
																				 target:self
																				 action:@selector(clearRecent)];
	}
	return self;
}

- (void)clearRecent {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil //NSLocalizedString(@"CLEAR_RECENTS", nil)
															 delegate:self
													cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
											   destructiveButtonTitle:NSLocalizedString(@"CLEAR_ALL_RECENTS", nil)
													otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.tabBarController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0)
	{
		[prayerDatabase clearRecents];
		[recentPrayers release];
		recentPrayers = [prayerDatabase getRecent];
		[recentPrayers retain];

		[self.tableView reloadData];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [recentPrayers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[PrayerTableCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:MyIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//cell.font = [UIFont boldSystemFontOfSize:16.0];
	}
	// Configure the cell
	NSNumber *entry = [recentPrayers objectAtIndex:indexPath.row];
	Prayer *thePrayer = [prayerDatabase prayerWithId:[entry longValue]];
	[(PrayerTableCell*)cell titleLabel].text  = thePrayer.title;
	[(PrayerTableCell*)cell categoryLabel].text = thePrayer.category;
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSNumber *prayerId = [recentPrayers objectAtIndex:indexPath.row];
	//NSString *category = [[entry allKeys] objectAtIndex:0];
	//NSString *title = [entry valueForKey:category];
	Prayer *prayer = [prayerDatabase prayerWithId:[prayerId longValue]];
	if (prayer == nil)
	{
		printf("Unable to find recent prayer\n");
		return;
	}
	
	PrayerViewController *prayerViewController = [[PrayerViewController alloc] initWithPrayer:prayer];
	[[self navigationController] pushViewController:prayerViewController animated:YES];
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
	}
	if (editingStyle == UITableViewCellEditingStyleInsert) {
	}
}
*/
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/
/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/
/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


- (void)loadSavedState:(NSMutableArray*)savedState {
	NSNumber *bookmark = [savedState objectAtIndex:0];
	Prayer *prayer = [prayerDatabase prayerWithId:[bookmark longValue]];
	
	PrayerViewController *pvc = [[PrayerViewController alloc] initWithPrayer:prayer];
	[[self navigationController] pushViewController:pvc animated:NO];
}

- (void)dealloc {
	[recentPrayers release];
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// we need to release the old array, in case the view has already appeared
	[recentPrayers release];
	
	recentPrayers = [prayerDatabase getRecent];
	[recentPrayers retain];
	
	if ([recentPrayers count] > 0)
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	else
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	
	// force the reload, because UIKit caches the table
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
	printf("RecentViewController didReceiveMemoryWarning\n");
	[super didReceiveMemoryWarning];
}


@end


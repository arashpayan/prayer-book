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
		
		self.title = NSLocalizedString(@"RECENTS", nil);
		[self setTabBarItem:[[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2] autorelease]];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CLEAR", nil)
																				  style:UIBarButtonItemStylePlain
																				 target:self
																				 action:@selector(clearRecent)] autorelease];
	}
	return self;
}

- (void)clearRecent {
	UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil
															  delegate:self
													 cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
												destructiveButtonTitle:NSLocalizedString(@"CLEAR_ALL_RECENTS", nil)
													 otherButtonTitles:nil] autorelease];
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
	
	PrayerTableCell *cell = (PrayerTableCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[PrayerTableCell alloc] initWithReuseIdentifier:MyIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	NSNumber *entry = [recentPrayers objectAtIndex:indexPath.row];
	Prayer *thePrayer = [prayerDatabase prayerWithId:[entry longValue]];
	cell.title.text = thePrayer.title;
	cell.subtitle.text = thePrayer.category;
	cell.rightLabel.text = [NSString stringWithFormat:@"~%@ %@", thePrayer.wordCount, NSLocalizedString(@"WORDS", NULL)];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSNumber *prayerId = [recentPrayers objectAtIndex:indexPath.row];
	Prayer *prayer = [prayerDatabase prayerWithId:[prayerId longValue]];
	if (prayer == nil)
	{
		printf("Unable to find recent prayer\n");
		return;
	}
	
	PrayerViewController *prayerViewController = [[[PrayerViewController alloc] initWithPrayer:prayer backButtonTitle:NSLocalizedString(@"RECENTS", NULL)] autorelease];
	[[self navigationController] pushViewController:prayerViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (void)loadSavedState:(NSMutableArray*)savedState {
	NSNumber *prayerId = [savedState objectAtIndex:0];
	Prayer *prayer = [prayerDatabase prayerWithId:[prayerId longValue]];
	
	PrayerViewController *pvc = [[[PrayerViewController alloc] initWithPrayer:prayer backButtonTitle:NSLocalizedString(@"RECENTS", NULL)] autorelease];
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
	[super didReceiveMemoryWarning];
}


@end


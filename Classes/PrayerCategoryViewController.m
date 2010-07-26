//
//  RootViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerCategoryViewController.h"

@implementation PrayerCategoryViewController


- (id)init {
	if (self = [super initWithStyle:UITableViewStylePlain])
	{
		prayerDb = [PrayerDatabase sharedInstance];
		
		categories = [prayerDb categories];
		[categories retain];
		languages = [[categories allKeys] sortedArrayUsingSelector:@selector(compareCategories:)];
		[languages retain];
		
		self.title = NSLocalizedString(@"CATEGORIES", nil);
	}
	return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [categories count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([categories count] == 1)
		return nil;
	else
		return [languages objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[categories objectForKey:[languages objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *myIdentifier = @"someIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
	if (cell == nil)		
	{
		//cell = [[[CategoryCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:myIdentifier] autorelease];
		cell = [[[CategoryCell alloc] initWithReuseIdentifier:myIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	// Configure the cell
	NSString *category = [[categories objectForKey:[languages objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
	[(CategoryCell*)cell setCategory:category];
	[(CategoryCell*)cell setCount:[NSString stringWithFormat:@"%d", [prayerDb numberOfPrayersForCategory:category]]];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PrayerListViewController *prayerListViewController = [[PrayerListViewController alloc] init];
	NSString *category = [[categories objectForKey:[languages objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
	[prayerListViewController setPrayers:[prayerDb prayersForCategory:category]];
	[prayerListViewController setCategory:category];
	[[self navigationController] pushViewController:prayerListViewController animated:YES];
	[prayerListViewController release];
}

- (void)loadSavedState:(NSMutableArray*)savedState {
	NSString* category = [savedState objectAtIndex:0];
	
	PrayerListViewController *prayerListViewController = [[[PrayerListViewController alloc] init] autorelease];
	[prayerListViewController setPrayers:[prayerDb prayersForCategory:category]];
	[prayerListViewController setCategory:category];
	[[self navigationController] pushViewController:prayerListViewController animated:NO];
	[savedState removeObjectAtIndex:0];

	if ([savedState count] > 0)	// were they viewing a prayer?
	{
		NSNumber *prayerIdNumber = [savedState objectAtIndex:0];
		long prayerId = [prayerIdNumber longValue];
		Prayer *thePrayer = [prayerDb prayerWithId:prayerId];
		PrayerViewController *pvc = [[[PrayerViewController alloc] initWithPrayer:thePrayer backButtonTitle:thePrayer.category] autorelease];
		[[self navigationController] pushViewController:pvc animated:NO];
	}
}

- (void)dealloc {
	[categories release];
	[languages release];
	
	[super dealloc];
}


- (void)viewDidLoad {
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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


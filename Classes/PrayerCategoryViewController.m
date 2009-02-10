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
		prayerCategories = [prayerDb getCategories];
		[prayerCategories retain];
		
		self.title = NSLocalizedString(@"CATEGORIES", nil);
	}
	return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [prayerCategories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *myIdentifier = @"someIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
	if (cell == nil)		
	{
		cell = [[[CategoryCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:myIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	// Configure the cell
	NSString *category = [prayerCategories objectAtIndex:indexPath.row];
	[(CategoryCell*)cell setCategory:category];
	[(CategoryCell*)cell setCount:[NSString stringWithFormat:@"%d", [prayerDb numberOfPrayersForCategory:category], nil]];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	PrayerListViewController *prayerListViewController = [[PrayerListViewController alloc] init];
	[prayerListViewController setPrayers:[prayerDb getPrayersForCategory:[prayerCategories objectAtIndex:indexPath.row]]];
	[prayerListViewController setCategory:[prayerCategories objectAtIndex:indexPath.row]];
	[[self navigationController] pushViewController:prayerListViewController animated:YES];
	[prayerListViewController release];
}

- (void)loadSavedState:(NSMutableArray*)savedState {
	//NSString* category = [savedState objectAtIndex:0];
//	int categoryIndex = [prayerCategories indexOfObject:category];
//	
//	PrayerListViewController *prayerListViewController = [[PrayerListViewController alloc] init];
//	[prayerListViewController setPrayers:[prayerDb getPrayersForCategory:[prayerCategories objectAtIndex:categoryIndex]]];
//	[prayerListViewController setCategory:category];
//	[[self navigationController] pushViewController:prayerListViewController animated:NO];
//	
//	[savedState removeObjectAtIndex:0];
//	if ([savedState count] > 0)	// were they viewing a prayer?
//	{
//		NSDictionary *bookmark = [savedState objectAtIndex:0];
//		PrayerViewController *pvc = [[PrayerViewController alloc] initWithPrayer:
//									 [prayerDb prayerWithBookmark:bookmark]];
//		[[self navigationController] pushViewController:pvc animated:NO];
//	}
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


- (void)dealloc {
	[prayerCategories release];
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
	printf("PrayerCategoryViewController didReceiveMemoryWarning\n");
	[super didReceiveMemoryWarning];
}


@end


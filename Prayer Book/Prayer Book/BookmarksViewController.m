//
//  BookmarksViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/27/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "BookmarksViewController.h"
#import "PrayerViewController.h"

@interface BookmarksViewController ()

@property (nonatomic, strong) NSArray *bookmarks;

@end

@implementation BookmarksViewController

- (id)init {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.title = NSLocalizedString(@"BOOKMARKS", nil);
		[self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"TabBarBookmarkSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"TabBarBookmark.png"]];
        self.tabBarItem.title = NSLocalizedString(@"BOOKMARKS", nil);
		self.navigationItem.rightBarButtonItem = [self editButtonItem];
	}
	
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.bookmarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	PrayerTableCell *cell = (PrayerTableCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[PrayerTableCell alloc] initWithReuseIdentifier:MyIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	NSNumber *bookmark = [self.bookmarks objectAtIndex:indexPath.row];
	Prayer *prayer = [[PrayerDatabase sharedInstance] prayerWithId:[bookmark longValue]];
	cell.title.text = prayer.title;
	cell.subtitle.text = prayer.category;
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSNumber *bookmark = [self.bookmarks objectAtIndex:indexPath.row];
	Prayer *prayer = [[PrayerDatabase sharedInstance] prayerWithId:[bookmark longValue]];
	
	PrayerViewController *prayerViewController = [[PrayerViewController alloc] initWithPrayer:prayer backButtonTitle:NSLocalizedString(@"BOOKMARKS", NULL)];
	[[self navigationController] pushViewController:prayerViewController animated:YES];
}

/*
	Handles deleting bookmarks
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[PrayerDatabase sharedInstance] removeBookmark:[[self.bookmarks objectAtIndex:indexPath.row] longValue]];
		self.bookmarks = [[PrayerDatabase sharedInstance] getBookmarks];
		
		[tableView reloadData];
		
		// if there are no more bookmarks, we should end editing
		if ([self.bookmarks count] == 0) {
			[self setEditing:NO animated:YES];
			[self.navigationItem.rightBarButtonItem setEnabled:NO];
		}
	}
}

- (void)loadSavedState:(NSMutableArray*)savedState {
	NSNumber *prayerId = [savedState objectAtIndex:0];
	Prayer *prayer = [[PrayerDatabase sharedInstance] prayerWithId:[prayerId longValue]];
	
	PrayerViewController *pvc = [[PrayerViewController alloc] initWithPrayer:prayer backButtonTitle:NSLocalizedString(@"BOOKMARKS", NULL)];
	[[self navigationController] pushViewController:pvc animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.bookmarks = [[PrayerDatabase sharedInstance] getBookmarks];
	
	if ([self.bookmarks count] > 0)
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	else
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

@end


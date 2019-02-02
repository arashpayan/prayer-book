//
//  BookmarksViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/27/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "BookmarksViewController.h"
#import "PrayerViewController.h"
#import "Prefs.h"

@interface BookmarksViewController ()

@property (nonatomic, strong) NSArray *bookmarks;

@end

@implementation BookmarksViewController

- (id)init {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.title = NSLocalizedString(@"BOOKMARKS", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"ic_collections_bookmark"];
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
	
	PrayerCell *cell = (PrayerCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[PrayerCell alloc] initWithReuseIdentifier:MyIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	NSNumber *bookmark = self.bookmarks[(NSUInteger) indexPath.row];
	Prayer *prayer = [PrayerDatabase.sharedInstance prayerWithId:bookmark.longValue];
	cell.title.text = prayer.title;
	cell.subtitle.text = prayer.category;
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSNumber *bookmark = self.bookmarks[(NSUInteger) indexPath.row];
	Prayer *prayer = [PrayerDatabase.sharedInstance prayerWithId:bookmark.longValue];
	
	PrayerViewController *prayerViewController = [[PrayerViewController alloc] initWithPrayer:prayer];
	[[self navigationController] pushViewController:prayerViewController animated:YES];
}

/*
	Handles deleting bookmarks
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSNumber *bmark = self.bookmarks[(NSUInteger) indexPath.row];
        [Prefs.shared deleteBookmark:bmark.longValue];
        self.bookmarks = Prefs.shared.bookmarks;
		
		[tableView reloadData];
		
		// if there are no more bookmarks, we should end editing
		if ([self.bookmarks count] == 0) {
			[self setEditing:NO animated:YES];
			[self.navigationItem.rightBarButtonItem setEnabled:NO];
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.bookmarks = Prefs.shared.bookmarks;

	[self.navigationItem.rightBarButtonItem setEnabled:[self.bookmarks count] > 0];
	
	[self.tableView reloadData];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIUserInterfaceIdiom idiom = UIDevice.currentDevice.userInterfaceIdiom;
    if (idiom == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskAll;
}

@end


//
//  RecentViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/27/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "RecentViewController.h"
#import "PrayerViewController.h"
#import "PBLocalization.h"

@interface RecentViewController ()

@property (nonatomic, strong) NSArray *recentPrayers;

@end


@implementation RecentViewController

- (id)init {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		self.title = NSLocalizedString(@"RECENTS", nil);
		self.tabBarItem.image = [UIImage imageNamed:@"ic_history"];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CLEAR", nil)
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(clearRecentsAction)];
	}
	return self;
}

- (void)clearRecentsAction {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:l10n(@"CLEAR_ALL_RECENTS") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self clearRecents];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:l10n(@"CANCEL")
                                           style:UIAlertActionStyleCancel
                                         handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)clearRecents {
    [[PrayerDatabase sharedInstance] clearRecents];
    self.recentPrayers = [[PrayerDatabase sharedInstance] getRecent];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.recentPrayers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"MyIdentifier";
	
	PrayerCell *cell = (PrayerCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[PrayerCell alloc] initWithReuseIdentifier:MyIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	NSNumber *entry = self.recentPrayers[indexPath.row];
	Prayer *thePrayer = [[PrayerDatabase sharedInstance] prayerWithId:[entry longValue]];
	cell.title.text = thePrayer.title;
	cell.subtitle.text = thePrayer.category;
	cell.rightLabel.text = [NSString stringWithFormat:@"%@ %@", thePrayer.wordCount, NSLocalizedString(@"WORDS", NULL)];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSNumber *prayerId = self.recentPrayers[indexPath.row];
	Prayer *prayer = [[PrayerDatabase sharedInstance] prayerWithId:[prayerId longValue]];
	if (prayer == nil) {
		printf("Unable to find recent prayer\n");
		return;
	}
	
	PrayerViewController *prayerViewController = [[PrayerViewController alloc] initWithPrayer:prayer];
	[[self navigationController] pushViewController:prayerViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.recentPrayers = [[PrayerDatabase sharedInstance] getRecent];
	
	if ([self.recentPrayers count] > 0)
		[self.navigationItem.rightBarButtonItem setEnabled:YES];
	else
		[self.navigationItem.rightBarButtonItem setEnabled:NO];
	
	// force the reload, because UIKit caches the table
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


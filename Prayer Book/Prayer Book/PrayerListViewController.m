//
//  PrayerListViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerListViewController.h"


@implementation PrayerListViewController

- (id)init {
	if (self = [super initWithStyle:UITableViewStylePlain]) {

	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.prayers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"SomeIdentifier";
	
	PrayerTableCell *cell = (PrayerTableCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		//cell = [[[PrayerTableCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:MyIdentifier] autorelease];
		cell = [[PrayerTableCell alloc] initWithReuseIdentifier:MyIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	Prayer *selectedPrayer = self.prayers[indexPath.row];
	cell.title.text = selectedPrayer.title;
	cell.subtitle.text = selectedPrayer.author;
	cell.rightLabel.text = [NSString stringWithFormat:@"%@ %@", selectedPrayer.wordCount, NSLocalizedString(@"WORDS", NULL)];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PrayerViewController *prayerViewController = [[PrayerViewController alloc] initWithPrayer:self.prayers[indexPath.row]];
	[[self navigationController] pushViewController:prayerViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

@end


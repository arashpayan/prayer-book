//
//  CategoryPrayersController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "CategoryPrayersController.h"
#import "PBLocalization.h"


@implementation CategoryPrayersController

- (id)init {
	self = [super initWithStyle:UITableViewStylePlain];
    if (!self) return nil;

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
	
	PrayerCell *cell = (PrayerCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[PrayerCell alloc] initWithReuseIdentifier:MyIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	Prayer *selectedPrayer = self.prayers[indexPath.row];
    cell.title.text = selectedPrayer.title;
	cell.subtitle.text = selectedPrayer.author;
	cell.rightLabel.text = [NSString stringWithFormat:@"%@ %@", selectedPrayer.wordCount, l10n(@"WORDS")];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PrayerViewController *prayerViewController = [[PrayerViewController alloc] initWithPrayer:self.prayers[indexPath.row]];
	[[self navigationController] pushViewController:prayerViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return PrayerCell.preferredHeight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIUserInterfaceIdiom idiom = UIDevice.currentDevice.userInterfaceIdiom;
    if (idiom == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskAll;
}

@end


//
//  PrayerListViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerListViewController.h"


@implementation PrayerListViewController

@synthesize prayers;

- (id)init {
	if (self = [super initWithStyle:UITableViewStylePlain]) {

	}
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [prayers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"SomeIdentifier";
	
	PrayerTableCell *cell = (PrayerTableCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		//cell = [[[PrayerTableCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:MyIdentifier] autorelease];
		cell = [[[PrayerTableCell alloc] initWithReuseIdentifier:MyIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// Configure the cell
	Prayer *selectedPrayer = [prayers objectAtIndex:indexPath.row];
	cell.title.text = selectedPrayer.title;
	cell.subtitle.text = selectedPrayer.author;
	cell.rightLabel.text = [NSString stringWithFormat:@"~%@ %@", selectedPrayer.wordCount, NSLocalizedString(@"WORDS", NULL)];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PrayerViewController *prayerViewController = [[PrayerViewController alloc] initWithPrayer:[prayers objectAtIndex:indexPath.row]
																			  backButtonTitle:self.title];
	[[self navigationController] pushViewController:prayerViewController animated:YES];
	[prayerViewController release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (void)setCategory:(NSString*)aCategory {
	if (category != aCategory)
	{
		[aCategory retain];
		[category release];
		category = aCategory;
		self.title = category;
	}
}

- (NSString*)category {
	return category;
}

- (void)dealloc {
	[category release];
	[prayers release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


@end


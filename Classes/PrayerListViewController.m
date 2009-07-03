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
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[PrayerTableCell alloc] initWithFrame:CGRectMake(0,0,0,0) reuseIdentifier:MyIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		//cell.font = [UIFont boldSystemFontOfSize:16.0];
	}
	// Configure the cell
	Prayer *selectedPrayer = [prayers objectAtIndex:indexPath.row];
	[(PrayerTableCell*)cell titleLabel].text  = [selectedPrayer title];
	[(PrayerTableCell*)cell categoryLabel].text = [selectedPrayer author];
	[(PrayerTableCell*)cell rightLabel].text = [NSString stringWithFormat:@"~%@ words", [selectedPrayer wordCount]];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PrayerViewController *prayerViewController = [[PrayerViewController alloc] initWithPrayer:[prayers objectAtIndex:indexPath.row]];
	[[self navigationController] pushViewController:prayerViewController animated:YES];
	[prayerViewController release];
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


//- (void)viewDidLoad {
//	[super viewDidLoad];
//}
//
//
//- (void)viewWillAppear:(BOOL)animated {
//	[super viewWillAppear:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//	[super viewDidAppear:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//}

- (void)didReceiveMemoryWarning {
	printf("PrayerListViewController didReceiveMemoryWarning\n");
	[super didReceiveMemoryWarning];
}


@end


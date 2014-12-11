//
//  RootViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerCategoryViewController.h"

@interface PrayerCategoryViewController ()

@property (nonatomic, strong) NSDictionary *categories;
@property (nonatomic, strong) PrayerDatabase *prayerDb;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) NSArray *languages;

@end

@implementation PrayerCategoryViewController

- (id)init {
	if (self = [super initWithStyle:UITableViewStylePlain])
	{
		self.prayerDb = [PrayerDatabase sharedInstance];
		
		self.categories = [self.prayerDb categories];
		self.languages = [[self.categories allKeys] sortedArrayUsingSelector:@selector(compareCategories:)];
		
		self.title = NSLocalizedString(@"CATEGORIES", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"TabBarPrayers.png"];
        self.tabBarItem.title = NSLocalizedString(@"PRAYERS", nil);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(languagesPreferenceChanged:)
                                                     name:PBNotificationLanguagesPreferenceChanged
                                                   object:nil];
	}
	return self;
}

- (void)languagesPreferenceChanged:(NSNotification*)notification {
    self.categories = [self.prayerDb categories];
    self.languages = [[self.categories allKeys] sortedArrayUsingSelector:@selector(compareCategories:)];
    
    if ([self isViewLoaded])
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.tableView reloadData];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.categories count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([self.categories count] == 1)
		return nil;
	else
		return [self.languages objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self.categories objectForKey:[self.languages objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *myIdentifier = @"someIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
	if (cell == nil)		
	{
		cell = [[CategoryCell alloc] initWithReuseIdentifier:myIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	// Configure the cell
    NSString *lang = self.languages[indexPath.section];
	NSString *category = self.categories[lang][indexPath.row];
	[(CategoryCell*)cell setCategory:category];
	[(CategoryCell*)cell setCount:[NSString stringWithFormat:@"%d", [self.prayerDb numberOfPrayersForCategory:category language:lang]]];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PrayerListViewController *prayerListViewController = [[PrayerListViewController alloc] init];
    NSString *lang = self.languages[indexPath.section];
    NSString *category = self.categories[lang][indexPath.row];
	[prayerListViewController setPrayers:[self.prayerDb prayersForCategory:category language:self.languages[indexPath.section]]];
    prayerListViewController.category = category;
    prayerListViewController.title = category;
	[[self navigationController] pushViewController:prayerListViewController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end


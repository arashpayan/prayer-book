//
//  RootViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerCategoryViewController.h"
#import "Prefs.h"

@interface PrayerCategoryViewController ()

@property (nonatomic, strong) PrayerDatabase *prayerDb;
@property (nonatomic, readwrite) NSMutableArray *languageCategories;
@property (nonatomic, readwrite) NSArray *enabledLanguages;

@end

@implementation PrayerCategoryViewController

- (id)init {
	if (self = [super initWithStyle:UITableViewStylePlain])
	{
		self.prayerDb = [PrayerDatabase sharedInstance];

        self.enabledLanguages = Prefs.shared.enabledLanguages;
        self.languageCategories = [NSMutableArray new];
        for (PBLanguage *l in self.enabledLanguages) {
            [self.languageCategories addObject:[[PrayerDatabase sharedInstance] categoriesForLanguage:l]];
        }
		
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
    self.enabledLanguages = Prefs.shared.enabledLanguages;
    [self.languageCategories removeAllObjects];
    for (PBLanguage *l in self.enabledLanguages) {
        [self.languageCategories addObject:[PrayerDatabase.sharedInstance categoriesForLanguage:l]];
    }
    
    if ([self isViewLoaded]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.tableView reloadData];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.enabledLanguages.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.enabledLanguages.count == 1) {
        return nil;
    } else {
        PBLanguage *l = self.enabledLanguages[section];
        return l.humanName;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *categories = self.languageCategories[section];
    return categories.count;
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
    PBLanguage *lang = self.enabledLanguages[indexPath.section];
    NSString *category = self.languageCategories[indexPath.section][indexPath.row];
	[(CategoryCell*)cell setCategory:category];
	[(CategoryCell*)cell setCount:[NSString stringWithFormat:@"%d", [self.prayerDb numberOfPrayersForCategory:category language:lang]]];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PrayerListViewController *prayerListViewController = [[PrayerListViewController alloc] init];
    PBLanguage *lang = self.enabledLanguages[indexPath.section];
    NSString *category = self.languageCategories[indexPath.section][indexPath.row];
	[prayerListViewController setPrayers:[self.prayerDb prayersForCategory:category language:lang]];
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


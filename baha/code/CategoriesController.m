//
//  CategoriesController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/11/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "CategoriesController.h"
#import "Prefs.h"

@interface CategoriesController ()

@property (nonatomic, strong) PrayerDatabase *prayerDb;
@property (nonatomic, readwrite) NSMutableArray *languageCategories;
@property (nonatomic, readwrite) NSArray *enabledLanguages;

@end

@implementation CategoriesController

- (id)init {
	if (self = [super initWithStyle:UITableViewStylePlain])
	{
		self.prayerDb = [PrayerDatabase sharedInstance];
        self.languageCategories = [NSMutableArray new];
        [self loadLanguages];
		
		self.title = NSLocalizedString(@"CATEGORIES", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"ic_toc"];
        self.tabBarItem.title = NSLocalizedString(@"PRAYERS", nil);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(languagesPreferenceChanged:)
                                                     name:PBNotificationLanguagesPreferenceChanged
                                                   object:nil];
	}
	return self;
}

- (void)languagesPreferenceChanged:(NSNotification*)notification {
    [self loadLanguages];
    
    if ([self isViewLoaded]) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.tableView reloadData];
    }
}

- (void)loadLanguages {
    self.enabledLanguages = Prefs.shared.enabledLanguages;
    [self.languageCategories removeAllObjects];
    for (PBLanguage *l in self.enabledLanguages) {
        NSArray *unsorted = [PrayerDatabase.sharedInstance categoriesForLanguage:l];
        NSArray *sorted = [unsorted sortedArrayUsingSelector:@selector(compareCategories:)];
        [self.languageCategories addObject:sorted];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.enabledLanguages.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.enabledLanguages.count == 1) {
        return nil;
    } else {
        PBLanguage *l = self.enabledLanguages[(NSUInteger) section];
        return l.humanName;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *categories = self.languageCategories[(NSUInteger) section];
    return categories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *myIdentifier = @"someIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
	if (cell == nil) {
		cell = [[CategoryCell alloc] initWithReuseIdentifier:myIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	// Configure the cell
    PBLanguage *lang = self.enabledLanguages[(NSUInteger) indexPath.section];
    NSString *category = self.languageCategories[(NSUInteger) indexPath.section][(NSUInteger) indexPath.row];
	[(CategoryCell*)cell setCategory:category];
	[(CategoryCell*)cell setCount:[NSString stringWithFormat:@"%d", [self.prayerDb numberOfPrayersForCategory:category language:lang]]];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CategoryPrayersController *prayerListViewController = [[CategoryPrayersController alloc] init];
    PBLanguage *lang = self.enabledLanguages[(NSUInteger) indexPath.section];
    NSString *category = self.languageCategories[(NSUInteger) indexPath.section][(NSUInteger) indexPath.row];
	[prayerListViewController setPrayers:[self.prayerDb prayersForCategory:category language:lang]];
    prayerListViewController.category = category;
    prayerListViewController.title = category;
	[[self navigationController] pushViewController:prayerListViewController animated:YES];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIUserInterfaceIdiom idiom = UIDevice.currentDevice.userInterfaceIdiom;
    if (idiom == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskAll;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


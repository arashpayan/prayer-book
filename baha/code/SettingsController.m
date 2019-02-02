//
//  SettingsController.m
//  BahaiWritings
//
//  Created by Arash Payan on 9/11/11.
//  Copyright 2011 Paxdot. All rights reserved.
//

#import "SettingsController.h"
#import "PrayerDatabase.h"
#import "Prefs.h"

typedef enum {
    SettingsLanguagesSection,
    SettingsThemeSection,
    SettingsAboutSection,
    SettingsNumSections,
} SettingsSections;


@interface SettingsController ()

@property (nonatomic, readwrite) NSArray *allLanguages;
@property (nonatomic, readwrite) NSMutableArray *languageToggles;

@end

@implementation SettingsController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"languages", nil);
        self.tabBarItem.title = NSLocalizedString(@"languages", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"ic_language"];
        self.tabBarItem.tag = 4;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(languagePreferenceChanged:)
                                                     name:PBNotificationLanguagesPreferenceChanged
                                                   object:nil];
    }
    return self;
}

- (void)languagePreferenceChanged:(NSNotification*)notification {
    if ([self isViewLoaded]) {
        for (NSUInteger i=0; i<self.allLanguages.count; i++) {
            UISwitch *s = self.languageToggles[i];
            PBLanguage *l = self.allLanguages[i];
            s.on = [Prefs.shared isLanguageEnabled:l];
        }
    }
}

- (void)languageSwitchToggled:(UISwitch*)control {
    PBLanguage *l = self.allLanguages[control.tag];
    [Prefs.shared setLanguage:l enabled:control.on];
}

- (void)onThemeChanged:(UISwitch*)control {
    Prefs.shared.useClassicTheme = control.on;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.allLanguages = PBLanguage.all;

    self.languageToggles = [NSMutableArray new];
    for (int i=0; i<self.allLanguages.count; i++) {
        UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectZero];
        s.tag = i;
        [s addTarget:self action:@selector(languageSwitchToggled:) forControlEvents:UIControlEventValueChanged];
        [self.languageToggles addObject:s];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIUserInterfaceIdiom idiom = UIDevice.currentDevice.userInterfaceIdiom;
    if (idiom == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SettingsNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SettingsLanguagesSection) {
        return self.allLanguages.count;
    }
    if (section == SettingsThemeSection) {
        return 1;
    }
    if (section == SettingsAboutSection) {
        return 1;
    }
    
    [NSException raise:@"InvalidSection" format:@"Invalid section number %ld", (long)section];
    return 0;   // keep the compiler from complaining
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (indexPath.section == SettingsLanguagesSection) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;

        PBLanguage *lang = self.allLanguages[indexPath.row];
        cell.textLabel.text = lang.humanName;
        UISwitch *s = self.languageToggles[indexPath.row];
        s.on = [Prefs.shared isLanguageEnabled:lang];
        cell.accessoryView = s;
    } else if (indexPath.section == SettingsThemeSection) {
        cell.textLabel.text = NSLocalizedString(@"use_classic_prayer_theme", nil);
        UISwitch *s = [[UISwitch alloc] initWithFrame:CGRectZero];
        s.on = Prefs.shared.useClassicTheme;
        [s addTarget:self action:@selector(onThemeChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = s;
    } else if (indexPath.section == SettingsAboutSection) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.text = NSLocalizedString(@"ABOUT", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == SettingsLanguagesSection)
        return NSLocalizedString(@"Prayer Languages", nil);
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SettingsAboutSection) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"https://arashpayan.com/in_app_pages/prayer_book/about"] options:@{} completionHandler:nil];
    }
}

#pragma mark - Memory Management

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

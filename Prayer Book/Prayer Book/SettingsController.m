//
//  SettingsController.m
//  BahaiWritings
//
//  Created by Arash Payan on 9/11/11.
//  Copyright 2011 Paxdot. All rights reserved.
//

#import "SettingsController.h"
#import "AboutViewController.h"
#import "PrayerDatabase.h"

typedef enum {
    LG_ENGLISH,
    LG_SPANISH,
    LG_PERSIAN,
    LG_FRENCH,
    LG_DUTCH,
} LANGUAGES;


@interface SettingsController ()

@property (nonatomic, strong) UISwitch *dutchSwitch;
@property (nonatomic, strong) UISwitch *englishSwitch;
@property (nonatomic, strong) UISwitch *frenchSwitch;
@property (nonatomic, strong) UISwitch *persianSwitch;
@property (nonatomic, strong) UISwitch *spanishSwitch;

@end

@implementation SettingsController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Settings", nil);
        self.tabBarItem.title = NSLocalizedString(@"Settings", nil);
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"TabBarSettingsSelected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"TabBarSettings.png"]];
        self.tabBarItem.tag = 4;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(languagePreferenceChanged:)
                                                     name:PBNotificationLanguagesPreferenceChanged
                                                   object:nil];
    }
    return self;
}

- (void)languagePreferenceChanged:(NSNotification*)notification {
    if ([self isViewLoaded])
    {
        self.dutchSwitch.on = [PrayerDatabase sharedInstance].showDutchPrayers;
        self.englishSwitch.on = [PrayerDatabase sharedInstance].showEnglishPrayers;
        self.frenchSwitch.on = [PrayerDatabase sharedInstance].showFrenchPrayers;
        self.persianSwitch.on = [PrayerDatabase sharedInstance].showPersianPrayers;
        self.spanishSwitch.on = [PrayerDatabase sharedInstance].showSpanishPrayers;
    }
}

- (void)dutchSwitchToggled {
    [PrayerDatabase sharedInstance].showDutchPrayers = self.dutchSwitch.on;
}

- (void)englishSwitchToggled {
    [PrayerDatabase sharedInstance].showEnglishPrayers = self.englishSwitch.on;
}

- (void)frenchSwitchToggled {
    [PrayerDatabase sharedInstance].showFrenchPrayers = self.frenchSwitch.on;
}

- (void)persianSwitchToggled {
    [PrayerDatabase sharedInstance].showPersianPrayers = self.persianSwitch.on;
}

- (void)spanishSwitchToggled {
    [PrayerDatabase sharedInstance].showSpanishPrayers = self.spanishSwitch.on;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dutchSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.dutchSwitch.on = [PrayerDatabase sharedInstance].showDutchPrayers;
    [self.dutchSwitch addTarget:self action:@selector(dutchSwitchToggled) forControlEvents:UIControlEventValueChanged];
    self.englishSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.englishSwitch.on = [PrayerDatabase sharedInstance].showEnglishPrayers;
    [self.englishSwitch addTarget:self action:@selector(englishSwitchToggled) forControlEvents:UIControlEventValueChanged];
    self.frenchSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.frenchSwitch.on = [PrayerDatabase sharedInstance].showFrenchPrayers;
    [self.frenchSwitch addTarget:self action:@selector(frenchSwitchToggled) forControlEvents:UIControlEventValueChanged];
    self.persianSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.persianSwitch.on = [PrayerDatabase sharedInstance].showPersianPrayers;
    [self.persianSwitch addTarget:self action:@selector(persianSwitchToggled) forControlEvents:UIControlEventValueChanged];
    self.spanishSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.spanishSwitch.on = [PrayerDatabase sharedInstance].showSpanishPrayers;
    [self.spanishSwitch addTarget:self action:@selector(spanishSwitchToggled) forControlEvents:UIControlEventValueChanged];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // English, Español, Français, Nederlands, فارسی
    if (section == 0)
        return 5;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (indexPath.section == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        switch (indexPath.row) {
            case LG_ENGLISH:
                cell.textLabel.text = @"English";
                self.englishSwitch.on = [PrayerDatabase sharedInstance].showEnglishPrayers;
                cell.accessoryView = self.englishSwitch;
                break;
            case LG_SPANISH:
                cell.textLabel.text = @"Español";
                self.spanishSwitch.on = [PrayerDatabase sharedInstance].showSpanishPrayers;
                cell.accessoryView = self.spanishSwitch;
                break;
            case LG_DUTCH:
                cell.textLabel.text = @"Nederlands";
                self.dutchSwitch.on = [PrayerDatabase sharedInstance].showDutchPrayers;
                cell.accessoryView = self.dutchSwitch;
                break;
            case LG_FRENCH:
                cell.textLabel.text = @"Français";
                self.frenchSwitch.on = [PrayerDatabase sharedInstance].showFrenchPrayers;
                cell.accessoryView = self.frenchSwitch;
                break;
            case LG_PERSIAN:
                cell.textLabel.text = @"فارسی";
                self.persianSwitch.on = [PrayerDatabase sharedInstance].showPersianPrayers;
                cell.accessoryView = self.persianSwitch;
            default:
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.text = NSLocalizedString(@"ABOUT", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return NSLocalizedString(@"Prayer Languages", nil);
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        AboutViewController *aboutController = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutController animated:YES];
    }
}

#pragma mark - Memory Management

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.dutchSwitch = nil;
    self.englishSwitch = nil;
    self.frenchSwitch = nil;
    self.persianSwitch = nil;
    self.spanishSwitch = nil;
}

@end

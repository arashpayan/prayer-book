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


@implementation SettingsController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Settings", nil);
    }
    return self;
}

- (void)dutchSwitchToggled {
    [PrayerDatabase sharedInstance].showDutchPrayers = dutchSwitch.on;
}

- (void)englishSwitchToggled {
    [PrayerDatabase sharedInstance].showEnglishPrayers = englishSwitch.on;
}

- (void)frenchSwitchToggled {
    [PrayerDatabase sharedInstance].showFrenchPrayers = frenchSwitch.on;
}

- (void)persianSwitchToggled {
    [PrayerDatabase sharedInstance].showPersianPrayers = persianSwitch.on;
}

- (void)spanishSwitchToggled {
    [PrayerDatabase sharedInstance].showSpanishPrayers = spanishSwitch.on;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dutchSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    dutchSwitch.on = [PrayerDatabase sharedInstance].showDutchPrayers;
    [dutchSwitch addTarget:self action:@selector(dutchSwitchToggled) forControlEvents:UIControlEventValueChanged];
    englishSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    englishSwitch.on = [PrayerDatabase sharedInstance].showEnglishPrayers;
    [englishSwitch addTarget:self action:@selector(englishSwitchToggled) forControlEvents:UIControlEventValueChanged];
    frenchSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    frenchSwitch.on = [PrayerDatabase sharedInstance].showFrenchPrayers;
    [frenchSwitch addTarget:self action:@selector(frenchSwitchToggled) forControlEvents:UIControlEventValueChanged];
    persianSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    persianSwitch.on = [PrayerDatabase sharedInstance].showPersianPrayers;
    [persianSwitch addTarget:self action:@selector(persianSwitchToggled) forControlEvents:UIControlEventValueChanged];
    spanishSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    spanishSwitch.on = [PrayerDatabase sharedInstance].showSpanishPrayers;
    [spanishSwitch addTarget:self action:@selector(spanishSwitchToggled) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (indexPath.section == 0)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        switch (indexPath.row) {
            case LG_ENGLISH:
                cell.textLabel.text = @"English";
                cell.accessoryView = englishSwitch;
                break;
            case LG_SPANISH:
                cell.textLabel.text = @"Español";
                cell.accessoryView = spanishSwitch;
                break;
            case LG_DUTCH:
                cell.textLabel.text = @"Nederlands";
                cell.accessoryView = dutchSwitch;
                break;
            case LG_FRENCH:
                cell.textLabel.text = @"Français";
                cell.accessoryView = frenchSwitch;
                break;
            case LG_PERSIAN:
                cell.textLabel.text = @"فارسی";
                cell.accessoryView = persianSwitch;
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
        
        AboutViewController *aboutController = [[[AboutViewController alloc] init] autorelease];
        [self.navigationController pushViewController:aboutController animated:YES];
    }
}

#pragma mark - Memory Management

- (void)dealloc
{
    [dutchSwitch release];
    [englishSwitch release];
    [frenchSwitch release];
    [persianSwitch release];
    [spanishSwitch release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [dutchSwitch release];
    dutchSwitch = nil;
    [englishSwitch release];
    englishSwitch = nil;
    [frenchSwitch release];
    frenchSwitch = nil;
    [persianSwitch release];
    persianSwitch = nil;
    [spanishSwitch release];
    spanishSwitch = nil;
}

@end

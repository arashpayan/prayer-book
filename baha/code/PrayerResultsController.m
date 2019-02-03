//
//  PrayerResultsController.m
//  baha
//
//  Created by Arash on 2/2/19.
//  Copyright © 2019 Arash Payan. All rights reserved.
//

#import "PrayerResultsController.h"
#import "PrayerCell.h"
#import "PBLocalization.h"

@interface PrayerResultsController () <UITableViewDataSource>
@end

@implementation PrayerResultsController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) return nil;
    
    return self;
}

- (void)loadView {
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.view = self.table;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIUserInterfaceIdiom idiom = UIDevice.currentDevice.userInterfaceIdiom;
    if (idiom == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"Identifier";
    
    PrayerCell *cell = (PrayerCell*)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[PrayerCell alloc] initWithReuseIdentifier:Identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Prayer *prayer = self.results[indexPath.row];
    cell.title.text = prayer.title;
    cell.subtitle.text = prayer.category;
    cell.rightLabel.text = [NSString stringWithFormat:@"%@ %@", prayer.wordCount, l10n(@"WORDS")];
    
    return cell;
}

@end

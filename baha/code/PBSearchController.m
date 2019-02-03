//
//  PBSearchControllerViewController.m
//  baha
//
//  Created by Arash on 2/2/19.
//  Copyright © 2019 Arash Payan. All rights reserved.
//

#import "PBSearchController.h"
#import "PrayerResultsController.h"
#import "PrayerDatabase.h"
#import "PrayerCell.h"
#import "PBLocalization.h"
#import "PrayerViewController.h"

dispatch_queue_t SEARCH_WORK_QUEUE;

@interface PBSearchController ()

@property (nonatomic, readwrite) PrayerResultsController *resultsController;
@property (nonatomic, readwrite) UISearchController *searchController;
@property (nonatomic, readwrite) NSString *currQuery;
@property (nonatomic, readwrite) NSArray<Prayer*> *results;

@end

@implementation PBSearchController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) return nil;
    
    self.results = [NSArray new];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEARCH_WORK_QUEUE = dispatch_queue_create("app.prayerbook.searchqueue", DISPATCH_QUEUE_SERIAL);
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(onDoneAction)];
    self.navigationItem.title = l10n(@"SEARCH");
    
    return self;
}

- (void)loadView {
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    v.backgroundColor = UIColor.whiteColor;
    
    self.resultsController = [PrayerResultsController new];
    
    self.view = v;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    } else {
        // Fallback on earlier versions
        self.resultsController.table.tableHeaderView = self.searchController.searchBar;
    }
    
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.searchBar.delegate = self;
    
    self.definesPresentationContext = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIUserInterfaceIdiom idiom = UIDevice.currentDevice.userInterfaceIdiom;
    if (idiom == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskAll;
}

- (void)onDoneAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.currQuery = searchController.searchBar.text;
    self.resultsController.table.delegate = self;
    
    dispatch_async(SEARCH_WORK_QUEUE, ^{
        NSArray *keywords = [self.currQuery componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
        NSArray *searchResults = [[PrayerDatabase sharedInstance] searchWithKeywords:keywords];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.results = searchResults;
            self.resultsController.results = searchResults;
            [self.resultsController.table reloadData];
        });
    });
}

#pragma mark - UISearchControllerDelegate

#pragma mark - UISearchBarDelegate

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PrayerCell.preferredHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Prayer *p = self.results[indexPath.row];
    PrayerViewController *pvc = [[PrayerViewController alloc] initWithPrayer:p];
    [self.navigationController pushViewController:pvc animated:YES];
}

@end

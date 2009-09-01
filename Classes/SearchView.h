//
//  SearchView.h
//  BahaiWritings
//
//  Created by Arash Payan on 6/20/09.
//  Copyright 2009 Paxdot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"


@interface SearchView : UIView {
	SearchViewController *controller;
	
	UISearchBar *searchBar;
	UITableView *resultsTable;
}

@property (nonatomic, readonly) UITableView *resultsTable;

- (id)initWithFrame:(CGRect)frame searchViewController:(SearchViewController*)aController;
- (void)loadSaveState:(NSString*)aQuery;

@end

//
//  SearchViewController.h
//  BahaiWritings
//
//  Created by Arash Payan on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate> {
	NSMutableArray *resultSet;
	
	//UITableView *resultsTable;
	
	NSString *currQuery;
	
	UITableView *table;
	UISearchBar *searchBar;
	UISearchDisplayController *searchController;
	
	//UISearchBar *theSearchBar;
}

@property (nonatomic, retain) NSString *currQuery;

- (void)loadSavedState:(NSArray*)savedState;

@end

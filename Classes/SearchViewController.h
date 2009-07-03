//
//  SearchViewController.h
//  BahaiWritings
//
//  Created by Arash Payan on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray *resultSet;
	
	//UITableView *resultsTable;
	
	NSString *currQuery;
	
	//UISearchBar *theSearchBar;
}

@property (nonatomic, retain) NSString *currQuery;
//@property (nonatomic, retain) UISearchBar *theSearchBar;

- (void)loadSavedState:(NSArray*)savedState;

@end

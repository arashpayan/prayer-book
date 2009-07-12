//
//  SearchView.m
//  BahaiWritings
//
//  Created by Arash Payan on 6/20/09.
//  Copyright 2009 Paxdot. All rights reserved.
//

#import "SearchView.h"


@implementation SearchView

@synthesize resultsTable;

//@synthesize currQuery;

- (id)initWithFrame:(CGRect)frame searchViewController:(SearchViewController*)aController {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		controller = aController;
		
		searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)] autorelease];
		searchBar.delegate = controller;
		searchBar.autocapitalizationType = NO;
		searchBar.autocorrectionType = NO;
		searchBar.showsCancelButton = YES;
		searchBar.placeholder = NSLocalizedString(@"SEARCH", nil);
		[self addSubview:searchBar];
		
		resultsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, frame.size.height-44) style:UITableViewStylePlain];
		resultsTable.delegate = controller;
		resultsTable.dataSource = controller;
		[self addSubview:resultsTable];
    }
    return self;
}

- (void)setFrame:(CGRect)aFrame
{
	searchBar.frame = CGRectMake(0, 0, aFrame.size.width, 44);
	resultsTable.frame = CGRectMake(0, 44, aFrame.size.width, aFrame.size.height-44);
	
	[super setFrame:aFrame];
}

- (void)loadSaveState:(NSString*)aQuery {
	if (searchBar != nil)
	{
		searchBar.text = aQuery;
		[controller searchBar:searchBar textDidChange:aQuery];
	}
}


- (void)dealloc {
	[searchBar release];
	[resultsTable release];
	
    [super dealloc];
}


@end

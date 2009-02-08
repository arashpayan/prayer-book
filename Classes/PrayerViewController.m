//
//  PrayerViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/26/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerViewController.h"


@implementation PrayerViewController

- (id)initWithPrayer:(Prayer*)prayer {
	self = [super init];
	if (self)
	{
		_prayer = prayer;
		[_prayer retain];
		prayerDatabase = [PrayerDatabase sharedInstance];
		
		self.hidesBottomBarWhenPushed = YES;
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																							   target:self
																							   action:@selector(promptToBookmark)];
 		[self.navigationItem.rightBarButtonItem release];	// the navigationItem retains it for us now
		[self.navigationItem.rightBarButtonItem setEnabled:![prayerDatabase hasBookmarkForPrayer:_prayer]];
		
		// set up view rotation
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.view.autoresizesSubviews = YES;
		
		// notify the prayer database that this prayer is being accessed
		[prayerDatabase accessedPrayer:_prayer];
	}
	
	return self;
}

- (void)promptToBookmark {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Bookmark"
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:@"Add Bookmark"
													otherButtonTitles:nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.tabBarController.view];
	[actionSheet release];
}

// gets called back from the action sheet to bookmark the fee
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0)
	{
		[prayerDatabase addBookmark:_prayer];
		
		// update the status of the add bookmark button
		[self.navigationItem.rightBarButtonItem setEnabled:![prayerDatabase hasBookmarkForPrayer:_prayer]];
	}
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
*/
- (void)loadView {
	webView = [[UIWebView alloc] init];
	self.view = webView;
	
	NSMutableString *finalHTML = [[NSMutableString alloc] init];
	[finalHTML appendString:[PrayerViewController HTMLPrefix]];
	[finalHTML appendString:[_prayer prayerText]];
	[finalHTML appendString:[NSString stringWithFormat:@"<h4 id=\"author\">%@</h4>", [_prayer author], nil]];
	if ([_prayer citation] != nil)
		[finalHTML appendString:[NSString stringWithFormat:@"<p class=\"comment\"><br/><br/>%@</p>", [_prayer citation], nil]];
	[finalHTML appendString:[PrayerViewController HTMLSuffix]];
	[webView loadHTMLString:finalHTML baseURL:[NSURL URLWithString:@"file:///"]];
	[finalHTML release];
	
	//[scrollView setFrame:[webView frame]];
}


+ (NSString*)HTMLPrefix {
	static NSMutableString *htmlPrefix;
	
	if (htmlPrefix == nil)
	{
		htmlPrefix = [[NSMutableString alloc] init];
		[htmlPrefix appendString:@"<html><head>"];
		[htmlPrefix appendString:@"<style type=\"text/css\">"];
		[htmlPrefix appendString:@"#prayer p {margin: 0 0px .75em 5px; color: #330000; font: normal 1em/1.375em Georgia, \"Times New Roman\", Times, serif; clear: both; text-indent: 1em;}"];
		[htmlPrefix appendString:@"#prayer p.opening {text-indent: 0;}"];
		[htmlPrefix appendString:@"#prayer p.commentcaps {font: normal .8em Arial, Helvetica, sans-serif; color: #444433; text-transform: uppercase; margin: 0 0px 20px 5px; text-indent: 0; }"];
		[htmlPrefix appendString:@"#prayer p.comment {font: normal .8em Arial, Helvetica, sans-serif; color: #444433; margin: 0 0px .825em 1.5em; text-indent: 0; }"];
		[htmlPrefix appendString:@"#prayer p.noindent {text-indent: 0; margin-bottom: .25em;}"];
		[htmlPrefix appendString:@"#prayer p.commentnoindent {font: normal 0.8em Arial, Helvetica, sans-serif; color: #444433; margin: 0 0px 15px 5px; text-indent: 0;}"];
		[htmlPrefix appendString:@"#prayer h4#author { float: right; margin: 0 25px 25px 0; font: italic 1.03em/1.825em Georgia, \"Times New Roman\", Times, serif; color: #992222; text-indent: 0.325em; }"];
		[htmlPrefix appendString:@"span.versal {float: left; display: inline; position: relative; color: #992222; font: normal 3.5em/.75em \"Times New Roman\", Times, serif; margin: 0 .15em 0 .15em; padding: 0;}"];
		[htmlPrefix appendString:@"</style></head><body><div id=\"prayer\">"];
	}
	
	return htmlPrefix;
}

+ (NSString*)HTMLSuffix {
	static NSString *htmlSuffix;
	
	if (htmlSuffix == nil)
	{
		htmlSuffix = [NSString stringWithString:@"</div></body></html>"];
		[htmlSuffix retain];
	}
	
	return htmlSuffix;
}

- (Prayer*)prayer {
	return _prayer;
}

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
}
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
	printf("PrayerViewController didReceiveMemoryWarning\n");
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[_prayer release];
	[webView release];
	
	[super dealloc];
}


@end

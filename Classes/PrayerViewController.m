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
		[self.navigationItem.rightBarButtonItem setEnabled:![prayerDatabase prayerIsBookmarked:_prayer.prayerId]];
		
		// set up view rotation
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.view.autoresizesSubviews = YES;
		
		// notify the prayer database that this prayer is being accessed
		[prayerDatabase accessedPrayer:_prayer.prayerId];
	}
	
	return self;
}

- (void)promptToBookmark {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
											   destructiveButtonTitle:NSLocalizedString(@"ADD_BOOKMARK", nil)
													otherButtonTitles:nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.tabBarController.view];
	[actionSheet release];
}

// gets called back from the action sheet to bookmark the fee
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0)
	{
		[prayerDatabase addBookmark:_prayer.prayerId];
		
		// update the status of the add bookmark button
		[self.navigationItem.rightBarButtonItem setEnabled:![prayerDatabase prayerIsBookmarked:_prayer.prayerId]];
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
	[finalHTML appendString:_prayer.text];
	[finalHTML appendString:[NSString stringWithFormat:@"<h4 id=\"author\">%@</h4>", [_prayer author], nil]];
	if ([_prayer citation] != nil)
		[finalHTML appendString:[NSString stringWithFormat:@"<p class=\"comment\"><br/><br/>%@</p>", [_prayer citation], nil]];
	[finalHTML appendString:[PrayerViewController HTMLSuffix]];
	[webView loadHTMLString:finalHTML baseURL:[NSURL URLWithString:@"file:///"]];
	[finalHTML release];
}


+ (NSString*)HTMLPrefix {
	static NSMutableString *htmlPrefix;
	
	if (htmlPrefix == nil)
	{
		float multiplier;
		// get the value for the font multiplier
		multiplier = [[NSUserDefaults standardUserDefaults] floatForKey:@"fontSizePref"];
		if (multiplier == 0)
			multiplier = 1.0;	// the default
		
		float pFontWidth = 1 * multiplier;
		float pFontHeight = 1.375 * multiplier;
		float pComment = 0.8 * multiplier;
		float authorWidth = 1.03 * multiplier;
		float authorHeight = 1.825 * multiplier;
		float versalWidth = 3.5 * multiplier;
		float versalHeight = 0.75 * multiplier;
		htmlPrefix = [[NSMutableString alloc] init];
		[htmlPrefix appendString:@"<html><head>"];
		[htmlPrefix appendString:@"<style type=\"text/css\">"];
		[htmlPrefix appendString:@"#prayer p {margin: 0 0px .75em 5px; color: #330000; font: normal "];
		[htmlPrefix appendFormat:@"%fem/%fem", pFontWidth, pFontHeight];
		[htmlPrefix appendString:@" Georgia, \"Times New Roman\", Times, serif; clear: both; text-indent: 1em;}"];
		[htmlPrefix appendString:@"#prayer p.opening {text-indent: 0;}"];
		[htmlPrefix appendString:@"#prayer p.commentcaps {font: normal "];
		[htmlPrefix appendFormat:@"%fem", pComment];
		[htmlPrefix appendString:@" Arial, Helvetica, sans-serif; color: #444433; text-transform: uppercase; margin: 0 0px 20px 5px; text-indent: 0; }"];
		[htmlPrefix appendString:@"#prayer p.comment {font: normal "];
		[htmlPrefix appendFormat:@"%fem", pComment];
		[htmlPrefix appendString:@" Arial, Helvetica, sans-serif; color: #444433; margin: 0 0px .825em 1.5em; text-indent: 0; }"];
		[htmlPrefix appendString:@"#prayer p.noindent {text-indent: 0; margin-bottom: .25em;}"];
		[htmlPrefix appendString:@"#prayer p.commentnoindent {font: normal "];
		[htmlPrefix appendFormat:@"%fem", pComment];
		[htmlPrefix appendString:@" Arial, Helvetica, sans-serif; color: #444433; margin: 0 0px 15px 5px; text-indent: 0;}"];
		[htmlPrefix appendString:@"#prayer h4#author { float: right; margin: 0 25px 25px 0; font: italic "];
		[htmlPrefix appendFormat:@"%fem/%fem", authorWidth, authorHeight];
		[htmlPrefix appendString:@" Georgia, \"Times New Roman\", Times, serif; color: #992222; text-indent: 0.325em; }"];
		[htmlPrefix appendString:@"span.versal {float: left; display: inline; position: relative; color: #992222; font: normal "];
		[htmlPrefix appendFormat:@"%fem/%fem", versalWidth, versalHeight];
		[htmlPrefix appendString:@" \"Times New Roman\", Times, serif; margin: 0 .15em 0 .15em; padding: 0;}"];
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

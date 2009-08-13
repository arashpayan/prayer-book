//
//  PrayerViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/26/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerViewController.h"
#import "PrayerView.h"
#import "QiblihFinder.h"


@implementation PrayerViewController

- (id)initWithPrayer:(Prayer*)prayer backButtonTitle:(NSString*)aBackButtonTitle {
	self = [super init];
	if (self)
	{
		_prayer = prayer;
		backButtonTitle = [NSString stringWithString:aBackButtonTitle];
		[_prayer retain];
		prayerDatabase = [PrayerDatabase sharedInstance];
		composingMail = NO;
		
		self.hidesBottomBarWhenPushed = YES;
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																							   target:self
																							   action:@selector(promptToBookmark)];
 		[self.navigationItem.rightBarButtonItem release];	// the navigationItem retains it for us now
		//[self.navigationItem.rightBarButtonItem setEnabled:![prayerDatabase prayerIsBookmarked:_prayer.prayerId]];
		
		// set up view rotation
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.view.autoresizesSubviews = YES;
		
		// notify the prayer database that this prayer is being accessed
		[prayerDatabase accessedPrayer:_prayer.prayerId];
	}
	
	return self;
}

- (BOOL)bookmarkingEnabled {
	return ![prayerDatabase prayerIsBookmarked:_prayer.prayerId];
}

- (void)promptToBookmark {
	UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil
															  delegate:self
													 cancelButtonTitle:NSLocalizedString(@"CANCEL", NULL)
												destructiveButtonTitle:NSLocalizedString(@"ADD_BOOKMARK", NULL)
													 otherButtonTitles:nil] autorelease];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.tabBarController.view];
}

- (void)mailAction {
	if ([MFMailComposeViewController canSendMail])
	{
		composingMail = YES;
		MFMailComposeViewController *mailController = [[[MFMailComposeViewController alloc] init] autorelease];
		mailController.mailComposeDelegate = self;
		[mailController setMessageBody:[self finalPrayerHTML] isHTML:YES];
		[self presentModalViewController:mailController animated:YES];
	}
	else
	{
		// notify the user they need to setup their email
		UIAlertView *mailErrorMsg = [[[UIAlertView alloc] initWithTitle:nil
																message:NSLocalizedString(@"MAIL_ERR_MSG", NULL)
															   delegate:nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil] autorelease];
		[mailErrorMsg show];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
	composingMail = NO;
}

// gets called back from the action sheet to bookmark the fee
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0)
		[prayerDatabase addBookmark:_prayer.prayerId];
}

- (void)increaseTextSizeAction {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	float currMultiplier = [userDefaults floatForKey:kPrefsFontSize];
	//if (currMultiplier == 0)
//		currMultiplier = 1.0;	// set it to the default
	
	if (currMultiplier < 1.4)
	{
		currMultiplier += 0.05;
		[userDefaults setFloat:currMultiplier forKey:kPrefsFontSize];
		[userDefaults synchronize];
		
		PrayerView *prayerView = (PrayerView*)self.view;
		[prayerView.webView loadHTMLString:[self finalPrayerHTML] baseURL:[NSURL URLWithString:@"file:///"]];
	}
}

- (void)decreaseTextSizeAction {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	float currMultiplier = [userDefaults floatForKey:kPrefsFontSize];
	
	if (currMultiplier > 0.9)
	{
		NSLog(@"decreasingTextSize %f", currMultiplier);
		currMultiplier -= 0.05;
		[userDefaults setFloat:currMultiplier forKey:kPrefsFontSize];
		[userDefaults synchronize];
		
		PrayerView *prayerView = (PrayerView*)self.view;
		[prayerView.webView loadHTMLString:[self finalPrayerHTML] baseURL:[NSURL URLWithString:@"file:///"]];
	}
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
*/
- (void)loadView {
	[super loadView];

	PrayerView *prayerView = [[[PrayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) backTitle:backButtonTitle controller:self] autorelease];
	self.view = prayerView;

	//prayerHTML = [[self finalPrayerHTML] retain];	// in case we need to use it to send an email later
	[prayerView.webView loadHTMLString:[self finalPrayerHTML] baseURL:[NSURL URLWithString:@"file:///"]];
}

- (void)printBackTitle {
	int numVCs = [self.navigationController.viewControllers count];
	[[self.navigationController.viewControllers objectAtIndex:numVCs-2] title];
	NSLog(@"loadView back %@", self.navigationController.navigationBar.backItem.title);
}


- (NSString*)finalPrayerHTML {
	NSMutableString *finalHTML = [[[NSMutableString alloc] init] autorelease];
	[finalHTML appendString:[PrayerViewController HTMLPrefix]];
	[finalHTML appendString:_prayer.text];
	[finalHTML appendString:[NSString stringWithFormat:@"<h4 id=\"author\">%@</h4>", [_prayer author], nil]];
	if ([_prayer citation] != nil)
		[finalHTML appendString:[NSString stringWithFormat:@"<p class=\"comment\"><br/><br/>%@</p>", [_prayer citation], nil]];
	[finalHTML appendString:[PrayerViewController HTMLSuffix]];
	
	return finalHTML;
}

+ (NSString*)HTMLPrefix {
	//static NSMutableString *htmlPrefix;
	
	//if (htmlPrefix == nil)
	//{
		float multiplier;
		// get the value for the font multiplier
		multiplier = [[NSUserDefaults standardUserDefaults] floatForKey:kPrefsFontSize];
		if (multiplier == 0)
			multiplier = 1.0;	// the default
		
		float pFontWidth = 1 * multiplier;
		float pFontHeight = 1.375 * multiplier;
		float pComment = 0.8 * multiplier;
		float authorWidth = 1.03 * multiplier;
		float authorHeight = 1.825 * multiplier;
		float versalWidth = 3.5 * multiplier;
		float versalHeight = 0.75 * multiplier;
		NSMutableString *htmlPrefix = [[[NSMutableString alloc] init] autorelease];
		[htmlPrefix appendString:@"<html><head>"];
		[htmlPrefix appendString:@"<style type=\"text/css\">"];
		[htmlPrefix appendString:@"#prayer p {margin: 0 0px .75em 5px; color: #330000; font: normal "];
		[htmlPrefix appendFormat:@"%fem/%fem", pFontWidth, pFontHeight];
		[htmlPrefix appendString:@" Georgia, \"Times New Roman\", Times, serif; clear: both; text-indent: 1em;}"];
		[htmlPrefix appendString:@"#prayer p.opening {text-indent: 0;}"];
	[htmlPrefix appendString:@"body { background: #e2ded5 url(data:image/jpeg;base64,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%3D%3D) repeat-y; }"];
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
		[htmlPrefix appendString:@" Georgia, \"Times New Roman\", Times, serif; color: #992222; text-indent: 0.325em; font-weight: bold }"];
		[htmlPrefix appendString:@"span.versal {float: left; display: inline; position: relative; color: #992222; font: normal "];
		[htmlPrefix appendFormat:@"%fem/%fem", versalWidth, versalHeight];
		[htmlPrefix appendString:@" \"Times New Roman\", Times, serif; margin: 0 .15em 0 .15em; padding: 0;}"];
		[htmlPrefix appendString:@"</style></head><body><div id=\"prayer\">"];
	//}
	
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

- (void)backAction {
	[self.navigationController popViewControllerAnimated:YES];
}

/*
 If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
}
 */

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	[PrayerDatabase sharedInstance].prayerBeingViewed = YES;
	[PrayerDatabase sharedInstance].prayerView = (PrayerView*)self.view;
	
	[QiblihFinder sharedInstance].qiblihWatcher = self;
}

- (void)viewWillDisappear:(BOOL)animated {
	if (composingMail)
		return;
	
	[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[PrayerDatabase sharedInstance].prayerBeingViewed = NO;
	[PrayerDatabase sharedInstance].prayerView = nil;
	
	[QiblihFinder sharedInstance].qiblihWatcher = nil;
}


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
	//[prayerHTML release];
	//[webView release];
	
	[super dealloc];
}

#pragma mark QiblihWatcherDelegate

- (void)qiblihBearingUpdated:(float)newBearing {
	[(PrayerView*)self.view setCompassNeedleAngle:newBearing];
}

@end

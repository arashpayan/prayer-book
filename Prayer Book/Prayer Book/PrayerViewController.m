//
//  PrayerViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/26/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerViewController.h"
#import "PrayerView.h"

@interface PrayerViewController ()

@property (nonatomic, strong) PrayerView *prayerView;
@property (nonatomic, strong) NSString *backButtonTitle;
@property (nonatomic, assign) BOOL composingMail;
@property (nonatomic, strong) Prayer *prayer;

@end

@implementation PrayerViewController

- (id)initWithPrayer:(Prayer*)prayer backButtonTitle:(NSString*)aBackButtonTitle {
	self = [super init];
	if (self)
	{
        self.prayer = prayer;
		self.backButtonTitle = aBackButtonTitle;
		self.composingMail = NO;
		
		self.hidesBottomBarWhenPushed = YES;
		
		// set up view rotation
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.view.autoresizesSubviews = YES;
		
		// notify the prayer database that this prayer is being accessed
		[[PrayerDatabase sharedInstance] accessedPrayer:self.prayer.prayerId];
	}
	
	return self;
}

- (BOOL)bookmarkingEnabled {
	return ![[PrayerDatabase sharedInstance] prayerIsBookmarked:self.prayer.prayerId];
}

- (void)promptToBookmark {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"CANCEL", NULL)
                                               destructiveButtonTitle:NSLocalizedString(@"ADD_BOOKMARK", NULL)
                                                    otherButtonTitles:nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.tabBarController.view];
}

- (void)mailAction {
	if ([MFMailComposeViewController canSendMail]) {
		self.composingMail = YES;
		MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
		mailController.mailComposeDelegate = self;
		[mailController setSubject:self.prayer.category];
		[mailController setMessageBody:[self finalPrayerHTML] isHTML:YES];
        [self presentViewController:mailController animated:YES completion:nil];
	} else {
		// notify the user they need to setup their email
		UIAlertView *mailErrorMsg = [[UIAlertView alloc] initWithTitle:nil
                                                               message:NSLocalizedString(@"MAIL_ERR_MSG", NULL)
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
		[mailErrorMsg show];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
	self.composingMail = NO;
}

// gets called back from the action sheet to bookmark the fee
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0)
	{
		[[PrayerDatabase sharedInstance] addBookmark:self.prayer.prayerId];
		[(PrayerView*)self.view setBookmarkingEnabled:NO];
	}
}

- (void)increaseTextSizeAction {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	float currMultiplier = [userDefaults floatForKey:kPrefsFontSize];
	
	if (currMultiplier < 1.4) {
		currMultiplier += 0.05;
		[userDefaults setFloat:currMultiplier forKey:kPrefsFontSize];
		[userDefaults synchronize];
		
		[self.prayerView.webView loadHTMLString:[self finalPrayerHTML] baseURL:[NSURL URLWithString:@"file:///"]];
		
		[self.prayerView refreshTextSizeButtons];
        [self.prayerView.webView setBackgroundColor: [UIColor clearColor]];
        [self.prayerView.webView setOpaque:NO];
	}
}

- (BOOL)increaseTextSizeActionEnabled {
	float currMultiplier = [[NSUserDefaults standardUserDefaults] floatForKey:kPrefsFontSize];
	if (currMultiplier < 1.4)
		return YES;
	
	return NO;
}

- (void)decreaseTextSizeAction {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	float currMultiplier = [userDefaults floatForKey:kPrefsFontSize];
	
	if (currMultiplier > 0.9) {
		currMultiplier -= 0.05;
		[userDefaults setFloat:currMultiplier forKey:kPrefsFontSize];
		[userDefaults synchronize];
		
		[self.prayerView.webView loadHTMLString:[self finalPrayerHTML] baseURL:[NSURL URLWithString:@"file:///"]];
		
		[self.prayerView refreshTextSizeButtons];
	}
}

- (BOOL)decreaseTextSizeActionEnabled {
	float currMultiplier = [[NSUserDefaults standardUserDefaults] floatForKey:kPrefsFontSize];
	if (currMultiplier > 0.9)
		return YES;
	
	return NO;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
*/
- (void)loadView {
	[super loadView];

	self.prayerView = [[PrayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) backTitle:self.backButtonTitle controller:self];
	self.view = self.prayerView;

	[self.prayerView.webView loadHTMLString:[self finalPrayerHTML] baseURL:[NSURL URLWithString:@"file:///"]];
}

- (void)viewDidUnload {
    self.prayerView = nil;
}

- (NSString*)finalPrayerHTML {
	NSMutableString *finalHTML = [[NSMutableString alloc] init];
	[finalHTML appendString:[PrayerViewController HTMLPrefix:[self.prayer language]]];
	[finalHTML appendString:self.prayer.text];
	[finalHTML appendString:[NSString stringWithFormat:@"<h4 id=\"author\">%@</h4>", [self.prayer author], nil]];
	if ([self.prayer citation] != nil)
		[finalHTML appendString:[NSString stringWithFormat:@"<p class=\"comment\"><br/><br/>%@</p>", [self.prayer citation], nil]];
	[finalHTML appendString:[PrayerViewController HTMLSuffix]];
	
	return finalHTML;
}

+ (NSString*)HTMLPrefix:(NSString*)language {
	float multiplier;
	// get the value for the font multiplier
	multiplier = [[NSUserDefaults standardUserDefaults] floatForKey:kPrefsFontSize];
	if (multiplier == 0)
		multiplier = 1.0;	// the default
	
	float pFontWidth = 1.1 * multiplier;
	float pFontHeight = 1.575 * multiplier;
	float pComment = 0.8 * multiplier;
	float authorWidth = 1.03 * multiplier;
	float authorHeight = 1.825 * multiplier;
	float versalWidth = 3.5 * multiplier;
	float versalHeight = 0.75 * multiplier;
	NSMutableString *htmlPrefix = [[NSMutableString alloc] init];
	[htmlPrefix appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"];
	[htmlPrefix appendString:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n"];
    if ([language isEqualToString:@"fa"])
        [htmlPrefix appendString:@"<html dir=\"rtl\" xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">\n"];
    else
        [htmlPrefix appendString:@"<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">\n"];
	[htmlPrefix appendString:@"<head>"];
	[htmlPrefix appendString:@"<style type=\"text/css\">"];
	[htmlPrefix appendString:@"#prayer p {margin: 0 0px .75em 5px; color: #333333; font: normal "];
	[htmlPrefix appendFormat:@"%fem/%fem", pFontWidth, pFontHeight];
	[htmlPrefix appendString:@" HelveticaNeue-Light, \"Times New Roman\", Times, serif; clear: both; text-indent: 1em;}"];
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
	[htmlPrefix appendString:@"#prayer h4#author { float: right; margin: 0 5px 25px 0; font: "];
	[htmlPrefix appendFormat:@"%fem/%fem", authorWidth, authorHeight];
	[htmlPrefix appendString:@" HelveticaNeue-Light, \"Times New Roman\", Times, serif; color: #007aff; text-indent: 0.325em; font-weight: normal; font-size:1.25em }"];
	[htmlPrefix appendString:@"span.versal {float: left; display: inline; position: relative; color: #007aff; font: normal "];
	[htmlPrefix appendFormat:@"%fem/%fem", versalWidth, versalHeight];
	[htmlPrefix appendString:@" HelveticaNeue-UltraLight, \"Times New Roman\", Times, serif; margin: .115em .15em 0 0em; padding: 0;}"];
	[htmlPrefix appendString:@"</style></head><body><div id=\"prayer\">"];
	
	return htmlPrefix;
}

+ (NSString*)HTMLSuffix {
	static NSString *htmlSuffix;
	
	if (htmlSuffix == nil) {
		htmlSuffix = @"</div></body></html>";
	}
	
	return htmlSuffix;
}

- (void)backAction {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	//[self.navigationController setNavigationBarHidden:YES animated:animated];
	[PrayerDatabase sharedInstance].prayerBeingViewed = YES;
	[PrayerDatabase sharedInstance].prayerView = (PrayerView*)self.view;
}

- (void)viewWillDisappear:(BOOL)animated {
	if (self.composingMail)
		return;
	
	//[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[PrayerDatabase sharedInstance].prayerBeingViewed = NO;
	[PrayerDatabase sharedInstance].prayerView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

@end

//
//  PrayerViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/26/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerViewController.h"

@interface PrayerViewController () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, readwrite) Prayer *prayer;
@property (nonatomic, readwrite) UIWebView *webView;
@property (nonatomic, readwrite) UIBarButtonItem *increaseSizeItem;
@property (nonatomic, readwrite) UIBarButtonItem *decreaseSizeItem;
@property (nonatomic, readwrite) UIBarButtonItem *bookmarkItem;
@property (nonatomic, readwrite) UIBarButtonItem *emailItem;

@property (nonatomic, readwrite) CGPoint lastScrollOffset;

@end

@implementation PrayerViewController

- (id)initWithPrayer:(Prayer*)prayer {
	self = [super init];
	if (self)
	{
        self.prayer = prayer;
		self.hidesBottomBarWhenPushed = YES;
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
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"ADD_BOOKMARK", NULL), nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.tabBarController.view];
}

- (void)mailPrayer {
	if ([MFMailComposeViewController canSendMail]) {
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
}

- (void)increaseTextSize {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	float currMultiplier = [userDefaults floatForKey:kPrefsFontSize];
	
	if (currMultiplier < 1.4) {
		currMultiplier += 0.05;
		[userDefaults setFloat:currMultiplier forKey:kPrefsFontSize];
		[userDefaults synchronize];
		
		[self.webView loadHTMLString:[self finalPrayerHTML] baseURL:[NSURL URLWithString:@"file:///"]];
		
		[self refreshTextSizeButtons];
	}
}

- (BOOL)increaseTextSizeActionEnabled {
	float currMultiplier = [[NSUserDefaults standardUserDefaults] floatForKey:kPrefsFontSize];
	if (currMultiplier < 1.4)
		return YES;
	
	return NO;
}

- (void)decreaseTextSize {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	float currMultiplier = [userDefaults floatForKey:kPrefsFontSize];
	
	if (currMultiplier > 0.9) {
		currMultiplier -= 0.05;
		[userDefaults setFloat:currMultiplier forKey:kPrefsFontSize];
		[userDefaults synchronize];
		
		[self.webView loadHTMLString:[self finalPrayerHTML] baseURL:[NSURL URLWithString:@"file:///"]];
		
		[self refreshTextSizeButtons];
	}
}

- (BOOL)decreaseTextSizeActionEnabled {
	float currMultiplier = [[NSUserDefaults standardUserDefaults] floatForKey:kPrefsFontSize];
	if (currMultiplier > 0.9)
		return YES;
	
	return NO;
}

- (void)loadView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.autoresizesSubviews = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    self.webView.scrollView.delegate = self;

    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadHTMLString:[self finalPrayerHTML] baseURL:[NSURL URLWithString:@"file:///"]];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    
    self.increaseSizeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToolBarBigger"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(increaseTextSize)];
    self.increaseSizeItem.width = 38;
    
    self.decreaseSizeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToolBarSmaller"]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(decreaseTextSize)];
    self.decreaseSizeItem.width = 38;
    
    self.bookmarkItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToolBarBookmark"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(promptToBookmark)];
    self.bookmarkItem.width = 38;
    
    UIBarButtonItem *emailItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToolBarShare"]
                                                                        style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(mailPrayer)];
    emailItem.width = 38;
    
    self.toolbarItems = [NSArray arrayWithObjects:self.decreaseSizeItem, self.increaseSizeItem, flexibleSpace, self.bookmarkItem, emailItem, nil];
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
	return @"</div></body></html>";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // notify the prayer database that this prayer is being accessed
    [PrayerDatabase.sharedInstance accessedPrayer:self.prayer.prayerId];
	PrayerDatabase.sharedInstance.prayerBeingViewed = YES;
	PrayerDatabase.sharedInstance.prayerView = (PrayerView*)self.view;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
	PrayerDatabase.sharedInstance.prayerBeingViewed = NO;
	PrayerDatabase.sharedInstance.prayerView = nil;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)refreshTextSizeButtons {
    self.increaseSizeItem.enabled = [self increaseTextSizeActionEnabled];
    self.decreaseSizeItem.enabled = [self decreaseTextSizeActionEnabled];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [PrayerDatabase.sharedInstance addBookmark:self.prayer.prayerId];
        self.bookmarkItem.enabled = NO;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > self.lastScrollOffset.y && scrollView.contentOffset.y > 1) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    } else if (scrollView.contentOffset.y < self.lastScrollOffset.y && self.navigationController.toolbarHidden) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    
    self.lastScrollOffset = scrollView.contentOffset;
}

@end

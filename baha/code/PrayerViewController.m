//
//  PrayerViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/26/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "PrayerViewController.h"
#import "Prefs.h"
#import <GRMustache.h>

@interface PrayerViewController () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, readwrite) Prayer *prayer;
@property (nonatomic, readwrite) UIWebView *webView;
@property (nonatomic, readwrite) UIBarButtonItem *increaseSizeItem;
@property (nonatomic, readwrite) UIBarButtonItem *decreaseSizeItem;
@property (nonatomic, readwrite) UIBarButtonItem *bookmarkItem;

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
		[mailController setMessageBody:self.html isHTML:YES];
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
		
		[self.webView loadHTMLString:self.html baseURL:[NSURL URLWithString:@"file:///"]];
		
		[self refreshTextSizeButtons];
	}
}

- (BOOL)increaseTextSizeActionEnabled {
	float currMultiplier = [[NSUserDefaults standardUserDefaults] floatForKey:kPrefsFontSize];
    return currMultiplier < 1.4;
}

- (void)decreaseTextSize {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	float currMultiplier = [userDefaults floatForKey:kPrefsFontSize];
	
	if (currMultiplier > 0.9) {
		currMultiplier -= 0.05;
		[userDefaults setFloat:currMultiplier forKey:kPrefsFontSize];
		[userDefaults synchronize];
		
		[self.webView loadHTMLString:self.html baseURL:[NSURL URLWithString:@"file:///"]];
		
		[self refreshTextSizeButtons];
	}
}

- (BOOL)decreaseTextSizeActionEnabled {
	float currMultiplier = [[NSUserDefaults standardUserDefaults] floatForKey:kPrefsFontSize];
    return currMultiplier > 0.9f;

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
    
    [self.webView loadHTMLString:self.html baseURL:[NSURL URLWithString:@"file:///"]];
    
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
    
    self.toolbarItems = @[self.decreaseSizeItem, self.increaseSizeItem, flexibleSpace, self.bookmarkItem, emailItem];
}

- (NSString *)html {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float scale = [userDefaults floatForKey:kPrefsFontSize];

    float pFontWidth = 1.1f * scale;
    float pFontHeight = 1.575f * scale;
    float pComment = .8f * scale;
    float authorWidth = 1.03f * scale;
    float authorHeight = 1.825f * scale;
    float versalWidth = 3.5f * scale;
    float versalHeight = 0.75f * scale;

    NSMutableDictionary *args = [NSMutableDictionary new];
    args[@"fontWidth"] = [NSString stringWithFormat:@"%f", pFontWidth];
    args[@"fontHeight"] = [NSString stringWithFormat:@"%f", pFontHeight];
    args[@"commentSize"] = [NSString stringWithFormat:@"%f", pComment];
    args[@"authorWidth"] = [NSString stringWithFormat:@"%f", authorWidth];
    args[@"authorHeight"] = [NSString stringWithFormat:@"%f", authorHeight];
    args[@"versalWidth"] = [NSString stringWithFormat:@"%f", versalWidth];
    args[@"versalHeight"] = [NSString stringWithFormat:@"%f", versalHeight];
    BOOL useClassicTheme = Prefs.shared.useClassicTheme;
    NSString *bgColor;
    NSString *versalAndAuthorColor;
    NSString *font;
    NSString *italicOrNothing;
    if (useClassicTheme) {
        bgColor = @"#D6D2C9";
        versalAndAuthorColor = @"#992222";
        font = @"Georgia";
        italicOrNothing = @"italic";
    } else {
        bgColor = @"#ffffff";
        versalAndAuthorColor = @"#33b5e5";
        font = @"sans-serif";
        italicOrNothing = @"";
    }
    args[@"backgroundColor"] = bgColor;
    args[@"versalAndAuthorColor"] = versalAndAuthorColor;
    args[@"font"] = font;
    args[@"italicOrNothing"] = italicOrNothing;

    args[@"prayer"] = self.prayer.text;
    args[@"author"] = self.prayer.author;
    if (self.prayer.citation.length == 0) {
        args[@"citation"] = @"";
    } else {
        NSString *citationHTML = [NSString stringWithFormat:@"<p class=\"comment\"><br/><br/>%@</p>", self.prayer.citation];
        args[@"citation"] = citationHTML;
    }

    if (self.prayer.language.rightToLeft) {
        args[@"layoutDirection"] = @"rtl";
    } else {
        args[@"layoutDirection"] = @"ltr";
    }

    [GRMustacheConfiguration defaultConfiguration].contentType = GRMustacheContentTypeText;
    NSString *rendering = [GRMustacheTemplate renderObject:args fromResource:@"prayer_template" bundle:nil error:NULL];
    return rendering;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // notify the prayer database that this prayer is being accessed
    [PrayerDatabase.sharedInstance accessedPrayer:self.prayer.prayerId];
	PrayerDatabase.sharedInstance.prayerBeingViewed = YES;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
	PrayerDatabase.sharedInstance.prayerBeingViewed = NO;
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
    if (scrollView.contentOffset.y > self.lastScrollOffset.y && scrollView.contentOffset.y > 0) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    } else if (scrollView.contentOffset.y < self.lastScrollOffset.y) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    
    // we should be updating the scroll offset every time, but we DON'T want to to update it when
    // the scroll view is bouncing
    CGFloat maxOffset = scrollView.contentSize.height - scrollView.bounds.size.height;
    if (scrollView.contentOffset.y < maxOffset) {
        self.lastScrollOffset = scrollView.contentOffset;
    }
}

@end

//
//  PrayerView.m
//  BahaiWritings
//
//  Created by Arash Payan on 7/30/09.
//  Copyright 2009 Paxdot. All rights reserved.
//

#import "PrayerView.h"
#import "PrayerViewController.h"
#import "QiblihFinder.h"

#define PI 3.141592653589793

@implementation PrayerView

@synthesize webView;

- (id)initWithFrame:(CGRect)frame backTitle:(NSString*)backTitle controller:(PrayerViewController*)aController {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		controller = aController;
		barsHidden = NO;
		
		self.autoresizesSubviews = YES;
		
		webView = [[UIWebView alloc] initWithFrame:frame];
		webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		webView.autoresizesSubviews = YES;
		
		[self addSubview:webView];
		
		//navBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height == 460 ? 44 : 33)];
//		navBar.barStyle = UIBarStyleBlackTranslucent;
//		UIImage *buttonImage = [UIImage imageNamed:@"NavBar-Back.png"];
//		UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//		backButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//		NSString *formattedTitle = [NSString stringWithFormat:@" %@", backTitle];
//		CGSize buttonSize = [formattedTitle sizeWithFont:[UIFont boldSystemFontOfSize:14]];
//		buttonSize.width += 12;
//		backButton.frame = CGRectMake(10, 1, buttonSize.width, 30);
//		[backButton setTitle:formattedTitle forState:UIControlStateNormal];
//		[backButton setBackgroundImage:[buttonImage stretchableImageWithLeftCapWidth:15 topCapHeight:0] forState:UIControlStateNormal];
//		[backButton addTarget:controller action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//		UIBarButtonItem *backButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
//		navBar.items = [NSArray arrayWithObject:backButtonItem];
//		[self addSubview:navBar];
		
		UIView *compassView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 31)] autorelease];
		[compassView addSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PrayerBar-CompassBackground.png"]] autorelease]];
		compassNeedle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PrayerBar-CompassNeedle.png"]];
		compassNeedle.transform = CGAffineTransformMakeRotation(PI/4.0);
		[compassView addSubview:compassNeedle];
		
		toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, frame.size.height-88, frame.size.width, 44)];
		toolbar.barStyle = UIBarStyleBlackTranslucent;
		
		UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																						target:nil
																						action:nil] autorelease];
		
		increaseSizeButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PrayerBar-IncreaseSize.png"]
																				style:UIBarButtonItemStylePlain
																			   target:controller
																			   action:@selector(increaseTextSizeAction)] autorelease];
		increaseSizeButton.width = 38;
		increaseSizeButton.enabled = [controller increaseTextSizeActionEnabled];
		
		decreaseSizeButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PrayerBar-DecreaseSize.png"]
																				style:UIBarButtonItemStylePlain
																			   target:controller
																			   action:@selector(decreaseTextSizeAction)] autorelease];
		decreaseSizeButton.width = 38;
		decreaseSizeButton.enabled = [controller decreaseTextSizeActionEnabled];
		
		UIBarButtonItem *compassButton = [[[UIBarButtonItem alloc] initWithCustomView:compassView] autorelease];
		
		bookmarkButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PrayerBar-Add.png"]
														   style:UIBarButtonItemStylePlain
														  target:controller
														  action:@selector(promptToBookmark)] autorelease];
		bookmarkButton.enabled = [controller bookmarkingEnabled];
		bookmarkButton.width = 38;

		UIBarButtonItem *emailButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PrayerBar-Email.png"]
																		 style:UIBarButtonItemStylePlain
																		target:controller
																		action:@selector(mailAction)] autorelease];
		emailButton.width = 38;

		if ([[QiblihFinder sharedInstance] isQiblihFinderEnabled])
			toolbar.items = [NSArray arrayWithObjects:increaseSizeButton, decreaseSizeButton, flexibleSpace, compassButton, flexibleSpace, bookmarkButton, emailButton, nil];
		else
			toolbar.items = [NSArray arrayWithObjects:increaseSizeButton, decreaseSizeButton, flexibleSpace, bookmarkButton, emailButton, nil];
		
		[self addSubview:toolbar];
    }
    return self;
}

- (void)layoutSubviews {
	float newHeight = self.frame.size.height;
	float newWidth = self.frame.size.width;
	
	float barHeight = newHeight == 460 ? 44 : 33;
	
	webView.frame = CGRectMake(0, 0, newWidth, newHeight);
	//navBar.frame = CGRectMake(0, 0, newWidth, barHeight);
	toolbar.frame = CGRectMake(0, newHeight-barHeight, newWidth, barHeight);
}

- (void)webViewWasTapped {
	float finalAlpha = barsHidden ? 1 : 0;

	[UIView beginAnimations:@"foo" context:nil];
	toolbar.alpha = finalAlpha;
	//navBar.alpha = finalAlpha;
	[UIView commitAnimations];
	
	barsHidden = !barsHidden;
}

- (void)setCompassNeedleAngle:(float)angle {
	[UIView beginAnimations:@"turnNeedle" context:nil];
	[UIView setAnimationDuration:0.05];
	compassNeedle.transform = CGAffineTransformMakeRotation(angle + PI/4.0);
	[UIView commitAnimations];
}

- (void)refreshTextSizeButtons {
	increaseSizeButton.enabled = [controller increaseTextSizeActionEnabled];
	decreaseSizeButton.enabled = [controller decreaseTextSizeActionEnabled];
}

- (void)setBookmarkingEnabled:(BOOL)shouldEnable {
	bookmarkButton.enabled = shouldEnable;
}


- (void)dealloc {
	[webView release];
	//[navBar release];
	[toolbar release];
	
    [super dealloc];
}


@end

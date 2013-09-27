//
//  PrayerView.m
//  BahaiWritings
//
//  Created by Arash Payan on 7/30/09.
//  Copyright 2009 Paxdot. All rights reserved.
//

#import "PrayerView.h"
#import "PrayerViewController.h"

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
        webView.backgroundColor = [UIColor whiteColor];
        webView.opaque = NO;
		
		[self addSubview:webView];
		
		toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, frame.size.height-88, frame.size.width, 44)];
//		toolbar.barStyle = UIBarStyleBlackTranslucent;
		
		UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
		
        // we use sel_registerName instead of @selector so the selector gets registered with the runtime and we
        // don't get a warning
        SEL increaseTextSelector = sel_registerName("increaseTextSizeAction");
		increaseSizeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToolBarBigger.png"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:controller
                                                             action:increaseTextSelector];
		increaseSizeButton.width = 38;
		increaseSizeButton.enabled = [controller increaseTextSizeActionEnabled];
		
        SEL decreaseTextSelector = sel_registerName("decreaseTextSizeAction");
		decreaseSizeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToolBarSmaller.png"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:controller
                                                             action:decreaseTextSelector];
		decreaseSizeButton.width = 38;
		decreaseSizeButton.enabled = [controller decreaseTextSizeActionEnabled];
		
        SEL promptToBookmarkSelector = sel_registerName("promptToBookmark");
		bookmarkButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToolBarBookmark.png"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:controller
                                                         action:promptToBookmarkSelector];
		bookmarkButton.enabled = [controller bookmarkingEnabled];
		bookmarkButton.width = 60;

        SEL mailActionSelector = sel_registerName("mailAction");
		UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ToolBarShare.png"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:controller
                                                                       action:mailActionSelector];
		emailButton.width = 38;

		toolbar.items = [NSArray arrayWithObjects:decreaseSizeButton, increaseSizeButton, flexibleSpace, bookmarkButton, emailButton, nil];
		
		[self addSubview:toolbar];
    }
    return self;
}

- (void)layoutSubviews {
	float newHeight = self.frame.size.height;
	float newWidth = self.frame.size.width;
	
	float barHeight = newHeight == 460 ? 44 : 44;
	
	webView.frame = CGRectMake(0, 0, newWidth, newHeight);
	toolbar.frame = CGRectMake(0, newHeight-barHeight, newWidth, barHeight);
}

- (void)webViewWasTapped {
	float finalAlpha = barsHidden ? 1 : 0;

	[UIView beginAnimations:@"foo" context:nil];
	toolbar.alpha = finalAlpha;
	[UIView commitAnimations];
	
	barsHidden = !barsHidden;
}

- (void)refreshTextSizeButtons {
	increaseSizeButton.enabled = [controller increaseTextSizeActionEnabled];
	decreaseSizeButton.enabled = [controller decreaseTextSizeActionEnabled];
}

- (void)setBookmarkingEnabled:(BOOL)shouldEnable {
	bookmarkButton.enabled = shouldEnable;
}

@end

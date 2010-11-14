//
//  AboutViewController.m
//  BahaiWritings
//
//  Created by Arash Payan on 8/30/08.
//  Copyright 2008 Arash Payan. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

- (id)init {
	if (self = [super init]) {
		// Initialization code

		self.title = NSLocalizedString(@"ABOUT", nil);
		[self setTabBarItem:[[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"ABOUT", nil)
														  image:[UIImage imageNamed:@"TabBarAbout.png"]
															tag:4] autorelease]];
	}
	
	return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"url to load: %@", [[request URL] absoluteString]);
	NSString *url = [[request URL] absoluteString];
	if ([url isEqualToString:@"http://arashpayan.com/in_app_pages/prayer_book/about"] ||
		[url isEqualToString:@"http://arashpayan.com/in_app_pages/prayer_book/about/"])
		return YES;
	
	[[UIApplication sharedApplication] openURL:[request URL]];
	
	return NO;
}


// Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
	webView = [[UIWebView alloc] init];
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	webView.delegate = self;
	self.view = webView;
}


// If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://arashpayan.com/in_app_pages/prayer_book/about"]] autorelease];
	[webView loadRequest:request];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)dealloc {
	[webView release];

	[super dealloc];
}


@end

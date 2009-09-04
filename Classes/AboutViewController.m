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
	if ([[[request URL] absoluteString] isEqual:@"http://arashpayan.com/projects/PrayerBook/AboutiPhone/"])
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
	NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"]
											   encoding:NSUTF8StringEncoding
												  error:nil];
	[webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://arashpayan.com/projects/PrayerBook/AboutiPhone/"]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return YES;
}


- (void)didReceiveMemoryWarning {
	printf("AboutViewController didReceiveMemoryWarning\n");
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}


- (void)dealloc {
	[webView release];

	[super dealloc];
}


@end

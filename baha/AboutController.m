//
//  AboutController.m
//  baha
//
//  Created by Arash on 2/3/19.
//  Copyright © 2019 Arash Payan. All rights reserved.
//

#import "AboutController.h"
#import "PBLocalization.h"
@import WebKit;

@interface AboutController ()

@property (nonatomic, readwrite) WKWebView *webView;

@end

@implementation AboutController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) return nil;

    self.title = l10n(@"about");
    self.tabBarItem.image = [UIImage imageNamed:@"ic_info"];
    
    return self;
}

- (void)loadView {
    WKWebViewConfiguration *cfg = [WKWebViewConfiguration new];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:cfg];
    
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    NSString *aboutPath = [NSBundle.mainBundle pathForResource:@"about" ofType:@"html"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:aboutPath];
    [self.webView loadFileURL:url allowingReadAccessToURL:url];
}

@end

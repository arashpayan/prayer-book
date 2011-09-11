//
//  PrayerView.h
//  BahaiWritings
//
//  Created by Arash Payan on 7/30/09.
//  Copyright 2009 Paxdot. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PrayerViewController;


@interface PrayerView : UIView {
	UIWebView *webView;
	UIToolbar *toolbar;
	PrayerViewController *controller;
	UIView *compassView;
	UIImageView *compassNeedle;
	UIBarButtonItem *increaseSizeButton;
	UIBarButtonItem *decreaseSizeButton;
	UIBarButtonItem *bookmarkButton;
	
	BOOL compassHidden;
	BOOL barsHidden;
}

@property (nonatomic, readonly) UIWebView *webView;
@property (nonatomic, assign) BOOL compassHidden;

- (id)initWithFrame:(CGRect)frame backTitle:(NSString*)backTitle controller:(PrayerViewController*)aController;
- (void)webViewWasTapped;
- (void)setCompassNeedleAngle:(float)angle;
- (void)refreshTextSizeButtons;
- (void)setBookmarkingEnabled:(BOOL)shouldEnable;

@end

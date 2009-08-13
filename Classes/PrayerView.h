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
	UIToolbar *navBar;
	PrayerViewController *controller;
	UIImageView *compassNeedle;
	
	BOOL barsHidden;
}

@property (nonatomic, readonly) UIWebView *webView;

- (id)initWithFrame:(CGRect)frame backTitle:(NSString*)backTitle controller:(PrayerViewController*)aController;
- (void)webViewWasTapped;
- (void)setCompassNeedleAngle:(float)angle;

@end

//
//  APWindow.m
//  BahaiWritings
//
//  Created by Arash Payan on 7/30/09.
//  Copyright 2009 Paxdot. All rights reserved.
//

#import "APWindow.h"
#import "PrayerView.h"
@class UIWebDocumentView;


@implementation APWindow

- (void)sendEvent:(UIEvent*)event {
	if (database == nil)
		database = [PrayerDatabase sharedInstance];
	
	if (database.prayerBeingViewed)
	{
		NSSet *allTouches = [event allTouches];
		if ([allTouches count] == 1)
		{
			UITouch *aTouch = [allTouches anyObject];
			if ([aTouch.view isMemberOfClass:[UIWebDocumentView class]])
			{
				if (aTouch.phase == UITouchPhaseBegan)
					startPos = [aTouch locationInView:aTouch.view];
				else if (aTouch.phase == UITouchPhaseEnded)
				{
					CGPoint endPos = [aTouch locationInView:aTouch.view];
					CGFloat dx = endPos.x - startPos.x;
					CGFloat dy = endPos.y - startPos.y;
					if ((dx*dx + dy*dy) < 225)	// a movement of <= 10 pixels
					{
						[[PrayerDatabase sharedInstance].prayerView webViewWasTapped];
					}
					
					startPos.x = -1;
					startPos.y = -1; 
				}
			}
		}
	}
	
	[super sendEvent:event];
}

@end

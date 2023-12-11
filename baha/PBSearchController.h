//
//  PBSearchControllerViewController.h
//  baha
//
//  Created by Arash on 2/2/19.
//  Copyright © 2019 Arash Payan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PBSearchController : UIViewController <UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDelegate>

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END

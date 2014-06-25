//
//  RZDebugMenuMultiItemListViewController.h
//  RZDebugMenu
//
//  Created by Clayton Rieck on 6/3/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RZDebugMenuMultiItemListViewController;
@protocol RZDebugMenuMultiItemListViewControllerDelegate <NSObject>

- (void)multiItemListDidMakeNewSelectionAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface RZDebugMenuMultiItemListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (id)initWithSelectionItems:(NSArray *)selectionItems andDelegate:(id<RZDebugMenuMultiItemListViewControllerDelegate>)delegate;

@end

//
//  RZDebugMenulet.h
//  RZDebugMenu
//
//  Created by Michael Gorbach on 3/3/15.
//  Copyright (c) 2015 Raizlabs. All rights reserved.
//

@protocol RZDebugMenulet < NSObject >

@property (copy, nonatomic, readonly) NSArray *menuItems;

@end
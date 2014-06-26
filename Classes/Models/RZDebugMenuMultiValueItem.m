//
//  RZDebugMenuMultiValueItem.m
//  RZDebugMenu
//
//  Created by Clayton Rieck on 6/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZDebugMenuMultiValueItem.h"

@interface RZDebugMenuMultiValueItem ()

@property (strong, nonatomic, readwrite) NSNumber *disclosureTableViewCellDefaultValue;
@property (strong, nonatomic, readwrite) NSArray *selectionItems;
@property (strong, nonatomic, readwrite) NSString *settingsKey;

@end

@implementation RZDebugMenuMultiValueItem

- (id)initWithTitle:(NSString *)title defaultValue:(NSNumber *)value defaultsKey:(NSString *)key andSelectionItems:(NSArray *)selectionItems
{
    self = [super init];
    if ( self ) {
        self.tableViewCellTitle = title;
        _disclosureTableViewCellDefaultValue = value;
        _selectionItems = selectionItems;
        _settingsKey = key;
    }
    return self;
}

@end

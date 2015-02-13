//
//  RZSliderTableViewCell.m
//  RZDebugMenu
//
//  Created by Clayton Rieck on 6/30/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "RZSliderTableViewCell.h"

static const CGFloat kHEYSliderMargin = 25.0f;

@implementation RZSliderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        _cellSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, width - kHEYSliderMargin, height)];
        _cellSlider.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds));
        _cellSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_cellSlider addTarget:self action:@selector(changedSlider) forControlEvents:UIControlEventValueChanged];

        [self addSubview:_cellSlider];
    }
    return self;
}

- (void)changedSlider
{
    [self.delegate didChangeSliderPosition:self];
}

@end

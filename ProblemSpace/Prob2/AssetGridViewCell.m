//
//  AssetGridViewCell.m
//  ProblemSpace
//
//  Created by MinhaSeong on 2015. 2. 17..
//  Copyright (c) 2015년 nomad. All rights reserved.
//

#import "AssetGridViewCell.h"

@implementation AssetGridViewCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    self.imageView.layer.borderColor = [UIColor blueColor].CGColor;
    self.imageView.layer.borderWidth = selected ? 2 : 0;
}

@end

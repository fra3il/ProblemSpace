//
//  PhotoViewController.m
//  ProblemSpace
//
//  Created by MinhaSeong on 2015. 2. 17..
//  Copyright (c) 2015년 nomad. All rights reserved.
//

#import "PhotoViewController.h"

@implementation PhotoViewController

#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self performSegueWithIdentifier:@"SegueFromPhotoToAssetGrid" sender:nil];
}

#pragma mark - NSObject

- (void)dealloc {
}

#pragma mark - Create

#pragma mark - Public

#pragma mark - Private

#pragma mark - Action

#pragma mark - Override

#pragma mark - Callback

#pragma mark - Delegate

#pragma mark - Notification

#pragma mark - Setter/Getter

@end

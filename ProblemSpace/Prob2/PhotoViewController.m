//
//  PhotoViewController.m
//  ProblemSpace
//
//  Created by MinhaSeong on 2015. 2. 17..
//  Copyright (c) 2015년 nomad. All rights reserved.
//

#import "PhotoViewController.h"

static NSString *const SegueFromPhotoToAssetGrid = @"SegueFromPhotoToAssetGrid";

@implementation PhotoViewController

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DLog(@"%@ %@ %@", segue.identifier, segue.sourceViewController, segue.destinationViewController);

    if ([segue.identifier isEqualToString:SegueFromPhotoToAssetGrid]) {
        AssetGridViewController *assetGridViewController = (AssetGridViewController *)segue.destinationViewController;
        assetGridViewController.eventDelegate = self;
    }
}

#pragma mark - NSObject

- (void)dealloc {
}

#pragma mark - Create

#pragma mark - Public

#pragma mark - Private

#pragma mark - Action

- (IBAction)actionAdd:(id)sender {
    [self performSegueWithIdentifier:SegueFromPhotoToAssetGrid sender:nil];
}

#pragma mark - Override

#pragma mark - Callback

#pragma mark - Delegate

- (void)didSaveAssets:(NSSet *)assets {
    DLog(@"%@", assets);
}

#pragma mark - Notification

#pragma mark - Setter/Getter

@end

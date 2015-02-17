//
//  PhotoViewController.m
//  ProblemSpace
//
//  Created by MinhaSeong on 2015. 2. 17..
//  Copyright (c) 2015년 nomad. All rights reserved.
//

#import "PhotoViewController.h"
// Frameworks
@import Photos;
// TableViewCells
#import "PhotoTableViewCell.h"

static NSString *const SegueFromPhotoToAssetGrid = @"SegueFromPhotoToAssetGrid";

@interface PhotoViewController ()

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation PhotoViewController

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
    [self.listArray insertObject:assets.allObjects atIndex:0];

    [self.tableView reloadData];

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Notification

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *assetsArray = [self.listArray objectAtIndex:indexPath.row];
    NSInteger count = assetsArray.count;

    CGFloat viewWidth = CGRectGetWidth(self.view.bounds);
    NSInteger height = (NSInteger)(viewWidth / 3.0 * 2.0);
    if (count == 4) {
        height = (NSInteger)(viewWidth / 2.0 * 2.0);
    } else if (count == 5) {
        height = (NSInteger)(viewWidth / 3.0 + viewWidth / 2.0);
    }

    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *assetsArray = [self.listArray objectAtIndex:indexPath.row];

    PhotoTableViewCell *photoCell = (PhotoTableViewCell *)cell;
    for (NSInteger index = 0; index < photoCell.imageViewArray.count; index++) {
        PHAsset *asset = [assetsArray objectAtIndex:index];

        UIImageView *imageView = [photoCell.imageViewArray objectAtIndex:index];
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize targetSize = CGSizeMake(CGRectGetWidth(imageView.bounds) * scale, CGRectGetHeight(imageView.bounds) * scale);

        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;

        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = result;
                });
            }
        }];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *assetsArray = [self.listArray objectAtIndex:indexPath.row];

    NSString *identifier = [NSString stringWithFormat:@"PhotoTableViewCell%ld", assetsArray.count];
    PhotoTableViewCell *cell = (PhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

#pragma mark - Setter/Getter

- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [[NSMutableArray alloc] init];
    }

    return _listArray;
}

@end

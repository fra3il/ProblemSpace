//
//  AssetGridViewController.m
//  ProblemSpace
//
//  Created by MinhaSeong on 2015. 2. 17..
//  Copyright (c) 2015년 nomad. All rights reserved.
//

#import "AssetGridViewController.h"
// CollectionViewCells
#import "AssetGridViewCell.h"
// Frameworks
@import Photos;

@implementation NSIndexSet (Convenience)

- (NSArray *)aapl_indexPathsFromIndexesWithSection:(NSUInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];

    return indexPaths;
}

@end

@implementation UICollectionView (Convenience)

- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) {
        return nil;
    }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }

    return indexPaths;
}

@end

static NSInteger MinSelectPhotoCount = 3;
static NSInteger MaxSelectPhotoCount = 5;

@interface AssetGridViewController () <PHPhotoLibraryChangeObserver>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButtonItem;
@property (strong) PHFetchResult *assetsFetchResults;
@property (strong) PHCachingImageManager *imageManager;
@property (strong, nonatomic) NSMutableSet *selectedAssetsSet;
@property CGRect previousPreheatRect;

@end

@implementation AssetGridViewController

static CGSize AssetGridThumbnailSize;

#pragma mark - UIViewController

- (void)awakeFromNib {
    [super awakeFromNib];

    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

    [self createAssetFetchResults];
    [self createImageManager];
    [self configureCollectionView];

    [self updateBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
}

#pragma mark - NSObject

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - Create

- (void)createAssetFetchResults {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
}

- (void)createImageManager {
    self.imageManager = [[PHCachingImageManager alloc] init];
}

- (void)configureCollectionView {
    self.collectionView.allowsMultipleSelection = YES;
}

#pragma mark - Public

#pragma mark - Private

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) {
        return;
    }

    // The preheat window is twice the height of the visible rect
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));

    // If scrolled by a "reasonable" amount...
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];

        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];

        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];

        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) {
        return nil;
    }

    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }

    return assets;
}

- (void)updateBarButtonItem {
    self.saveBarButtonItem.enabled = (self.selectedAssetsSet.count >= MinSelectPhotoCount) ? YES : NO;
}

#pragma mark - Action

- (IBAction)actionSave:(id)sender {
    if ([self.eventDelegate respondsToSelector:@selector(didSaveAssets:)]) {
        [self.eventDelegate didSaveAssets:self.selectedAssetsSet];

        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Override

#pragma mark - Callback

#pragma mark - Delegate

#pragma mark - Notification

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsFetchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetGridViewCell" forIndexPath:indexPath];

    // Increment the cell's tag
    NSInteger currentTag = cell.tag + 1;
    cell.tag = currentTag;

    PHAsset *asset = [self.assetsFetchResults objectAtIndex:indexPath.item];
    [self.imageManager requestImageForAsset:asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  // Only update the thumbnail if the cell tag hasn't changed. Otherwise, the cell has been re-used.
                                  if (cell.tag == currentTag) {
                                      cell.imageView.image = result;
                                  }
                              }];

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = [self.assetsFetchResults objectAtIndex:indexPath.item];
    cell.selected = [self.selectedAssetsSet containsObject:asset];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedAssetsSet.count < MaxSelectPhotoCount) {
        AssetGridViewCell *cell = (AssetGridViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.selected = YES;

        PHAsset *asset = [self.assetsFetchResults objectAtIndex:indexPath.item];
        [self.selectedAssetsSet addObject:asset];
    } else {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }

    [self updateBarButtonItem];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetGridViewCell *cell = (AssetGridViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;

    PHAsset *asset = [self.assetsFetchResults objectAtIndex:indexPath.item];
    [self.selectedAssetsSet removeObject:asset];

    [self updateBarButtonItem];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCachedAssets];
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        // check if there are changes to the assets (insertions, deletions, updates)
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
        if (collectionChanges) {

            // get the new fetch result
            self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];

            UICollectionView *collectionView = self.collectionView;
            if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
                // we need to reload all if the incremental diffs are not available
                [collectionView reloadData];
            } else {
                // if we have incremental diffs, tell the collection view to animate insertions and deletions
                [collectionView performBatchUpdates:^{
                    NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                    if ([removedIndexes count]) {
                        [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];

                        [self.selectedAssetsSet minusSet:[NSSet setWithArray:[collectionChanges removedObjects]]];
                    }
                    NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                    if ([insertedIndexes count]) {
                        [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                    }
                    NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                    if ([changedIndexes count]) {
                        [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                    }
                } completion:^(BOOL finished) {
                    [self updateBarButtonItem];
                }];
            }

            [self resetCachedAssets];
        }
    });
}

#pragma mark - Setter/Getter

- (NSMutableSet *)selectedAssetsSet {
    if (_selectedAssetsSet == nil) {
        _selectedAssetsSet = [[NSMutableSet alloc] init];
    }

    return _selectedAssetsSet;
}

@end

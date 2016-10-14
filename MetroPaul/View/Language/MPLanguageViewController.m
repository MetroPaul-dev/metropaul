//
//  MPLanguageViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 29/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPLanguageViewController.h"
#import "MPLanguageCollectionViewCell.h"

#define CELL_SPACE 30.0

@interface MPLanguageViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic, strong) NSArray *dataCollection;
@property(nonatomic, strong) NSArray *dataLanguages;

@end

@implementation MPLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataCollection = [NSArray arrayWithObjects:@"Français", @"English", @"Espanol", @"Italiano", nil];
    self.dataLanguages = [NSArray arrayWithObjects:@"fr", @"en", @"es", @"it", nil];
    
    [((MPNavigationController*)self.navigationController) prepareNavigationTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.language" comment:nil]];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.dataCollection count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MPLanguageCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MPLanguageCollectionViewCell" forIndexPath:indexPath];
    cell.label.text = [self.dataCollection objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString *language = [self.dataLanguages objectAtIndex:indexPath.row];
    [[MPLanguageManager sharedManager] setLanguage:language];
    [((MPNavigationController*)self.navigationController) prepareNavigationTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.language" comment:nil]];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat sizeMax = collectionView.frame.size.width;
    CGFloat cellSize = sizeMax/2-CELL_SPACE*1.5;
    return CGSizeMake(cellSize, cellSize);
}

// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(CELL_SPACE, CELL_SPACE, CELL_SPACE, CELL_SPACE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CELL_SPACE;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

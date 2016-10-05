//
//  MPLanguageViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 29/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPLanguageViewController.h"
#import "MPLanguageCollectionViewCell.h"

@interface MPLanguageViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) NSArray *dataCollection;
@property(nonatomic, strong) NSArray *dataLanguages;

@end

@implementation MPLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataCollection = [NSArray arrayWithObjects:@"Français", @"English", @"Espanol", @"Italiano", nil];
    self.dataLanguages = [NSArray arrayWithObjects:@"fr", @"en", @"es", @"it", nil];
    // Do any additional setup after loading the view.
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
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(155, 155);
}

// 3
/*- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat sizeMax = self.collectionView.frame.size.width;
    NSInteger nbElement = sizeMax/CELL_WIDTH;
    NSInteger border = (sizeMax - CELL_WIDTH*nbElement)/nbElement;
    return UIEdgeInsetsMake(border*1.5, border, border*1.5, border);
}
 */

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

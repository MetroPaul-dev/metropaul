//
//  MapDownloadViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 02/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MapDownloadViewController.h"
#import "XMLParser.h"
#import <SKMaps/SKMaps.h>
#import "SKTMapsObject.h"
#import "MPMapDownloadCell.h"

@interface MapDownloadViewController () <SKTDownloadManagerDelegate, SKTDownloadManagerDataSource, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property(nonatomic,strong) SKTPackage* regionToDownload;
@property(nonatomic,strong) NSMutableArray *packageList;
@property(nonatomic,strong) NSArray* oldPackages;

@end

@implementation MapDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oldPackages =   [[SKMapsService sharedInstance].packagesManager installedOfflineMapPackages] ; // all installed packages for all versions
    self.packageList = [NSMutableArray array];
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    SKTPackage *ileDeFrance = [appDelegate.skMapsObject packageForCode:@"FRJ"];
    if (ileDeFrance != nil) {
        [self.packageList addObject:ileDeFrance];
    }
    
    if (![XMLParser sharedInstance].isParsingFinished) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showDownloadUI) name:kParsingFinishedNotificationName object:nil];
    }
    else {
        [[SKTDownloadManager sharedInstance] cancelDownload];
    }
    
    [((MPNavigationController*)self.navigationController) prepareNavigationTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.download" comment:nil]];
    
    if ([[SKTDownloadManager sharedInstance] isDownloadPaused]) {
        [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"Un téléchargement est en pause" delegate:self cancelButtonTitle:@"Supprimer" otherButtonTitles:@"Reprendre", nil] show];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
        [super viewWillDisappear:animated];
        [[SKTDownloadManager sharedInstance] cancelDownload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDownloadUI {
    self.oldPackages = [[SKMapsService sharedInstance].packagesManager installedOfflineMapPackages] ; // all installed packages for all versions
    [self.tableView reloadData];
}

#pragma mark - SKTDownloadManagerDelegate

- (void)downloadManager:(SKTDownloadManager *)downloadManager saveDownloadHelperToDatabase:(SKTDownloadObjectHelper *)downloadHelper {
    NSString *path = [[SKTDownloadManager libraryDirectory] stringByAppendingPathComponent:[downloadHelper getCode]];
    
    NSString *code = [downloadHelper getCode];
    [[SKMapsService sharedInstance].packagesManager addOfflineMapPackageNamed:code inContainingFolderPath:path];
    NSError *error;
    NSFileManager *fman = [NSFileManager new];
    [fman removeItemAtPath:path error:&error];
}

- (void)notEnoughDiskSpace {
    NSLog(@"not enough space");
    [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"L'espace disque est insuffisant" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    [[SKTDownloadManager sharedInstance] cancelDownload];
}

- (void)didCancelDownload {
    NSLog(@"didCancelDownload");
    self.progressView.progress = 0;
    self.percentLabel.text = @"";
    self.speedLabel.text = @"";
    self.oldPackages =   [[SKMapsService sharedInstance].packagesManager installedOfflineMapPackages] ; // all installed packages for all versions
    [self.tableView reloadData];
    // [self.startButton setEnabled:YES];
}

- (void)downloadManager:(SKTDownloadManager *)downloadManager didPauseDownloadForDownloadHelper:(SKTDownloadObjectHelper *)downloadHelper {
    NSLog(@"didPauseDownloadForDownloadHelper");
    self.oldPackages =   [[SKMapsService sharedInstance].packagesManager installedOfflineMapPackages] ; // all installed packages for all versions
    [[SKTDownloadManager sharedInstance] cancelDownload];
    [self.tableView reloadData];
    // [self.startButton setEnabled:YES];
    
}

- (void)downloadManager:(SKTDownloadManager *)downloadManager didResumeDownloadForDownloadHelper:(SKTDownloadObjectHelper *)downloadHelper {
    NSLog(@"didResumeDownloadForDownloadHelper");
    self.oldPackages =   [[SKMapsService sharedInstance].packagesManager installedOfflineMapPackages] ; // all installed packages for all versions
    [self.tableView reloadData];
}

- (void)downloadManager:(SKTDownloadManager *)downloadManager internetAvailabilityChanged:(BOOL)isAvailable {
    
}

- (void)downloadManagerSwitchedWifiToCellularNetwork:(SKTDownloadManager *)downloadManager {
    
}

- (void)downloadManager:(SKTDownloadManager *)downloadManager didUpdateDownloadSpeed:(NSString *)speed andRemainingTime:(NSString *)remainingTime {
    self.speedLabel.text = remainingTime;
}

- (void)downloadManager:(SKTDownloadManager *)downloadManager didUpdateCurrentDownloadProgress:(NSString *)currentPorgressString currentDownloadPercentage:(float)currentPercentage overallDownloadProgress:(NSString *)overallProgressString overallDownloadPercentage:(float)overallPercentage forDownloadHelper:(SKTDownloadObjectHelper *)downloadHelper {
    self.progressView.progress = overallPercentage / 100;
    self.percentLabel.text = overallProgressString;
}

- (void)downloadManager:(SKTDownloadManager *)downloadManager didUpdateUnzipProgress:(NSString *)progressString percentage:(float)percentage forDownloadHelper:(SKTDownloadObjectHelper *)downloadHelper {
    self.progressView.progress = percentage / 100;
    self.percentLabel.text = progressString;
}

- (void)downloadManager:(SKTDownloadManager *)downloadManager didDownloadDownloadHelper:(SKTDownloadObjectHelper *)downloadHelper withSuccess:(BOOL)success {
    self.progressView.progress = 1;
    self.percentLabel.text = @"Download finished";
    
    [self showDownloadUI];
}

- (void)operationsCancelledByOSDownloadManager:(SKTDownloadManager *)downloadManager {
    NSLog(@"operationsCancelledByOSDownloadManager");
}

#pragma mark - SKTDownloadManagerDataSource

- (BOOL)isOnBoardMode {
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.packageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKTPackage *package = [self.packageList objectAtIndex:indexPath.row];
    
    MPMapDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MPMapDownloadCell class])];
    cell.button.tag = [indexPath row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ - %0lldMB",[package nameForLanguageCode:@"en"], package.size/1000000]];
    
    BOOL find = NO;
    for (SKMapPackage *oldPackage in self.oldPackages) {
        if ([oldPackage.name isEqualToString:package.packageCode]) {
            find = YES;
        }
    }
    if (find) {
        [cell.button setTitle:@"Delete" forState:UIControlStateNormal];
        [cell.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(didTapButtonDeletePackage:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        
        [cell.button setTitle:@"Download" forState:UIControlStateNormal];
        [cell.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(didTapButtonDownloadPackage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didTapButtonDownloadPackage:(UIButton*)sender {
    self.progressView.progress = 0;
    
    self.regionToDownload = [self.packageList objectAtIndex:sender.tag];
    SKTDownloadObjectHelper *region = [SKTDownloadObjectHelper downloadObjectHelperWithSKTPackage:self.regionToDownload];
    
    [[SKTDownloadManager sharedInstance] requestDownloads:@[region] startAutomatically:YES withDelegate:self withDataSource:self];
}

- (void)didTapButtonDeletePackage:(UIButton*)sender {
    SKTPackage *package = [self.packageList objectAtIndex:sender.tag];
    
    [[[SKMapsService sharedInstance] packagesManager] deleteOfflineMapPackageNamed:package.packageCode];
    self.oldPackages =   [[SKMapsService sharedInstance].packagesManager installedOfflineMapPackages] ; // all installed packages for all versions
    [self.tableView reloadData];
}

@end

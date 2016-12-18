//
//  MPItineraryViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 06/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPItineraryViewController.h"
#import "MPItineraryCell.h"
#import "MPGlobalItineraryManager.h"
#import "MPGlobalItinerary.h"

#import "DetailItineraryViewController.h"

@interface MPItineraryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *startIconImage;
@property (weak, nonatomic) IBOutlet UIButton *startAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *startExchangeButton;
@property (weak, nonatomic) IBOutlet UIImageView *destinationIconImage;
@property (weak, nonatomic) IBOutlet UIButton *destinationAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *destinationExchangeButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *globalItineraries;
@end

@implementation MPItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.globalItineraries = [NSArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculAllItineraryFinish) name:kNotifItineraryCalculated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculAllItineraryFailed) name:kNotifItineraryCalculFailed object:nil];
    
    //    self.navigationItem.leftBarButtonItems = nil;
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
    //                                             initWithImage:[UIImage imageNamed:@"icon-menu"]
    //                                             style:UIBarButtonItemStylePlain
    //                                             target:[MPRevealController sharedInstance]
    //                                             action:@selector(showLeftController)];
    
    //    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.startIconImage.tintColor = [UIColor whiteColor];
    self.destinationIconImage.tintColor = [UIColor whiteColor];
    
    MPLanguageManager *languageManager = [MPLanguageManager sharedManager];
    if ([MPGlobalItineraryManager sharedManager].startAddress == nil || ![[MPGlobalItineraryManager sharedManager].startAddress checkAddressValidity]) {
        [self alertViewError:[languageManager getStringWithKey:@"alert.title.error"] message:[languageManager getStringWithKey:@"alert.message.noStart"]];
    }
    if ([MPGlobalItineraryManager sharedManager].destinationAddress == nil || ![[MPGlobalItineraryManager sharedManager].destinationAddress checkAddressValidity]) {
        [self alertViewError:[languageManager getStringWithKey:@"alert.title.error"] message:[languageManager getStringWithKey:@"alert.message.noDestination"]];
    }
    
    [self setLoading:YES];
    [[MPGlobalItineraryManager sharedManager] calculAllItinerary];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [((MPNavigationController*)self.navigationController) prepareNavigationTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.itinerary" comment:nil]];
    
    [self.startAddressButton setTitle:[[[MPGlobalItineraryManager sharedManager] startAddress] name] forState:UIControlStateNormal];
    if ([[[MPGlobalItineraryManager sharedManager] startAddress] name] == [[MPLanguageManager sharedManager] getStringWithKey:@"searchBar.yourPosition"]) {
        self.startIconImage.image = [UIImage imageNamed:@"icon-pin"];
    } else {
        self.startIconImage.image = [UIImage imageNamed:@"icon-search"];
    }
    [self.destinationAddressButton setTitle:[[[MPGlobalItineraryManager sharedManager] destinationAddress] name] forState:UIControlStateNormal];
    if ([[[MPGlobalItineraryManager sharedManager] destinationAddress] name] == [[MPLanguageManager sharedManager] getStringWithKey:@"searchBar.yourPosition"]) {
        self.destinationIconImage.image = [UIImage imageNamed:@"icon-pin"];
    } else {
        self.destinationIconImage.image = [UIImage imageNamed:@"icon-search"];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setLoading:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.globalItineraries.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPItineraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPItineraryCell"];
    MPGlobalItinerary *globalItinerary = [self.globalItineraries objectAtIndex:indexPath.section];
    [cell setGlobalItinerary:globalItinerary];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailItineraryViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailItineraryViewController"];
    MPItineraryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    vc.itinerary = cell.globalItinerary;
    
    MPRevealController *revealController = [MPRevealController sharedInstance];
    [(UINavigationController*)revealController.frontViewController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 132.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)calculAllItineraryFinish {
    [self setLoading:NO];
    self.globalItineraries = [[MPGlobalItineraryManager sharedManager] globalItineraryList];
    [self.tableView reloadData];
    MPLanguageManager *languageManager = [MPLanguageManager sharedManager];
    
    if (self.globalItineraries == nil || self.globalItineraries.count == 0) {
        [self alertViewError:[languageManager getStringWithKey:@"alert.title.error"] message:[languageManager getStringWithKey:@"alert.message.noItinerary"]];
    }
}

- (void)calculAllItineraryFailed {
    [self setLoading:NO];
    
    MPLanguageManager *languageManager = [MPLanguageManager sharedManager];
    [self alertViewError:[languageManager getStringWithKey:@"alert.title.error"] message:[languageManager getStringWithKey:@"alert.message.itinerary.problem"]];
}

- (void)alertViewError:(NSString*)title message:(NSString*)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}
- (IBAction)tapOnAddressButton:(UIButton*)sender {
    switch (sender.tag) {
        case 0:
            [[MPGlobalItineraryManager sharedManager] setAddressToReplace:MPAddressToReplaceStart];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
            [[MPGlobalItineraryManager sharedManager] setAddressToReplace:MPAddressToReplaceDestination];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

- (IBAction)tapOnExchangeButton:(UIButton*)sender {
    [self setLoading:YES];
    
    MPAddress *tmp = [[MPGlobalItineraryManager sharedManager] startAddress];
    [[MPGlobalItineraryManager sharedManager] setStartAddress:[[MPGlobalItineraryManager sharedManager] destinationAddress]];
    [[MPGlobalItineraryManager sharedManager] setDestinationAddress:tmp];
    [self.startAddressButton setTitle:[[[MPGlobalItineraryManager sharedManager] startAddress] name] forState:UIControlStateNormal];
    [self.destinationAddressButton setTitle:[[[MPGlobalItineraryManager sharedManager] destinationAddress] name] forState:UIControlStateNormal];
    [[MPGlobalItineraryManager sharedManager] calculAllItinerary];
}


@end

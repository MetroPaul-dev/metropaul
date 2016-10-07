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

@interface MPItineraryViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MPItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculAllItineraryFinish) name:kNotifItineraryCalculated object:nil];

    [[MPGlobalItineraryManager sharedManager] calculAllItinerary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPItineraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPItineraryCell"];
    
    return cell;
}

- (void)calculAllItineraryFinish {
    NSLog(@"ok");
}

@end

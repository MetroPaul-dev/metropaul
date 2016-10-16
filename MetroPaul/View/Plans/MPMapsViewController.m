//
//  MPMapsViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 16/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPMapsViewController.h"
#import "MPMapsCell.h"

@interface MPMapsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MPMapsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [((MPNavigationController*)self.navigationController) prepareNavigationTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.maps" comment:nil]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPMapsCell *cell = (MPMapsCell*)[tableView dequeueReusableCellWithIdentifier:@"MPMapsCell"];
    switch (indexPath.section) {
        case 0:{
            cell.imageView.image = [UIImage imageNamed:@"icon-plan-metro"];
            cell.textLabel.text = @"Plan de métro + tram";
            break;
        }
        case 1:{
            cell.imageView.image = [UIImage imageNamed:@"icon-plan-velib"];
            cell.textLabel.text = @"Stations vélib";

            break;
        }
        case 2:{
            cell.imageView.image = [UIImage imageNamed:@"icon-plan-bus"];
            cell.textLabel.text = @"Plan des bus";

            break;
        }
        case 3:{
            cell.imageView.image = [UIImage imageNamed:@"icon-plan-noctilien"];
            cell.textLabel.text = @"Plan des Noctiliens";

            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

@end

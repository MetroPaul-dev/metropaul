//
//  LeftViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 29/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "LeftViewController.h"
#import "MPRevealController.h"
#import "MPLanguageViewController.h"
#import "MPCGUViewController.h"
#import "MPSwitchCell.h"
#import "MapDownloadViewController.h"
#import "MPMapsViewController.h"

#import <MessageUI/MessageUI.h>

#define YOUR_APP_STORE_ID 450174891 //Change this one to your ID
#define CELL_HEIGHT 50.0
#define FIRST_HEADER_HEIGHT 10.0
#define SECOND_HEADER_HEIGHT 40.0


@interface LeftViewController () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, MPSwitchCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LeftViewController {
    NSArray *tableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [Constantes blueBackGround];
    tableData = [Constantes rowMenu];
    
    self.tableView.alwaysBounceVertical = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    tableData = [Constantes rowMenu];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[tableData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
//    if (indexPath.section == 1 && indexPath.row == 1) {
//        MPSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPSwitchCell"];
//        BOOL valueSwitch = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PMR"] boolValue];
//        [cell setTitle:[[dict objectForKey:KEY_TITLE_ROW] uppercaseString] image:[dict objectForKey:KEY_IMAGE_ROW] switchState:valueSwitch];
//        cell.delegate = self;
//        return cell;
//    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.backgroundColor = [Constantes blueBackGround];
            cell.imageView.tintColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont fontWithName:FONT_MEDIUM size:16.0];
        }
        cell.textLabel.text = [[dict objectForKey:KEY_TITLE_ROW] uppercaseString];
        cell.imageView.image = [dict objectForKey:KEY_IMAGE_ROW];
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MPRevealController *revealController = [MPRevealController sharedInstance];
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0: {
                    [(UINavigationController*)revealController.frontViewController popToRootViewControllerAnimated:YES];
                    [revealController showFrontViewController];
                    break;
                }
                case 1: {
                    
                    NSString *iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:iOS7AppStoreURLFormat, YOUR_APP_STORE_ID]];
                    [[UIApplication sharedApplication] openURL:url];
                    break;
                }
                case 2: {
                    NSString *appName=[[[NSBundle mainBundle] infoDictionary]  objectForKey:(id)kCFBundleNameKey];
                    
                    NSString *textToShare = [NSString stringWithFormat:@"http://itunes.com/app/%@", appName];
                    NSArray *itemsToShare = @[textToShare];
                    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
                    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks];
                    [self presentViewController:activityVC animated:YES completion:nil];
                    break;
                }
                case 3: {
                    [(UINavigationController*)revealController.frontViewController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass ([MPMapsViewController class])] animated:YES];
                    [revealController showFrontViewController];
                    break;
                }
                case 4: {
                    if ([MFMailComposeViewController canSendMail]) {
                        
                        // Email Subject
                        // NSString *emailTitle = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"title.mail", nil),[self.annonce title]];
                        // Email Content
                        //NSString *messageBody = [NSString stringWithFormat:@"<h3>%@<a href=\"%@\">%@</a>.</h3>\n\n<a>%@</a>", NSLocalizedString(@"title.mail", nil),[self.annonce lien], [self.annonce title], [self.annonce lien]];
                        // To address
                        NSArray *toRecipents = [NSArray arrayWithObject:@"contact@metropaul.fr"];
                        
                        
                        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                        
                        mc.mailComposeDelegate = self;
                        // [mc setSubject:emailTitle];
                        //[mc setMessageBody:messageBody isHTML:YES];
                        [mc setToRecipients:toRecipents];
                        
                        [self presentViewController:mc animated:YES completion:NULL];
                    } else {
                        [[[UIAlertView alloc] initWithTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"alert.title.impossible"]
                                                    message:[[MPLanguageManager sharedManager] getStringWithKey:@"alert.message.configure.mail"]
                                                   delegate:nil
                                          cancelButtonTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"alert.title.ok"]
                                          otherButtonTitles:nil] show];
                    }
                    break;
                }
                case 5: {
                    [(UINavigationController*)revealController.frontViewController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass ([MPCGUViewController class])] animated:YES];
                    [revealController showFrontViewController];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0: {
                    MapDownloadViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MapDownloadViewController class])];
                    [(UINavigationController*)revealController.frontViewController pushViewController:vc animated:YES];
                    [revealController showFrontViewController];
                    break;
                }
                case 1: {
                    [(UINavigationController*)revealController.frontViewController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass ([MPLanguageViewController class])] animated:YES];
                    [revealController showFrontViewController];
                    
                    break;
                }
//                case 1: {
//                    break;
//                }
//                case 2: {
//                    [(UINavigationController*)revealController.frontViewController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass ([MPLanguageViewController class])] animated:YES];
//                    [revealController showFrontViewController];
//                    
//                    break;
//                }
                default:
                    break;
            }
            
            break;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:[tableView rectForHeaderInSection:section]];
    view.backgroundColor = [UIColor clearColor];
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(20.0, 0, [view getWidth]-40.0, 1)];
    separator.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.35];
    [view addSubview:separator];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0, [view getWidth]-20.0, [view getHeight])];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:FONT_MEDIUM size:18.0];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    
    switch (section) {
        case 1: {
            label.text = [[[MPLanguageManager sharedManager] getStringWithKey:@"menu.parameters" comment:nil] uppercaseString];
            break;
        }
        default:
            break;
    }
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:[tableView rectForFooterInSection:section]];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return FIRST_HEADER_HEIGHT;
    } else {
        return SECOND_HEADER_HEIGHT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0) {
        long nbCell = [[tableData objectAtIndex:0] count] + [[tableData objectAtIndex:1] count];
        
        CGFloat heightUsed = nbCell*CELL_HEIGHT+ FIRST_HEADER_HEIGHT + SECOND_HEADER_HEIGHT;
        if ([self.tableView getHeight] - heightUsed <= 0) {
            return 0;
        } else {
            return [self.tableView getHeight] - heightUsed;
        }
    }
    
    return 0;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - MPSwitchCellDelegate

- (void)switchCellChanged:(MPSwitchCell *)cell {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:cell.switchView.isOn] forKey:@"PMR"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

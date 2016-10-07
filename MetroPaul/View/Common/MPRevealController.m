//
//  MPRevealController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 29/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPRevealController.h"
#import "MPNavigationController.h"

@interface MPRevealController ()<PKRevealing>
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) LeftViewController *menuController;

@end

@implementation MPRevealController

+ (MPRevealController *)sharedInstance {
    static MPRevealController *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        // Step 1: Create your controllers.
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        // Step 2: Instantiate
        sharedInstance = [MPRevealController revealControllerWithFrontViewController:[[MPNavigationController alloc] initWithRootViewController:[storyboard instantiateInitialViewController]] leftViewController:[storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"] rightViewController:nil];
        
        // Step 3: Configure.
        sharedInstance.animationDuration = 0.25;
        sharedInstance.recognizesPanningOnFrontView = NO;
        [sharedInstance setMinimumWidth:sharedInstance.view.frame.size.width*0.8 maximumWidth:sharedInstance.view.frame.size.width*0.8 forViewController:sharedInstance.leftViewController];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)showLeftController {
    [self showViewController:self.leftViewController];
}

- (void)showFrontViewController
{
    [self showViewController:self.frontViewController];
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

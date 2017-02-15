//
//  MPBaseViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 18/12/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPBaseViewController.h"

@interface MPBaseViewController ()

@end

@implementation MPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadOverlay = [[NSBundle mainBundle] loadNibNamed:@"MPLoadOverlay" owner:self options:nil][0];
    (self.loadOverlay).frame = self.view.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLoading:(BOOL)loading {
    _loading = loading;
    if (self.loadOverlay != nil) {
        [self.loadOverlay removeFromSuperview];
        
        if (loading) {
            [self.loadOverlay randomLoadView];
            UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
            [currentWindow addSubview:self.loadOverlay];
        }
    }
}

@end

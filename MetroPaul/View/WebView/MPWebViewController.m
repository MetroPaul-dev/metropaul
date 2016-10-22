//
//  MPWebViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 22/10/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MPWebViewController.h"

@interface MPWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.mapFileURL];
    [self.webView loadRequest:request];
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

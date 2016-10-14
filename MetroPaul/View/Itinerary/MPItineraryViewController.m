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

@interface MPItineraryViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *startSearchBar;
@property (weak, nonatomic) IBOutlet UISearchBar *destinationSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *globalItineraries;
@end

@implementation MPItineraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.globalItineraries = [NSArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculAllItineraryFinish) name:kNotifItineraryCalculated object:nil];
    MPLanguageManager *languageManager = [MPLanguageManager sharedManager];
    if ([MPGlobalItineraryManager sharedManager].startAddress == nil || [[MPGlobalItineraryManager sharedManager].startAddress checkAddressValidity]) {
        [self alertViewError:[languageManager getStringWithKey:@"alert.title.error"] message:[languageManager getStringWithKey:@"alert.message.noStart"]];
    }
    if ([MPGlobalItineraryManager sharedManager].destinationAddress == nil || [[MPGlobalItineraryManager sharedManager].destinationAddress checkAddressValidity]) {
        [self alertViewError:[languageManager getStringWithKey:@"alert.title.error"] message:[languageManager getStringWithKey:@"alert.message.noDestination"]];
    }
    [[MPGlobalItineraryManager sharedManager] calculAllItinerary];
    
    self.startSearchBar.delegate = self;
    self.startSearchBar.showsCancelButton = NO;
    self.startSearchBar.barTintColor = [Constantes blueBackGround];
    self.startSearchBar.tintColor = [UIColor whiteColor];
    self.startSearchBar.layer.borderWidth = 1;
    self.startSearchBar.layer.borderColor = [[Constantes blueBackGround] CGColor];
    
    NSArray *searchBarSubViews = [[self.startSearchBar.subviews objectAtIndex:0] subviews];
    for (UIView *view in searchBarSubViews) {
        if([view isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField*)view;
            [textField setBorderStyle:UITextBorderStyleNone];
            textField.layer.cornerRadius = 0;
            
            [textField setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
            [textField setTextColor:[UIColor whiteColor]];
            
            UIImageView *imgView = (UIImageView*)textField.leftView;
            [imgView setWidth:24.0];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image = [[UIImage imageNamed:@"icon-search"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            imgView.tintColor = [UIColor whiteColor];
            textField.leftViewMode = UITextFieldViewModeAlways;
            
            UIButton *btnClear = (UIButton*)[textField valueForKey:@"clearButton"];
            [btnClear setImage:[[UIImage imageNamed:@"icon-cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [btnClear setImage:[[UIImage imageNamed:@"icon-cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
            [btnClear setImage:[[UIImage imageNamed:@"icon-cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
            
            btnClear.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
            btnClear.tintColor = [UIColor whiteColor];
        }
    }
    
    [self.startSearchBar reloadInputViews];
    
    self.destinationSearchBar.delegate = self;
    self.destinationSearchBar.showsCancelButton = NO;
    self.destinationSearchBar.barTintColor = [Constantes blueBackGround];
    self.destinationSearchBar.tintColor = [UIColor whiteColor];
    self.destinationSearchBar.layer.borderWidth = 1;
    self.destinationSearchBar.layer.borderColor = [[Constantes blueBackGround] CGColor];
    
    searchBarSubViews = [[self.destinationSearchBar.subviews objectAtIndex:0] subviews];
    for (UIView *view in searchBarSubViews) {
        if([view isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField*)view;
            [textField setBorderStyle:UITextBorderStyleNone];
            textField.layer.cornerRadius = 0;
            
            [textField setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
            [textField setTextColor:[UIColor whiteColor]];
            
            UIImageView *imgView = (UIImageView*)textField.leftView;
            [imgView setWidth:24.0];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image = [[UIImage imageNamed:@"icon-search"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            imgView.tintColor = [UIColor whiteColor];
            textField.leftViewMode = UITextFieldViewModeAlways;
            
            UIButton *btnClear = (UIButton*)[textField valueForKey:@"clearButton"];
            [btnClear setImage:[[UIImage imageNamed:@"icon-cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [btnClear setImage:[[UIImage imageNamed:@"icon-cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
            [btnClear setImage:[[UIImage imageNamed:@"icon-cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
            
            btnClear.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
            btnClear.tintColor = [UIColor whiteColor];
        }
    }
    
    [self.destinationSearchBar reloadInputViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.startSearchBar.text = [[[MPGlobalItineraryManager sharedManager] startAddress] name];
    self.destinationSearchBar.text = [[[MPGlobalItineraryManager sharedManager] destinationAddress] name];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)calculAllItineraryFinish {
    self.globalItineraries = [[MPGlobalItineraryManager sharedManager] globalItineraryList];
    [self.tableView reloadData];
    MPLanguageManager *languageManager = [MPLanguageManager sharedManager];

    if (self.globalItineraries == nil || self.globalItineraries.count == 0) {
        [self alertViewError:[languageManager getStringWithKey:@"alert.title.error"] message:[languageManager getStringWithKey:@"alert.message.noItinerary"]];
    }
}

- (void)alertViewError:(NSString*)title message:(NSString*)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end

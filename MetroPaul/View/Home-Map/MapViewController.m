//
//  MapViewController.m
//  MetroPaul
//
//  Created by Antoine Cointepas on 29/09/2016.
//  Copyright © 2016 Antoine Cointepas. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import <SKMaps/SKMaps.h>
#import "MPRevealController.h"
#import "MPLine.h"
#import "MPStopArea.h"
#import "MPSearchResultDestinationCell.h"
#import "MPItineraryViewController.h"
#import "MPGlobalItineraryManager.h"

#define CELL_HEIGHT 50
#define INFOVIEW_HEIGHT 70
#define ANNOTATION_IDENTIFIER_USER_LOCATION 0
#define RESULT_LIMIT 7

static SKListLevel listLevel;

@interface MapViewController () <SKMapViewDelegate, SKSearchServiceDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property(nonatomic, strong) UISearchController *searchController;
@property(nonatomic, strong) NSMutableArray *searchResultsSkobbler;
@property(nonatomic, strong) NSMutableArray *searchResultsStopArea;

@property (strong, nonatomic) IBOutlet SKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imageInfoView;
@property (weak, nonatomic) IBOutlet UILabel *labelInfoView;
@property (weak, nonatomic) IBOutlet UIButton *buttonInfoView;

@property(nonatomic, strong) SKMultiStepSearchSettings *multiStepSearchObject;
@property(nonatomic, strong) NSArray *stopAreas;

@property(nonatomic, strong) NSArray *downloadPackage;
@property(nonatomic, strong) SKSearchResult *searchResult;
@property(nonatomic, strong) MPStopArea *stopArea;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"icon-menu"]
                                             style:UIBarButtonItemStylePlain
                                             target:[MPRevealController sharedInstance]
                                             action:@selector(showLeftController)];
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.searchResultsSkobbler = [NSMutableArray array];
    self.searchResultsStopArea = [NSMutableArray array];
    
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = NO;
    self.searchBar.barTintColor = [Constantes blueBackGround];
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = [[Constantes blueBackGround] CGColor];
    
    NSArray *searchBarSubViews = [[self.searchBar.subviews objectAtIndex:0] subviews];
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
    
    [self.searchBar reloadInputViews];
    
    [self showTableView:NO];
    [self.tableView registerNib:[UINib nibWithNibName:@"MPSearchResultDestinationCell" bundle:nil] forCellReuseIdentifier:@"MPSearchResultDestinationCell"];
    self.tableView.backgroundColor = [Constantes blueBackGround];
    self.mapView.delegate = self;
    self.mapView.mapScaleView.hidden = YES;
    
    [self showInfoView:NO];
    
    [SKSearchService sharedInstance].searchServiceDelegate = self;
    [SKSearchService sharedInstance].searchResultsNumber = 7;
    [SKMapsService sharedInstance].connectivityMode = SKConnectivityModeOffline;
    
    self.stopAreas = [MPStopArea findAll];
    
    self.infoView.backgroundColor = [Constantes blueBackGround];
    self.imageInfoView.tintColor = [UIColor whiteColor];
    self.labelInfoView.font = [UIFont fontWithName:FONT_MEDIUM size:13.0f];
    [self.buttonInfoView.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:16.0f]];
    
    [((MPNavigationController*)self.navigationController) prepareNavigationTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.plan" comment:nil]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [((MPNavigationController*)self.navigationController) prepareNavigationTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.plan" comment:nil]];
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"icon-menu"]
                                             style:UIBarButtonItemStylePlain
                                             target:[MPRevealController sharedInstance]
                                             action:@selector(showLeftController)];
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.downloadPackage = [[SKMapsService sharedInstance].packagesManager installedOfflineMapPackages];
    if (self.downloadPackage.count <= 0) {
        [self alertViewDownloadMap];
        
        [self.searchBar setUserInteractionEnabled:NO];
    } else {
        [self.searchBar setUserInteractionEnabled:YES];
    }
    
    // self.tableViewBottomConstraint.constant = self.view.frame.size.height-self.searchController.searchBar.frame.size.height;
    
    [self centerOnCoordinate:[[SKPositionerService sharedInstance] currentCoordinate]];
    
    for (MPStopArea *stopArea in self.stopAreas) {
        [self addAnnotationWithStopArea:stopArea];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self.searchBar.text isEqual: @""]) {
        if (self.searchResultsStopArea.count + self.searchResultsSkobbler.count > RESULT_LIMIT) {
            NSInteger i = 0;
            NSInteger j = 0;
            
            while (i + j < RESULT_LIMIT) {
                if (i < self.searchResultsStopArea.count && i + j < RESULT_LIMIT) {
                    i++;
                }
                if (j < self.searchResultsSkobbler.count && i + j < RESULT_LIMIT) {
                    j++;
                }
            }
            if (section == 0) {
                return i;
            } else {
                return j;
            }
        } else {
            if (section == 0) {
                return self.searchResultsStopArea.count;
            } else {
                return self.searchResultsSkobbler.count;
            }
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPSearchResultDestinationCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"MPSearchResultDestinationCell"];
    if (cell == nil) {
        cell = [[MPSearchResultDestinationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MPSearchResultDestinationCell"];
    }
    if (indexPath.section == 0) {
        MPStopArea *stopArea = [self.searchResultsStopArea objectAtIndex:indexPath.row];
        cell.textLabel.text = [stopArea name];
        cell.imageView.image = [UIImage imageNamed:@"icon-metro"];
    } else {
        SKSearchResult *searchResult = [self.searchResultsSkobbler objectAtIndex:indexPath.row];
        NSMutableString *labelCell = [NSMutableString stringWithString:searchResult.name];
        for (SKSearchResultParent *parent in searchResult.parentSearchResults) {
            if (parent.type < SKSearchResultStreet) {
                [labelCell appendString:[NSString stringWithFormat:@", %@", parent.name]];
            }
        }
        cell.imageView.image = [UIImage imageNamed:@"icon-pin"];
        cell.textLabel.text = labelCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MPStopArea *stopArea = [self.searchResultsStopArea objectAtIndex:indexPath.row];
        [self setDestinationWithStopArea:stopArea];
    } else {
        SKSearchResult *searchResult = [self.searchResultsSkobbler objectAtIndex:indexPath.row];
        [self setDestinationWithSearchResult:searchResult];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
    [self showTableView:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self showTableView:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:searchText scope:@"All"];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self showTableView:NO];
    [self.searchBar resignFirstResponder];
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    if (![self.searchController.searchBar.text  isEqual: @""]) {
            listLevel = SKStreetList;
            
            self.multiStepSearchObject = [SKMultiStepSearchSettings multiStepSearchSettings];
            self.multiStepSearchObject.listLevel = listLevel;
            self.multiStepSearchObject.offlinePackageCode = [(SKMapPackage*)[self.downloadPackage firstObject] name]; // Paris package has to be downloaded
            self.multiStepSearchObject.searchTerm = searchText;
            //self.multiStepSearchObject.parentIndex = -1;
            [[SKSearchService sharedInstance] startMultiStepSearchWithSettings:self.multiStepSearchObject];
            
            NSArray *stopArea = [MPStopArea findByName:searchText];
            [self.searchResultsStopArea removeAllObjects];
            [self.searchResultsStopArea addObjectsFromArray:stopArea];
    } else {
        [self.searchResultsStopArea removeAllObjects];
        [self.searchResultsSkobbler removeAllObjects];
        [self.tableView reloadData];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Map method

- (void)centerOnCoordinate:(CLLocationCoordinate2D)coordinate {
    /*   SKCoordinateRegion region;
     region.center = coordinate;
     region.zoomLevel = 17;
     [self.mapView setVisibleRegion:region];
     */
    [self.mapView animateToZoomLevel:17];
    [self.mapView animateToLocation:coordinate withPadding:CGPointZero duration:1.0];
}

- (void)addAnnotationPinWithCoordinate:(CLLocationCoordinate2D)coordinate {
    //Annotation with type
    SKAnnotation *annotation = [SKAnnotation annotation];
    annotation.identifier = 1;
    annotation.annotationType = SKAnnotationTypeRed;
    annotation.location = coordinate;
    SKAnimationSettings *animationSettings = [SKAnimationSettings animationSettings];
    [self.mapView addAnnotation:annotation withAnimationSettings:animationSettings];
}

- (void)addAnnotationWithStopArea:(MPStopArea*)stopArea {
    
    NSMutableArray *lineTypes = [NSMutableArray array];

    for (MPLine *line in stopArea.lines) {
        if (![lineTypes containsObject:line.transport_type]) {
            [lineTypes addObject:line.transport_type];
        }
    }
    NSMutableString *iconName = [NSMutableString stringWithString:@"icon-"];
    for (NSString *transport_type in [lineTypes sortedArrayUsingSelector:@selector(compare:)]) {
        [iconName appendFormat:@"%@+",[[transport_type substringToIndex:1] uppercaseString]];
    }
    
    UIImageView *coloredView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0*lineTypes.count, 20.0*lineTypes.count)];
    coloredView.contentMode = UIViewContentModeScaleAspectFit;
    coloredView.image = [UIImage imageNamed:[iconName substringWithRange:NSMakeRange(0, iconName.length-1)]];
    
    //create the SKAnnotationView
    SKAnnotationView *view = [[SKAnnotationView alloc] initWithView:coloredView reuseIdentifier:[NSString stringWithFormat:@"stopAreaAnnotation-%@", stopArea.id_stop_area]];
    
    //create the annotation
    SKAnnotation *viewAnnotation = [SKAnnotation annotation];
    //set the custom view
    viewAnnotation.annotationView = view;
    viewAnnotation.identifier = [stopArea.id_stop_area intValue];
    viewAnnotation.location = CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue]);
    SKAnimationSettings *animationSettings = [SKAnimationSettings animationSettings];
    [self.mapView addAnnotation:viewAnnotation withAnimationSettings:animationSettings];
    
}

- (void)setDestinationWithSearchResult:(SKSearchResult*)searchResult {
    if (searchResult != nil) {
        self.searchResult = searchResult;
        self.stopArea = nil;
        
        [self.mapView hideCallout];
        
        NSMutableString *mutableString = [NSMutableString stringWithString:searchResult.name];
        for (SKSearchResultParent *parent in searchResult.parentSearchResults) {
            if (parent.type < SKSearchResultStreet) {
                [mutableString appendString:[NSString stringWithFormat:@", %@", parent.name]];
            }
        }
        
        [self setTexteInfoView:mutableString image:[UIImage imageNamed:@"icon-pin"]];
        
        [self centerOnCoordinate:searchResult.coordinate];
        [self addAnnotationDestination:searchResult.coordinate];
        
        [self showInfoView:YES];
    }
    
}

- (void)setDestinationWithStopArea:(MPStopArea*)stopArea {
    if (stopArea != nil) {
        self.searchResult = nil;
        self.stopArea = stopArea;
        
        [self.mapView hideCallout];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue]);
        [self centerOnCoordinate:coordinate];
        [self addAnnotationDestination:coordinate];
        
        NSMutableString *text = [NSMutableString stringWithFormat:@"%@\n%@\nLigne", [stopArea name], [(MPLine*)[stopArea.lines.allObjects firstObject] transport_type]];
        for (MPLine *line in stopArea.lines) {
            [text appendFormat:@" %@,",line.code];
        }
        [text deleteCharactersInRange:NSMakeRange([text length]-1, 1)];
        
        if ([[[(MPLine*)[stopArea.lines.allObjects firstObject] transport_type] lowercaseString] isEqualToString:@"metro"]) {
            [self setTexteInfoView:text image:[UIImage imageNamed:@"icon-metro"]];
        } else {
            [self setTexteInfoView:text image:[UIImage imageNamed:@"icon-pin"]];
        }
        
        [self showInfoView:YES];
    }
}

- (void)addAnnotationDestination:(CLLocationCoordinate2D)coordinate {
    UIImageView *coloredView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 69.0)];
    coloredView.image = [UIImage imageNamed:@"pin-myLocation"];
    
    //create the SKAnnotationView
    SKAnnotationView *view = [[SKAnnotationView alloc] initWithView:coloredView reuseIdentifier:@"viewID"];
    
    //create the annotation
    SKAnnotation *viewAnnotation = [SKAnnotation annotation];
    //set the custom view
    viewAnnotation.annotationView = view;
    viewAnnotation.identifier = ANNOTATION_IDENTIFIER_USER_LOCATION;
    viewAnnotation.location = coordinate;
    viewAnnotation.offset = CGPointMake(0, 35.0);
    SKAnimationSettings *animationSettings = [SKAnimationSettings animationSettings];
    [self.mapView addAnnotation:viewAnnotation withAnimationSettings:animationSettings];
}

- (void)mapView:(SKMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    SKSearchResult *searchObject =  [[SKReverseGeocoderService sharedInstance] reverseGeocodeLocation: coordinate];
    [self setDestinationWithSearchResult:searchObject];
}

- (void)mapView:(SKMapView *)mapView didLongTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    SKSearchResult *searchObject =  [[SKReverseGeocoderService sharedInstance] reverseGeocodeLocation: coordinate];
    [self setDestinationWithSearchResult:searchObject];
}

-(void)mapView:(SKMapView *)mapView didSelectAnnotation:(SKAnnotation *)annotation{
    if (annotation.identifier != ANNOTATION_IDENTIFIER_USER_LOCATION) {
        MPStopArea *stopArea = [MPStopArea findById:[NSNumber numberWithInt:annotation.identifier]];
        if (stopArea != nil) {
            mapView.calloutView.titleLabel.text = stopArea.name;
            mapView.calloutView.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:12.0];
            mapView.calloutView.subtitleLabel.text = @"";
            [mapView showCalloutForAnnotation:annotation withOffset:CGPointMake(0, 10) animated:YES];
            
            if ([[[(MPLine*)[stopArea.lines.allObjects firstObject] transport_type] lowercaseString] isEqualToString:@"metro"]) {
                [self setTexteInfoView:stopArea.name image:[UIImage imageNamed:@"icon-metro"]];
            } else {
                [self setTexteInfoView:stopArea.name image:[UIImage imageNamed:@"icon-pin"]];
            }
        }
    }
}

#pragma mark - SKSearchServiceDelegate

- (void)searchService:(SKSearchService *)searchService didRetrieveMultiStepSearchResults:(NSArray *)searchResults {
    if ([searchResults count] != 0 && listLevel < SKHouseNumberList )  {
        if(listLevel == SKStreetList ){  // only US has states
            //listLevel = SKCityList;
            //SKSearchResult *searchResult = searchResults[0];
            [self.searchResultsSkobbler removeAllObjects];
            [self.searchResultsSkobbler addObjectsFromArray:searchResults];
            [self.tableView reloadData];
            [self showTableView:YES];
            
        } else{
            listLevel++;
            SKSearchResult *searchResult = searchResults[0]; // the first result will be used for next level search
            
            self.multiStepSearchObject = [SKMultiStepSearchSettings multiStepSearchSettings];
            self.multiStepSearchObject.listLevel = listLevel++;
            self.multiStepSearchObject.offlinePackageCode = searchResult.offlinePackageCode; // the package in which map   data is stored
            self.multiStepSearchObject.searchTerm = @"";
            self.multiStepSearchObject.parentIndex = searchResult.identifier; // used for searching children of the selected result
            [[SKSearchService sharedInstance]startMultiStepSearchWithSettings:self.multiStepSearchObject];
        }
    }
}

- (void)searchServiceDidFailToRetrieveMultiStepSearchResults:(SKSearchService *)searchService {
    NSLog(@"Search failed");
    [self alertViewDownloadMap];
}


#pragma mark - ViewController Method

- (IBAction)tapOnGoButton:(id)sender {
    
    if (self.searchResult != nil || self.stopArea != nil) {
        if ([MPGlobalItineraryManager sharedManager].addressToReplace == MPAddressToReplaceNull) {
            SKSearchResult *searchObject =  [[SKReverseGeocoderService sharedInstance] reverseGeocodeLocation:[[SKPositionerService sharedInstance] currentCoordinate]];
            MPAddress *address = [[MPAddress alloc] initWithSKSearchResult:searchObject];
            [address setName:[[MPLanguageManager sharedManager] getStringWithKey:@"searchBar.yourPosition"]];
            [[MPGlobalItineraryManager sharedManager] setAddress:address];
        }
        MPAddress *address = [[MPAddress alloc] init];
        
        if (self.searchResult != nil) {
            address = [[MPAddress alloc] initWithSKSearchResult:self.searchResult];
        } else if (self.stopArea != nil) {
            address.stopArea = self.stopArea;
        }
        
        [[MPGlobalItineraryManager sharedManager] setAddress:address];
        MPRevealController *revealController = [MPRevealController sharedInstance];
        
        [(UINavigationController*)revealController.frontViewController pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass ([MPItineraryViewController class])] animated:YES];
    }
}

- (IBAction)tapOnMyLocationButton:(id)sender {
    SKSearchResult *searchObject =  [[SKReverseGeocoderService sharedInstance] reverseGeocodeLocation:[[SKPositionerService sharedInstance] currentCoordinate]];
    if (searchObject == nil) {
        [self alertViewDownloadMap];
    }
    [self setDestinationWithSearchResult:searchObject];
}

- (void)showInfoView:(BOOL)show {
    self.infoViewHeightConstraint.constant = show ? INFOVIEW_HEIGHT : 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)setTexteInfoView:(NSString*)text image:(UIImage*)image {
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:[text uppercaseString]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:0.2];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [text length])];
    self.labelInfoView.attributedText = attrString;
    
    self.imageInfoView.image = image;
}

- (void)showTableView:(BOOL)show {
    self.searchBar.showsCancelButton = show;
    
    if (show) {
        [self.tableView setHidden:NO];
        // CGFloat constraint = self.view.frame.size.height-self.searchResultsSkobbler.count*CELL_HEIGHT;
        // self.tableViewBottomConstraint.constant = constraint > self.view.frame.size.height ? 0 : constraint;
    } else {
        [self.tableView setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertViewDownloadMap {
    [[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Merci de télécharger une carte dans le menu onglet \"Télécharger\" pour activer les fonctionnalités" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end

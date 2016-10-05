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

#define CELL_HEIGHT 45
#define INFOVIEW_HEIGHT 80
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

@property(nonatomic, strong) SKMultiStepSearchSettings *multiStepSearchObject;
@property(nonatomic, strong) NSArray *stopAreas;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Plan";
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
    self.searchBar.showsCancelButton = YES;
    
    [self showTableView:NO];
    
    self.mapView.delegate = self;
    self.mapView.mapScaleView.hidden = YES;
    
    [self showInfoView:NO];
    
    [SKSearchService sharedInstance].searchServiceDelegate = self;
    [SKSearchService sharedInstance].searchResultsNumber = 7;
    [SKMapsService sharedInstance].connectivityMode = SKConnectivityModeOffline;
    
    self.stopAreas = [MPStopArea findAll];
    
    self.infoView.backgroundColor = [Constantes blueBackGround];
    self.labelInfoView.font = [UIFont fontWithName:FONT_MEDIUM size:13.0f];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        MPStopArea *stopArea = [self.searchResultsStopArea objectAtIndex:indexPath.row];
        cell.textLabel.text = [stopArea name];
        
    } else {
        SKSearchResult *searchResult = [self.searchResultsSkobbler objectAtIndex:indexPath.row];
        NSMutableString *labelCell = [NSMutableString stringWithString:searchResult.name];
        for (SKSearchResultParent *parent in searchResult.parentSearchResults) {
            if (parent.type < SKSearchResultStreet) {
                [labelCell appendString:[NSString stringWithFormat:@", %@", parent.name]];
            }
        }
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

- (void)showTableView:(BOOL)show {
    if (show) {
        [self.tableView setHidden:NO];
        CGFloat constraint = self.view.frame.size.height-self.searchResultsSkobbler.count*CELL_HEIGHT;
        self.tableViewBottomConstraint.constant = constraint > self.view.frame.size.height ? 0 : constraint;
    } else {
        [self.tableView setHidden:YES];
    }
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
        self.multiStepSearchObject.offlinePackageCode = @"FRCITY02"; // Paris package has to be downloaded
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
    UIImageView *coloredView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];
    coloredView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ligne%@",[(MPLine*)[stopArea.lines.allObjects firstObject] code]]];
    
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

- (void)setDestination:(CLLocationCoordinate2D)coordinate {
    [self.mapView hideCallout];
    
    SKSearchResult *searchObject =  [[SKReverseGeocoderService sharedInstance] reverseGeocodeLocation: coordinate];
    self.labelInfoView.text = searchObject.name;
    [self centerOnCoordinate:searchObject.coordinate];
    [self addAnnotationDestination:searchObject.coordinate];
    [self showInfoView:YES];
}

- (void)setDestinationWithSearchResult:(SKSearchResult*)searchResult {
    [self.mapView hideCallout];
    
    NSMutableString *labelCell = [NSMutableString stringWithString:searchResult.name];
    for (SKSearchResultParent *parent in searchResult.parentSearchResults) {
        if (parent.type < SKSearchResultStreet) {
            [labelCell appendString:[NSString stringWithFormat:@", %@", parent.name]];
        }
    }
    self.labelInfoView.text = labelCell;
    
    [self centerOnCoordinate:searchResult.coordinate];
    [self addAnnotationDestination:searchResult.coordinate];
    
    [self showInfoView:YES];
    
}

- (void)setDestinationWithStopArea:(MPStopArea*)stopArea {
    [self.mapView hideCallout];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([stopArea.latitude floatValue], [stopArea.longitude floatValue]);
    [self centerOnCoordinate:coordinate];
    [self addAnnotationDestination:coordinate];
    
    NSMutableString *text = [NSMutableString stringWithFormat:@"%@\n%@\nLigne", [stopArea name], [(MPLine*)[stopArea.lines.allObjects firstObject] transport_type]];
    for (MPLine *line in stopArea.lines) {
        [text appendFormat:@" %@,",line.code];
    }
    [text deleteCharactersInRange:NSMakeRange([text length]-1, 1)];

    self.labelInfoView.text = text;
    if ([[[(MPLine*)[stopArea.lines.allObjects firstObject] transport_type] lowercaseString] isEqualToString:@"metro"]) {
        self.imageInfoView.image = [UIImage imageNamed:@"icon-metro"];
    } else {
        self.imageInfoView.image = nil;
    }
    
    [self showInfoView:YES];
}

- (void)showInfoView:(BOOL)show {
    self.infoViewHeightConstraint.constant = show ? INFOVIEW_HEIGHT : 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(SKMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self setDestination:coordinate];
}

- (void)mapView:(SKMapView *)mapView didDoubleTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self setDestination:coordinate];
}

-(void)mapView:(SKMapView *)mapView didSelectAnnotation:(SKAnnotation *)annotation{
    if (annotation.identifier != ANNOTATION_IDENTIFIER_USER_LOCATION) {
        MPStopArea *stopArea = [MPStopArea findById:[NSNumber numberWithInt:annotation.identifier]];
        if (stopArea != nil) {
            mapView.calloutView.titleLabel.text = stopArea.name;
            mapView.calloutView.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:12.0];
            mapView.calloutView.subtitleLabel.text = @"";
            [mapView showCalloutForAnnotation:annotation withOffset:CGPointMake(0, 10) animated:YES];
            
            self.labelInfoView.text = stopArea.name;
        }
    }
}
- (IBAction)tapOnMyLocationButton:(id)sender {
    [self setDestination:[[SKPositionerService sharedInstance] currentCoordinate]];
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
    [[[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Merci de télécharger une carte dans le menu onglet \"Télécharger\"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}



@end

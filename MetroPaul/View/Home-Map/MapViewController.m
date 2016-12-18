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
#import "MPLine.h"
#import "MPStopArea.h"
#import "MPSearchResultDestinationCell.h"
#import "MPItineraryViewController.h"
#import "MPGlobalItineraryManager.h"
#import "SKSearchResult+MPString.h"
#import <MessageUI/MessageUI.h>
#import "MPHistory.h"
#import "MPGlobalItineraryManager.h"

#define CELL_HEIGHT 50
#define INFOVIEW_HEIGHT 70
#define ANNOTATION_IDENTIFIER_USER_LOCATION 0
#define RESULT_LIMIT 7

static SKListLevel listLevel;
static SKListLevel listLevelLimit;


@interface MapViewController () <SKMapViewDelegate, SKSearchServiceDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MPSearchResultDestinationCellDelegate, MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@property (strong, nonatomic) IBOutlet SKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imageInfoView;
@property (weak, nonatomic) IBOutlet UILabel *labelInfoView;
@property (weak, nonatomic) IBOutlet UIButton *buttonInfoView;

@property(nonatomic, strong) NSArray *stopAreas;



@property(nonatomic, strong) NSArray *downloadPackage;
@property(nonatomic, strong) SKSearchResult *searchResultSelected;
@property(nonatomic, strong) MPStopArea *stopAreaSelected;
@property(nonatomic, strong) MPHistory *historySelected;

@property(nonatomic, strong) SKMultiStepSearchSettings *multiStepSearchObject;
@property(nonatomic, strong) NSMutableArray *searchResultsSkobbler;
@property(nonatomic, strong) NSMutableArray *searchResultsStopArea;
@property(nonatomic, strong) NSMutableArray *searchResultsHistory;
@property(nonatomic, strong) NSString *houseNumber;
@property(nonatomic, strong) NSArray *searchStreetResults;



@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedPosition:) name:@"SchemePosition" object:nil];
    
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
    self.searchResultsHistory = [NSMutableArray array];
    self.searchStreetResults = [NSArray array];
    
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = NO;
    //    self.searchBar.placeholder = @"Saisir une destination";
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
            [imgView setWidth:30.0];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image = [[UIImage imageNamed:@"icon-search"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            imgView.tintColor = [UIColor whiteColor];
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.textAlignment = NSTextAlignmentLeft;
            
            UIButton *btnClear = (UIButton*)[textField valueForKey:@"clearButton"];
            [btnClear setImage:[[UIImage imageNamed:@"icon-cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal|UIControlStateSelected|UIControlStateHighlighted];
            
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
    
    [((MPNavigationController*)self.navigationController) prepareNavigationTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.plan"]];
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    if (CLLocationCoordinate2DIsValid(appDelegate.coordinateReceived)) {
        SKSearchResult *searchObject =  [[SKReverseGeocoderService sharedInstance] reverseGeocodeLocation: appDelegate.coordinateReceived];
        [self setDestinationWithSearchResult:searchObject];
        appDelegate.coordinateReceived = kCLLocationCoordinate2DInvalid;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [((MPNavigationController*)self.navigationController) prepareNavigationTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"menu.plan"]];
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"icon-menu"]
                                             style:UIBarButtonItemStylePlain
                                             target:[MPRevealController sharedInstance]
                                             action:@selector(showLeftController)];
    
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    self.navigationController.navigationBar.translucent = NO;
    
    NSArray *searchBarSubViews = [[self.searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *view in searchBarSubViews) {
        if([view isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField*)view;
            NSString *textFieldAttributed = @"";
            MPAddress *address = nil;
            switch ([[MPGlobalItineraryManager sharedManager] addressToReplace]) {
                case MPAddressToReplaceStart: {
                    address = [[MPGlobalItineraryManager sharedManager] startAddress];
                    textFieldAttributed = @"Saisir un point de départ                                           ";
                    break;
                }
                case MPAddressToReplaceDestination: {
                    address = [[MPGlobalItineraryManager sharedManager] destinationAddress];
                    textFieldAttributed = @"Saisir une destination                                              ";
                    break;
                }
                case MPAddressToReplaceNull: {
                    textFieldAttributed = @"Saisir une destination                                              ";
                    [self centerOnCoordinate:[[SKPositionerService sharedInstance] currentCoordinate]];
                    break;
                }
                default:{
                    textFieldAttributed = @"Saisir une destination                                              ";
                    [self centerOnCoordinate:[[SKPositionerService sharedInstance] currentCoordinate]];
                    break;
                }
            }
            
            if (address != nil) {
                if ([address stopArea] != nil) {
                    [self setDestinationWithStopArea:address.stopArea];
                } else if ([address searchResult] != nil) {
                    [self setDestinationWithSearchResult:address.searchResult];
                } else if ([address history] != nil) {
                    [self setDestinationWithHistory:address.history];
                }
            }
            
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textFieldAttributed
                                                                              attributes:@{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.4]}];
        }
    }
    
    [self.searchBar reloadInputViews];
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
    if ([[MPGlobalItineraryManager sharedManager] addressToReplace] != MPAddressToReplaceStart && [[MPGlobalItineraryManager sharedManager] addressToReplace] != MPAddressToReplaceDestination)
        [self centerOnCoordinate:[[SKPositionerService sharedInstance] currentCoordinate]];
    
    for (MPStopArea *stopArea in self.stopAreas) {
        [self addAnnotationWithStopArea:stopArea];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self.searchBar.text isEqual: @""]) {
        if (self.searchResultsHistory.count + self.searchResultsStopArea.count + self.searchResultsSkobbler.count > RESULT_LIMIT) {
            NSInteger i = 0;
            NSInteger j = 0;
            NSInteger k = 0;
            
            while (i + j + k < RESULT_LIMIT) {
                if (i < self.searchResultsStopArea.count && i + j + k < RESULT_LIMIT) {
                    i++;
                }
                if (j < self.searchResultsSkobbler.count && i + j + k < RESULT_LIMIT) {
                    j++;
                }
                if (k < self.searchResultsHistory.count && i + j + k < RESULT_LIMIT) {
                    k++;
                }
            }
            switch (section) {
                case 0:
                    return k;
                    break;
                case 1:
                    return i;
                    break;
                case 2:
                    return j;
                    break;
                    
                default:
                    break;
            }
        } else {
            switch (section) {
                case 0:
                    return self.searchResultsHistory.count;
                    break;
                case 1:
                    return self.searchResultsStopArea.count;
                    break;
                case 2:
                    return self.searchResultsSkobbler.count;
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPSearchResultDestinationCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"MPSearchResultDestinationCell"];
    if (cell == nil) {
        cell = [[MPSearchResultDestinationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MPSearchResultDestinationCell"];
    }
    cell.delegate = self;
    
    
    switch (indexPath.section) {
        case 0: {
            [cell setHistory:[self.searchResultsHistory objectAtIndex:indexPath.row]];
            break;
        }
        case 1: {
            [cell setStopArea:[self.searchResultsStopArea objectAtIndex:indexPath.row]];
            break;
        }
        case 2:{
            [cell setSearchResult:[self.searchResultsSkobbler objectAtIndex:indexPath.row]];
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            MPHistory *history = [self.searchResultsHistory objectAtIndex:indexPath.row];
            [self setDestinationWithHistory:history];
            break;
        }
        case 1: {
            MPStopArea *stopArea = [self.searchResultsStopArea objectAtIndex:indexPath.row];
            [self setDestinationWithStopArea:stopArea];
            break;
        }
        case 2: {
            SKSearchResult *searchResult = [self.searchResultsSkobbler objectAtIndex:indexPath.row];
            [self setDestinationWithSearchResult:searchResult];
            break;
        }
        default:
            break;
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
    
    if (![searchText isEqualToString: @""] && searchText.length > 2) {
        NSScanner *scanner = [NSScanner scannerWithString:[[searchText componentsSeparatedByString:@" "] firstObject]];
        BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
        if (isNumeric) {
            self.houseNumber = [[searchText componentsSeparatedByString:@" "] firstObject];
            searchText = [searchText substringFromIndex:self.houseNumber.length+1];
            listLevelLimit = SKHouseNumberList;
        } else {
            self.houseNumber = nil;
            listLevelLimit = SKStreetList;
        }
        listLevel = SKStreetList;
        
        self.multiStepSearchObject = [SKMultiStepSearchSettings multiStepSearchSettings];
        self.multiStepSearchObject.listLevel = listLevel;
        self.multiStepSearchObject.offlinePackageCode = [(SKMapPackage*)[self.downloadPackage firstObject] name]; // Paris package has to be downloaded
        self.multiStepSearchObject.searchTerm = searchText;
        self.multiStepSearchObject.parentIndex = -1;
        [[SKSearchService sharedInstance] startMultiStepSearchWithSettings:self.multiStepSearchObject];
        
        NSArray *stopArea = [MPStopArea findByName:searchText];
        [self.searchResultsStopArea removeAllObjects];
        [self.searchResultsStopArea addObjectsFromArray:stopArea];
        
        // History
        NSDictionary *dict = [[MPHistoryManager sharedManager] getHistory];
        [self.searchResultsHistory removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText];
        NSArray *selectedKeys = [[dict allKeys] filteredArrayUsingPredicate:predicate];
        for (NSString *key in selectedKeys) {
            MPHistory *history = [NSKeyedUnarchiver unarchiveObjectWithData:[dict objectForKey:key]];
            [self.searchResultsHistory addObject:history];
        }
    } else {
        [self.searchResultsHistory removeAllObjects];
        [self.searchResultsStopArea removeAllObjects];
        [self.searchResultsSkobbler removeAllObjects];
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
    [self.mapView animateToZoomLevel:15];
    [self.mapView animateToBearing:0.0];
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
    
    CGFloat size = 0.0;
    switch (lineTypes.count) {
        case 1:
            size = 20.0;
            break;
        case 2:
            size = 40.0;
            break;
        case 3:
            size = 40.0;
            break;
        default:
            break;
    }
    
    UIImageView *coloredView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, size, size)];
    coloredView.contentMode = UIViewContentModeScaleAspectFit;
    coloredView.image = [UIImage imageNamed:[iconName substringWithRange:NSMakeRange(0, iconName.length-1)]];
    
    //create the SKAnnotationView
    SKAnnotationView *view = [[SKAnnotationView alloc] initWithView:coloredView reuseIdentifier:[NSString stringWithFormat:@"stopAreaAnnotation-%@", stopArea.id_stop_area]];
    
    //create the annotation
    SKAnnotation *viewAnnotation = [SKAnnotation annotation];
    //set the custom view
    viewAnnotation.annotationView = view;
    viewAnnotation.minZoomLevel = 14;
    viewAnnotation.identifier = [stopArea.id_stop_area intValue];
    viewAnnotation.location = CLLocationCoordinate2DMake([stopArea.latitude doubleValue], [stopArea.longitude doubleValue]);
    SKAnimationSettings *animationSettings = [SKAnimationSettings animationSettings];
    [self.mapView addAnnotation:viewAnnotation withAnimationSettings:animationSettings];
    
}

- (void)setDestinationWithSearchResult:(SKSearchResult*)searchResult {
    if (searchResult != nil) {
        self.searchResultSelected = searchResult;
        self.stopAreaSelected = nil;
        self.historySelected = nil;
        
        //        [self.mapView hideCallout];
        
        
        [self setTexteInfoView:[searchResult toString] image:[UIImage imageNamed:@"icon-pin"]];
        
        [self centerOnCoordinate:searchResult.coordinate];
        [self addAnnotationDestination:searchResult.coordinate];
        
        [self showInfoView:YES];
    }
    
}

- (void)setDestinationWithStopArea:(MPStopArea*)stopArea {
    if (stopArea != nil) {
        self.searchResultSelected = nil;
        self.stopAreaSelected = stopArea;
        self.historySelected = nil;
        
        //        [self.mapView hideCallout];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([stopArea.latitude doubleValue], [stopArea.longitude doubleValue]);
        [self centerOnCoordinate:coordinate];
        [self addAnnotationDestination:coordinate];
        
        NSMutableString *text = [NSMutableString stringWithFormat:[[MPLanguageManager sharedManager] getStringWithKey:@"home.ligne_nb"], [stopArea name], [(MPLine*)[stopArea.lines.allObjects firstObject] transport_type]];
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

- (void)setDestinationWithHistory:(MPHistory*)history {
    if (history != nil) {
        self.searchResultSelected = nil;
        self.stopAreaSelected = nil;
        self.historySelected = history;
        
        //        [self.mapView hideCallout];
        
        [self centerOnCoordinate:history.coordinate];
        [self addAnnotationDestination:history.coordinate];
        
        if (history.typeStopArea) {
            [self setTexteInfoView:[NSString stringWithFormat:@"%@\n%@", history.name, history.subTitle] image:[UIImage imageNamed:@"icon-metro"]];
        } else {
            [self setTexteInfoView:history.name image:[UIImage imageNamed:@"icon-pin"]];
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
        [self setDestinationWithStopArea:[MPStopArea findById:[NSNumber numberWithInt:annotation.identifier]]];
        
        //        if (stopArea != nil) {
        //            mapView.calloutView.titleLabel.text = stopArea.name;
        //            mapView.calloutView.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:12.0];
        //            mapView.calloutView.subtitleLabel.text = @"";
        //            [mapView showCalloutForAnnotation:annotation withOffset:CGPointMake(0, 10) animated:YES];
        //
        //            if ([[[(MPLine*)[stopArea.lines.allObjects firstObject] transport_type] lowercaseString] isEqualToString:@"metro"]) {
        //                [self setTexteInfoView:stopArea.name image:[UIImage imageNamed:@"icon-metro"]];
        //            } else {
        //                [self setTexteInfoView:stopArea.name image:[UIImage imageNamed:@"icon-pin"]];
        //            }
        //        }
    }
}

#pragma mark - SKSearchServiceDelegate

- (void)searchService:(SKSearchService *)searchService didRetrieveMultiStepSearchResults:(NSArray *)searchResults {
    // Si on a atteint le fond de la recherche
    if(listLevel == listLevelLimit ){
        if (listLevel == SKHouseNumberList) {
            // Si différent de 0, on ajoute le numero de maison, sinon la rue
            if ([searchResults count] != 0)  {
                SKSearchResult *houseResult = searchResults[0];
                [houseResult setParentSearchResults:[NSMutableArray arrayWithObject:self.searchStreetResults[self.searchResultsSkobbler.count]]];
                [self.searchResultsSkobbler addObject:houseResult];
            } else {
                [self.searchResultsSkobbler addObject:self.searchStreetResults[self.searchResultsSkobbler.count]];
            }
            
            // Si on est arrivé à la fin de la liste des rues
            if (self.searchResultsSkobbler.count == self.searchStreetResults.count) {
                [self.tableView reloadData];
                [self showTableView:YES];
            } else {
                [self completeStreetWithHouseNumber];
            }
            
        } else {
            [self.searchResultsSkobbler removeAllObjects];
            [self.searchResultsSkobbler addObjectsFromArray:searchResults];
            [self.tableView reloadData];
            [self showTableView:YES];
        }
    } else if(listLevel == SKStreetList ){
        if ([searchResults count] != 0)  {
            [self.searchResultsSkobbler removeAllObjects];
            listLevel++;
            self.searchStreetResults = searchResults;
            [self completeStreetWithHouseNumber];
        }
    }
}

- (void)completeStreetWithHouseNumber {
    if (self.searchResultsSkobbler.count < self.searchStreetResults.count) {
        SKSearchResult *searchResult = self.searchStreetResults[self.searchResultsSkobbler.count]; // the result will be used for next level search
        
        self.multiStepSearchObject = [SKMultiStepSearchSettings multiStepSearchSettings];
        self.multiStepSearchObject.listLevel = SKHouseNumberList;
        self.multiStepSearchObject.offlinePackageCode = searchResult.offlinePackageCode; // the package in which map   data is stored
        self.multiStepSearchObject.searchTerm = self.houseNumber;
        self.multiStepSearchObject.parentIndex = searchResult.identifier; // used for searching children of the selected result
        [[SKSearchService sharedInstance]startMultiStepSearchWithSettings:self.multiStepSearchObject];
    }
}

- (void)searchServiceDidFailToRetrieveMultiStepSearchResults:(SKSearchService *)searchService {
    NSLog(@"Search failed");
    [self alertViewDownloadMap];
}

#pragma mark - MPSearchResultDestinationCellDelegate

- (void)searchResultDestinationCellTapOnStopArea:(MPStopArea *)stopArea {
    self.stopAreaSelected = stopArea;
    self.searchResultSelected = nil;
    self.historySelected = nil;
    [self tapOnGoButton:nil];
}

- (void)searchResultDestinationCellTapOnSearchResult:(SKSearchResult *)searchResult {
    self.stopAreaSelected = nil;
    self.searchResultSelected = searchResult;
    self.historySelected = nil;
    [self tapOnGoButton:nil];
}

- (void)searchResultDestinationCellTapOnHistory:(MPHistory *)history {
    self.stopAreaSelected = nil;
    self.searchResultSelected = nil;
    self.historySelected = history;
    [self tapOnGoButton:nil];
}


#pragma mark - ViewController Method

- (IBAction)tapOnGoButton:(id)sender {
    
    if (self.searchResultSelected != nil || self.stopAreaSelected != nil || self.historySelected) {
        if ([MPGlobalItineraryManager sharedManager].addressToReplace == MPAddressToReplaceNull) {
            [[MPGlobalItineraryManager sharedManager] reset];
            SKSearchResult *searchObject =  [[SKReverseGeocoderService sharedInstance] reverseGeocodeLocation:[[SKPositionerService sharedInstance] currentCoordinate]];
            MPAddress *address = [[MPAddress alloc] initWithSKSearchResult:searchObject];
            [address setName:[[MPLanguageManager sharedManager] getStringWithKey:@"searchBar.yourPosition"]];
            [[MPGlobalItineraryManager sharedManager] setAddress:address];
        }
        MPAddress *address = [[MPAddress alloc] init];
        
        if (self.searchResultSelected != nil) {
            address = [[MPAddress alloc] initWithSKSearchResult:self.searchResultSelected];
            [[MPHistoryManager sharedManager] saveSearchResult:self.searchResultSelected];
        } else if (self.stopAreaSelected != nil) {
            address.stopArea = self.stopAreaSelected;
            [[MPHistoryManager sharedManager] saveStopArea:self.stopAreaSelected];
        } else if(self.historySelected != nil) {
            address = [[MPAddress alloc] initWithHistory:self.historySelected];
        }
        
        [[MPGlobalItineraryManager sharedManager] setAddress:address];
        MPRevealController *revealController = [MPRevealController sharedInstance];
        
        self.searchBar.text = @"";
        
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
    [[[UIAlertView alloc] initWithTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"alert.title.error"]
                                message:[[MPLanguageManager sharedManager] getStringWithKey:@"home.alert.download_map"]
                               delegate:self
                      cancelButtonTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"alert.title.ok"]
                      otherButtonTitles:nil] show];
}

- (IBAction)tapOnInfoBarSms {
    CLLocationCoordinate2D coordinate;
    if (_searchResultSelected != nil) {
        coordinate = _searchResultSelected.coordinate;
    } else if(_stopAreaSelected != nil) {
        coordinate = CLLocationCoordinate2DMake([_stopAreaSelected.latitude doubleValue], [_stopAreaSelected.longitude doubleValue]);
    } else if(_historySelected != nil) {
        coordinate = _historySelected.coordinate;
    }
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"alert.title.error"]
                                                               message:[[MPLanguageManager sharedManager] getStringWithKey:@"alert.message.sms"]
                                                              delegate:nil
                                                     cancelButtonTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"alert.title.ok"]
                                                     otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = [NSArray array];
    NSString *message = [NSString stringWithFormat:@"metropaul://map/position?lat=%f&long=%f", coordinate.latitude, coordinate.longitude];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)receivedPosition:(NSNotification*)notification {
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    if (CLLocationCoordinate2DIsValid(appDelegate.coordinateReceived)) {
        SKSearchResult *searchObject =  [[SKReverseGeocoderService sharedInstance] reverseGeocodeLocation: appDelegate.coordinateReceived];
        [self setDestinationWithSearchResult:searchObject];
        appDelegate.coordinateReceived = kCLLocationCoordinate2DInvalid;
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"alert.title.error"]
                                                                   message:[[MPLanguageManager sharedManager] getStringWithKey:@"alert.message.sms.failed"]
                                                                  delegate:nil
                                                         cancelButtonTitle:[[MPLanguageManager sharedManager] getStringWithKey:@"alert.title.ok"]
                                                         otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

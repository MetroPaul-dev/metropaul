//
//  PedestrianNavigationViewController.m
//  FrameworkIOSDemo
//
//  Copyright (c) 2016 Skobbler. All rights reserved.
//

#import "PedestrianNavigationViewController.h"
#import "AudioService.h"
#import "MenuView.h"
#import "SKTNavigationUtils.h"
#import "SettingsViewController.h"

#import <UIView+Additions.h>
#import <UIDevice+Additions.h>
#import <SKMaps/SKMapView.h>
#import <SKMaps/SKMapScaleView.h>
#import <SKMaps/SKAnnotation.h>
#import <SKMaps/SKPositionerService.h>
#import <SKMaps/SKRoutingService.h>
#import <SKMaps/SKAnimationSettings.h>
#import <SKMaps/SKViaPoint.h>
#import <SDKTools/Navigation/SKTNavigationManager+Styles.h>
#import <SDKTools/Navigation/SKTNavigationManager.h>
#import <SDKTools/Navigation/SKTNavigationUtils.h>
#import <SDKTools/Navigation/SKTNavigationManager+Settings.h>
#import <SKTNavigationCalculatingRouteView.h>

#define kSizeMultiplier (([UIDevice isiPad] ? 2.0 : 1.0))

const int kStartAnnotationIdentifier = 0;
const int kEndAnnotationIdentifier = 1;
const int kViapointAnnotationIdentifier = 2;

@interface PedestrianNavigationViewController () <SKMapViewDelegate, SKRoutingDelegate, SKNavigationDelegate, SKTNavigationManagerDelegate, SKTNavigationViewDelegate, SKTNavigationFreeDriveViewDelegate>

@property (nonatomic, strong) SKMapView                     *mapView;

@property (nonatomic, strong) SKTNavigationManager          *navigationManager;
@property (nonatomic, strong) SKTNavigationConfiguration    *configuration;

@property(nonatomic, weak) id<SKTNavigationCalculatingRouteViewDelegate> delegate;

@end

@interface PedestrianNavigationViewController (UICreation)

- (void)addMapView;

@end

@implementation PedestrianNavigationViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.start = kCLLocationCoordinate2DInvalid;
        self.destination = kCLLocationCoordinate2DInvalid;
    }
    return self;
}

#pragma mark - Overriden

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addMapView];
    [self configureNavigation];
    [self configureNavigationManager];
    [self configureRoutingService];
    [self updateAnnotations];
    
    [self registerToNotifications];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self calculateRoute];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [self.navigationManager stopNavigation];
    
    [self unregisterFromNotifications];
}

#pragma mark - Actions

- (void)calculateRoute {
    self.navigationManager.mainView.hidden = NO;
    
    [self.navigationManager  startNavigationWithConfiguration:self.configuration];
    [self removeAnnotations];
}

- (void)cancelButtonClicked {
    [self.navigationManager stopNavigation];
    [self cancelNavigation];
}

#pragma mark - Private methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context  {
}

- (void)registerToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routingServiceDidFinishRouteCalculation) name:@"routingServiceDidFinishRouteCalculation" object:nil];
    
    [self.navigationManager addObserver:self forKeyPath:@"prefferedFollowerMode" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)unregisterFromNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationManager removeObserver:self forKeyPath:@"prefferedFollowerMode"];
}

- (void)cancelNavigation {
    self.navigationManager.mainView.hidden = YES;
    [self updateAnnotations];
    
    [[SKPositionerService sharedInstance] stopPositionReplay];
}

- (void)didEnterBackground {
    if (!self.navigationManager.navigationStarted) {
        [[SKPositionerService sharedInstance] cancelLocationUpdate];
    }
}

- (void)didEnterForeground {
    [[SKPositionerService sharedInstance] startLocationUpdate];
}

- (void)configureRoutingService {
    [SKRoutingService sharedInstance].mapView = self.mapView;
    [SKRoutingService sharedInstance].routingDelegate = self;
    [SKRoutingService sharedInstance].navigationDelegate = self;
}

- (void)configureNavigation {
    self.configuration = [SKTNavigationConfiguration defaultConfiguration];
    self.configuration.navigationType = SKNavigationTypeSimulation;
    self.configuration.routeType = self.routeMode;
    self.configuration.numberOfRoutes = 1;
    self.configuration.startCoordinate = self.start;
    self.configuration.destination = self.destination;
}

- (void)configureNavigationManager {
    self.navigationManager = [[SKTNavigationManager alloc] initWithMapView:self.mapView];
    [self.view addSubview:self.navigationManager.mainView];
    self.delegate = self.navigationManager;
    self.navigationManager.mainView.hidden = YES;
    self.navigationManager.delegate = self;
    self.navigationManager.prefferedDisplayMode = SKMapDisplayMode2D;
    self.navigationManager.configuration.routeType = self.routeMode;
    switch (self.routeMode) {
        case SKRoutePedestrian:
            self.navigationManager.navigationSettings.transportMode = SKTransportPedestrian;
            break;
        case SKRouteBicycleFastest:
        case SKRouteBicycleQuietest:
        case SKRouteBicycleShortest:
            self.navigationManager.navigationSettings.transportMode = SKTransportBicycle;
            break;
        case SKRouteCarFastest:
        case SKRouteCarShortest:
        case SKRouteCarEfficient:
            self.navigationManager.navigationSettings.transportMode = SKTransportCar;
            break;
        default:
            self.navigationManager.navigationSettings.transportMode = SKTransportPedestrian;
            break;
    }
    self.navigationController.navigationBar.translucent = NO;
    self.navigationManager.mainView.orientation = SKTUIOrientationPortrait;
    self.navigationManager.mainView.navigationView.delegate = self;
    self.navigationManager.mainView.freeDriveView.delegate = self;
    
}

- (void)updateAnnotations {
    if (![SKTNavigationUtils locationIsZero:self.configuration.startCoordinate]) {
        SKAnnotation *annotation = [SKAnnotation annotation];
        annotation.location = self.configuration.startCoordinate;
        annotation.identifier = kStartAnnotationIdentifier;
        annotation.annotationType = SKAnnotationTypeGreen;
        [self.mapView addAnnotation:annotation withAnimationSettings:[SKAnimationSettings animationSettings]];
    } else {
        [self.mapView removeAnnotationWithID:kStartAnnotationIdentifier];
    }
    
    if (![SKTNavigationUtils locationIsZero:self.configuration.destination]) {
        SKAnnotation *annotation = [SKAnnotation annotation];
        annotation.location = self.configuration.destination;
        annotation.identifier = kEndAnnotationIdentifier;
        annotation.annotationType = SKAnnotationTypeRed;
        [self.mapView addAnnotation:annotation withAnimationSettings:[SKAnimationSettings animationSettings]];
    } else {
        [self.mapView removeAnnotationWithID:kEndAnnotationIdentifier];
    }
    
    if (self.configuration.viaPoints.count > 0) {
        SKViaPoint *point = self.configuration.viaPoints[0];
        SKAnnotation *annotation = [SKAnnotation annotation];
        annotation.location = point.coordinate;
        annotation.identifier = kViapointAnnotationIdentifier;
        annotation.annotationType = SKAnnotationTypePurple;
        [self.mapView addAnnotation:annotation withAnimationSettings:[SKAnimationSettings animationSettings]];
    } else {
        [self.mapView removeAnnotationWithID:kViapointAnnotationIdentifier];
    }
}

- (void)removeAnnotations {
    [self.mapView removeAnnotationWithID:kStartAnnotationIdentifier];
    [self.mapView removeAnnotationWithID:kEndAnnotationIdentifier];
}

- (void)routingServiceDidFinishRouteCalculation {
    // Remplace le tap sur le bouton Start
    if ([self.delegate respondsToSelector:@selector(calculatingRouteViewStartClicked:)]) {
        [self.delegate calculatingRouteViewStartClicked:nil];
    }
}

#pragma mark - SKTNavigationManagerDelegate methods

- (void)navigationManagerDidStopNavigation:(SKTNavigationManager *)manager withReason:(SKTNavigationStopReason)reason {
    if (reason == SKTNavigationStopReasonRoutingFailed) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Route calculation failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }
    [self cancelNavigation];
    self.mapView.delegate = self;
    [self updateAnnotations];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@implementation PedestrianNavigationViewController (UICreation)

- (void)addMapView {
    self.mapView = [[SKMapView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.settings.showCurrentPosition = YES;
    self.mapView.settings.showCompass = NO;
    self.mapView.delegate = self;
    SKCoordinateRegion region;
    region.center = self.start;
    region.zoomLevel = 16.0;
    self.mapView.visibleRegion = region;
    
    [self.view addSubview:self.mapView];
}

@end

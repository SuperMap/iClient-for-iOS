//
//  MainViewController.m
//  MapTestbed : Diagnostic map
//

#import "MainViewController.h"
#import "MapTestbedAppDelegate.h"
#import "RMMarker.h"

#import "MainView.h"
#import "RMFoundation.h"

@implementation MainViewController

@synthesize mapView;
@synthesize infoTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [mapView setDelegate:self];
	[mapView setDeceleration:YES];
    [self updateInfo];
}



 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
	 return YES;
 }



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateInfo];
}

- (void)dealloc {
    self.infoTextView = nil; 
    self.mapView = nil; 
    [super dealloc];
}

- (void)updateInfo {
	RMMapContents *contents = self.mapView.contents;
    CLLocationCoordinate2D mapCenter = [contents mapCenter];
    
    float routemeMetersPerPixel = [contents metersPerPixel];
	double truescaleDenominator =  [contents scaleDenominator];
    
    [infoTextView setText:[NSString stringWithFormat:@"Latitude : %f\nLongitude : %f\nZoom level : %.2f\nMeter per pixel : %.1f\nTrue scale : 1:%.0f", 
                           mapCenter.latitude, 
                           mapCenter.longitude, 
                           contents.zoom, 
                           routemeMetersPerPixel,
                           truescaleDenominator]];
}

#pragma mark -
#pragma mark Delegate methods

- (void) afterMapMove: (RMMapView*) map {
    [self updateInfo];
}

- (void) afterMapZoom: (RMMapView*) map byFactor: (float) zoomFactor near:(CGPoint) center {
    [self updateInfo];
}

- (void) singleTapOnMap: (RMMapView*) map At: (CGPoint) point {
    //NSLog(@"Clicked on Map - New location: X:%lf Y:%lf", point.x, point.y);
    
    UIImage *xMarkerImage = [UIImage imageNamed:@"markerflag.png"];
    
    CLLocationCoordinate2D one;
	one.latitude = 0;
	one.longitude = 0;
    
    RMMapContents *mapContents = self.mapView.contents;
    
    //[mapContents zoom]
    RMProjectedPoint point1;
    
    //point.x = point.y = 0;
    //one = [[mapContents projection] pointToLatLong:point];
    CLLocationCoordinate2D coordinate = [self.mapView.contents pixelToLatLong: point];
    //RMTilePoint pp;
    //pp = [self.mapView.contents latLongToTilePoint:coordinate withMetersPerPixel:19575.68359375];
    
    //[[mapContents projection] latLongToPoint:coordinate];
    NSLog(@"Clicked on Map - New location: X:%lf Y:%lf", coordinate.latitude, coordinate.longitude);
    RMMarker *newMarker;
	newMarker = [[RMMarker alloc] initWithUIImage:xMarkerImage anchorPoint:CGPointMake(0.5, 1.0)];
	[mapContents.markerManager addMarker:[newMarker autorelease] AtLatLong:coordinate];
    //[mapContents.markerManager addMarker:[newMarker autorelease] atProjectedPoint:coordinate];
    
}

- (void) tapOnMarker: (RMMarker*) marker onMap: (RMMapView*) map
{
	NSLog(@"MARKER TAPPED!");    
}


@end

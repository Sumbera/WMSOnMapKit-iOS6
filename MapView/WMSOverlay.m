//
//  WMSOverlay.m
//  MapView
//
//  Created by Stanislav Sumbera on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMSOverlay.h"
#import "MapViewUtils.h"
#import "XQueryComponents.h"
@implementation WMSOverlay

@synthesize boundingMapRect; // from <MKOverlay>
@synthesize coordinate;      // from <MKOverlay>

@synthesize opacity;
@synthesize name;

@synthesize baseUrl;

#pragma mark - memory management
//------------------------------------------------------------
-(id) init {
    self = [super init];
    
    opacity = 1;
    // !!!TODO set this to the bounding of the layer !!!
    boundingMapRect = MKMapRectWorld;
    //   boundingMapRect.origin.x += 1048600.0;
    // boundingMapRect.origin.y += 1048600.0;
    
    coordinate = CLLocationCoordinate2DMake(0, 0);
    
    return self;
}
//------------------------------------------------------------
- (id)initWithName:(NSString*)nameArg
               Url:(NSString*)urlArg 
           Opacity: (CGFloat) opacityArg
{
    
    if ((self = [self init])) {
       self.name = nameArg;
       self.url  = urlArg;
       self.opacity = opacityArg; 
    }
    return self;
}

#pragma mark -- WMS URL handling
//------------------------------------------------------------
//------------------------------------------------------------
-(void) setUrl:(NSString *)fullUrlArg{
   NSURL *url = [NSURL URLWithString:fullUrlArg];
    // -- get base URL without query parameters
    baseUrl = [url  urlByRemovingQueryParams];
    
    // -- parse query parameters and store them in dictionary
   _urlParameters = [url queryComponents];
   
    
}
// gets url by assembling fragments
//--------------------------------------------------------------------------------------------------
-(NSString*) url{
    
    NSString *queryString = [_urlParameters stringFromQueryComponents];
    
    NSString *fullUrl = [NSString stringWithFormat:@"%@?%@",[baseUrl absoluteString],queryString];
    return fullUrl;
}

// returns URL for mapRect tile

//------------------------------------------------------------
- (NSString*) getUrl: (MKMapRect) mapRect zoomScale: (MKZoomScale) zoomScale;
{
    // prepare parameters
    // [self calculateCoordinates_new:mapRect zoomScale:zoomScale];
    
    // Zoom
    NSUInteger z = TileZ(zoomScale);
    NSUInteger x = TileX(mapRect, zoomScale);
    NSUInteger y = TileY(mapRect,zoomScale);
   
    // BBOX in WGS84
    double  left   =   xOfColumn(x,z); //minX
    double right  = xOfColumn(x+1,z); //maxX
    double bottom = yOfRow(y+1,z); //minY
    double top    = yOfRow(y,z); //maxY
    
    NSString * resolvedUrl = [NSString stringWithFormat:@"%@&BBOX=%f,%f,%f,%f",self.url,left,bottom,right,top];
    
    NSLog(@"Url overlay %@", resolvedUrl);
    return resolvedUrl;

}


@end

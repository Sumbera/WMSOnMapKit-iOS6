//
//  WMSOverlayView.m
//  MapView
//
//  Created by Stanislav Sumbera on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMSOverlayView.h"
#import "MapViewUtils.h"
#import "MKNetworkOperation.h"
#import "Downloader.h"
#import "WebRequestInfo.h"

@implementation WMSOverlayView

@synthesize mapView;


//------------------------------------------------------------
- (id)initWithWMSLayer:(WMSOverlay*)wmsOverlay 
            MapView: (MKMapView *) view
{
    // -- stores overlay in self.overlay 
    self = [super initWithOverlay:(id <MKOverlay>)wmsOverlay];
    if (self){
        self.mapView = view;
    }
    
    return self;
}
//--set needs display om Main thread
//-----------------------------------------------------------------------------------------
-(void) setNeedsDisplayOnMainThread:(WebRequestInfo*) requestInfo{
    [self setNeedsDisplayInMapRect:requestInfo.mapRect  zoomScale:requestInfo.zoomScale];
    
}
//-------------------------------------------------------------------------------------
-(void) downloadTile:(WebRequestInfo* )requestInfo{
  
    Downloader *downloader = [Downloader defaultDownloader];
    
    MKNetworkOperation *operation = [downloader operationWithURLString:requestInfo.url 
                                                                params:nil
                                                            httpMethod:@"GET"];
        
    [operation addDownloadStream:[NSOutputStream outputStreamToFileAtPath:requestInfo.filePath
                                                                   append:YES]];
    
    [downloader enqueueOperation:operation];
    
    
    [operation onDownloadProgressChanged:^(double progress) {
         
        
    }];
    
    [operation onCompletion:^(MKNetworkOperation* completedRequest) {
               DLog(@"%@", completedRequest);
        [self performSelectorOnMainThread:@selector(setNeedsDisplayOnMainThread:) withObject:requestInfo waitUntilDone:NO];
     // -- update map view rect
    }
    onError:^(NSError* error) {
    
      // -- do nothing for now...  
        NSLog (@"Error downloading tile %@", requestInfo.url);
    }];
}

//-------------------------------------------------------------------------------------
- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    
    
    WMSOverlay  * wmsOverlay = (WMSOverlay*) self.overlay;
    
    NSString    *url      =  [wmsOverlay getUrl:mapRect zoomScale:zoomScale];
    
    if (!url){
        NSLog(@"Evaluation error !!! \n");
        return NO;
    }
    
    // -- check if tile is cached 
    if ([[NSFileManager defaultManager] fileExistsAtPath: getFilePathForURL(url,TILE_CACHE)]){
        return YES; // if any file in overlay array is cached we have to draw it.
    }
    
    
    
   // -- download
    else{
        
        WebRequestInfo * requestInfo = [[WebRequestInfo alloc] init];
        
        requestInfo.url = url;
        requestInfo.userInfo  = nil;
        requestInfo.filePath = getFilePathForURL(requestInfo.url,TILE_CACHE);
        requestInfo.mapRect = mapRect;
        requestInfo.zoomScale= zoomScale;

        [self downloadTile:requestInfo];

        return NO;
                
        /*
         TileLoad(url,YES);
         return YES;
         */
        
       
    }
    
}

//-------------------------------------------------------------------------------------
- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context {
    
    WMSOverlay *wmsOverlay   = (WMSOverlay*) self.overlay;
    NSString     *url      = [wmsOverlay getUrl:mapRect zoomScale:zoomScale];
    UIImage       *image   = TileLoad(url,NO);
    if (image){
        TileDraw(image,mapRect,(double) 1/zoomScale,wmsOverlay.opacity,context);
    }
    
    
}


@end

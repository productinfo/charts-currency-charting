//
//  SyncingCrosshair.m
//  CurrencyCharting
//
//  Created by Simon Withington on 09/09/2013.
//  Copyright 2013 Scott Logic Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <ShinobiCharts/ShinobiChart.h>
#import <ShinobiCharts/SChartCanvas.h>
#import <ShinobiCharts/SChartCanvasOverlay.h>
#import "SyncingCrosshair.h"
#import "SyncingCrosshairDelegate.h"

#define notificationCrosshairMoved   @"CrosshairMoved"
#define notificationCrosshairRemoved @"CrosshairRemoved"
#define kSender @"Sender"
#define kDataPoint @"DataPoint"

@implementation SyncingCrosshair

-(instancetype)initWithChart:(ShinobiChart *)parentChart {
    
    if (self = [super initWithChart: parentChart]) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(didReceiveNotification:)
                                                     name: notificationCrosshairMoved
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(didReceiveNotification:)
                                                     name: notificationCrosshairRemoved
                                                   object: nil];
    }
    
    return self;
}

-(void)moveToPosition:(SChartPoint)coordinates
  andDisplayDataPoint:(SChartPoint)position
           fromSeries:(SChartCartesianSeries *)series
   andSeriesDataPoint:(id<SChartData>)dp {
    
    [super moveToPosition: coordinates
      andDisplayDataPoint: position
               fromSeries: series
       andSeriesDataPoint: dp];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: notificationCrosshairMoved
                                                        object: nil
                                                      userInfo: @{kDataPoint: dp, kSender: self}];
    
}

-(BOOL)removeCrosshair {
    
    [super removeCrosshair];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: notificationCrosshairRemoved
                                                        object: nil
                                                      userInfo: @{kSender: self}];
    return NO;
}

-(void)didReceiveNotification:(NSNotification *)notification  {
    
    if (notification.userInfo[kSender] != self) {
        
        if ([notification.name isEqualToString: notificationCrosshairMoved]) {
            
            [self moveToPositionForDataPoint: notification.userInfo[kDataPoint]];
            
        } else if ([notification.name isEqualToString: notificationCrosshairRemoved]) {
            
            [self remove];
            
        }
    }
}

-(void)moveToPositionForDataPoint:(id<SChartData>)dataPoint {
    
    SChartCartesianSeries *series = nil;
    
    SChartDataPoint *dp = [self.delegate equivalentDataPointForDataPoint: dataPoint
                                                      inEquivalentSeries: &series];
    
    SChartPoint coordinates = [self.delegate coordinatesForDataPoint: dp];
    
    SChartPoint position;
    position.x = [dp.xValue timeIntervalSince1970];
    position.y = [dp.yValue doubleValue];
    
    [self showCrosshair];
    self.trackingSeries = series;
    
    [self crosshairMovedInsideRange];
    
    [super moveToPosition: coordinates
      andDisplayDataPoint: position
               fromSeries: series
       andSeriesDataPoint: dp];
}

-(void)remove {
    [super removeCrosshair];
}

@end

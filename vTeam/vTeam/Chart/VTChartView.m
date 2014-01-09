//
//  VTChartView.m
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTChartView.h"

#import <QuartzCore/QuartzCore.h>

@interface VTChartViewLayer : CALayer<IVTChartView>

@end

@implementation VTChartViewLayer

@synthesize chart = _chart;

-(void) dealloc{
    [_chart release];
    [super dealloc];
}

-(id) initWithLayer:(id)layer{
    if((self = [super initWithLayer:layer])){
        self.chart = [layer chart];
    }
    return self;
}

+(BOOL) needsDisplayForKey:(NSString *)key{
    if([key isEqualToString:@"animationValue"] || [key isEqualToString:@"chart"] || [key isEqualToString:@"frame"]){
        return YES;
    }
    return [super needsDisplayForKey:key];
}

-(void) drawInContext:(CGContextRef)ctx{
    [super drawInContext:ctx];
    
    CGSize size = self.bounds.size;

    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0 ,  -1.0 );
    
    [_chart drawToContext:ctx rect:CGRectMake(0, 0, size.width, size.height)];
}

-(void) setChart:(id<IVTChart>)chart{
    [chart retain];
    [_chart release];
    _chart = chart;
    [self setNeedsDisplay];
}
-(void) setAnimationValue:(double)animationValue{
    [_chart setAnimationValue:animationValue];
}

-(double) animationValue{
    return [_chart animationValue];
}

@end

@implementation VTChartView

+(Class) layerClass{
    return [VTChartViewLayer class];
}

-(void) dealloc{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id<IVTChart>) chart{
    return [(VTChartViewLayer *)self.layer chart];
}

-(void) setChart:(id<IVTChart>)chart{
    [(VTChartViewLayer *)self.layer setChart:chart];

}

-(void) setAnimationValue:(double)animationValue{
    [(VTChartViewLayer *)self.layer setAnimationValue:animationValue];
}

-(double) animationValue{
    return [(VTChartViewLayer *)self.layer animationValue];
}

@end

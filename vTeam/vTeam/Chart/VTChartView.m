//
//  VTChartView.m
//  vTeam
//
//  Created by zhang hailong on 14-1-8.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTChartView.h"

#import <QuartzCore/QuartzCore.h>

@interface VTChartViewLayer : CALayer<IVTChartView>{

}

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

-(void) display{
    
    CGFloat scale = 1.0;
    
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        scale = [[UIScreen mainScreen] scale];
    }
    
    CGSize size = self.bounds.size;
    
    size.width *= scale;
    size.height *= scale;
    
    UIGraphicsBeginImageContext(size);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(ctx,  scale, scale);
    
    [_chart drawToContext:ctx rect:CGRectMake(0, 0, size.width / scale, size.height / scale)];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndPDFContext();
    
    self.contentsScale = scale;
    self.contents = (id)[image CGImage];
    
}

-(void) setChart:(id<IVTChart>)chart{
    if(_chart != chart){
        [chart retain];
        [_chart release];
        _chart = chart;
        [self setNeedsDisplay];
    }
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

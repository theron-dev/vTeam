//
//  VTRichView.m
//  vTeam
//
//  Created by zhang hailong on 13-7-17.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTRichView.h"

@implementation VTRichView

@synthesize rich = _rich;

-(void) dealloc{
    [_rich release];
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


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //CGSize size = self.bounds.size;
    //CGContextTranslateCTM(ctx, 0, -size.height);
    //CGContextScaleCTM(ctx, 1, -1);
    
    CTFrameRef frame = [_rich frameWithWidth:self.bounds.size.width];
    
    CTFrameDraw(frame, ctx);
    
    CGPoint p;
    
    for(id element in [_rich elements]){
        
        if([element conformsToProtocol:@protocol(IVTRichDrawElement)]){
            
            NSRange r = [element range];
            
            CTFrameGetLineOrigins(frame, CFRangeMake(r.location, 1), &p);

            CGContextSaveGState(ctx);
            
            CGContextTranslateCTM(ctx, p.x, p.y);
            
            [element drawRect:CGRectMake(0, 0, [element width], [element ascent] + [element descent]) context:ctx];
            
            CGContextRestoreGState(ctx);
            
        }
    }
    
}


-(void) handleViewElements{
    
    CTFrameRef frame = [_rich frameWithWidth:self.bounds.size.width];
    
    CGPoint p;
    
    for(id element in [_rich elements]){
        
        if([element conformsToProtocol:@protocol(IVTRichViewElement)]){
            
            NSRange r = [element range];
            
            CTFrameGetLineOrigins(frame, CFRangeMake(r.location, 1), &p);
            
            CGRect rect = CGRectMake(p.x, p.y, [element width], [element ascent] + [element descent]);
            
            [[element view] setFrame:rect];
            
            [self addSubview:[element view]];
            
        }
    }
}

-(void) setRich:(VTRich *)rich{
    if(_rich != rich){
        
        for(id element in [_rich elements]){
            if([element conformsToProtocol:@protocol(IVTRichViewElement)]){
                [[element view] removeFromSuperview];
            }
        }
        
        [rich retain];
        [_rich release];
        _rich = rich;
        
        [self setNeedsDisplay];
        [self handleViewElements];
    }
}

@end

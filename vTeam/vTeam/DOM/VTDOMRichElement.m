//
//  VTDOMRichElement.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMRichElement.h"

#import "VTRich.h"
#import "VTDOMElement+Render.h"
#import "VTDOMElement+Style.h"
#import "VTDOMElement+Layout.h"
#import "VTDOMDocument.h"

@interface VTDOMRichElement(){
   
}

@property(nonatomic,readonly) VTRich * rich;

@end

@implementation VTDOMRichElement

@synthesize rich = _rich;

-(void) dealloc{
    [_rich release];
    [super dealloc];
}

-(VTRich *) rich{
    if(_rich == nil){
        
        _rich = [[VTRich alloc] init];
        
        _rich.font = [self font];
        _rich.textColor = [self textColor];
        _rich.linesSpacing = [self floatValueForKey:@"line-spacing"];
        
        if([self.text length]){
            [_rich appendText:self.text attributes:nil];
        }
    }
    return _rich;
}

-(UIFont *) font{
    UIFont * font = [self fontValueForKey:@"font"];
    
    if(font == nil){
        CGFloat fontSize = [self floatValueForKey:@"font-size"];
        if(fontSize == 0){
            fontSize = 14;
        }
        font = [UIFont systemFontOfSize:14];
    }
    
    return font;
}

-(UIColor *) textColor{
    
    UIColor * color = [self colorValueForKey:@"color"];
    
    if(color == nil){
        color = [UIColor blackColor];
    }
    
    return color;
}

-(void) draw:(CGRect)rect context:(CGContextRef)context{
    [super draw:rect context:context];

    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGSize size = self.frame.size;
    
    CTFrameRef frame = [self.rich frameWithSize:size];
    
    CTFrameDraw(frame, context);
    
}

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    CGRect r = [self frame];
    
    if(r.size.width == MAXFLOAT || r.size.height == MAXFLOAT){
        
        CGSize s = [self.rich contentSizeWithSize:r.size];
        
        if(r.size.width == MAXFLOAT){
            r.size.width = s.width;
        }
        
        if(r.size.height == MAXFLOAT){
            r.size.height = s.height;
        }
        
        [self setFrame:r];
        
    }
    return r.size;
}

@end

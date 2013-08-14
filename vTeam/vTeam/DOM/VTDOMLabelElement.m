//
//  VTDOMLabelElement.m
//  vTeam
//
//  Created by zhang hailong on 13-8-14.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMLabelElement.h"

#import "VTDOMElement+Render.h"
#import "VTDOMElement+Style.h"
#import "VTDOMElement+Layout.h"
#import "VTDOMDocument.h"

@implementation VTDOMLabelElement

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

-(UILineBreakMode) lineBreakMode{
    
    UILineBreakMode breakMode = UILineBreakModeCharacterWrap;
    
    NSString * mode = [self stringValueForKey:@"break-mode"];
    
    if([mode isEqualToString:@"wrap"]){
        breakMode = UILineBreakModeWordWrap;
    }
    else if([mode isEqualToString:@"clip"]){
        breakMode = UILineBreakModeClip;
    }
    else if([mode isEqualToString:@"head"]){
        breakMode = UILineBreakModeHeadTruncation;
    }
    else if([mode isEqualToString:@"tail"]){
        breakMode = UILineBreakModeTailTruncation;
    }
    else if([mode isEqualToString:@"middle"]){
        breakMode = UILineBreakModeMiddleTruncation;
    }
    else{
        breakMode = UILineBreakModeCharacterWrap;
    }

    return breakMode;
}

-(UITextAlignment) alignment{
    UITextAlignment alignment = UITextAlignmentLeft;
    
    NSString * align = [self stringValueForKey:@"align"];
    
    if([align isEqualToString:@"center"]){
        alignment = UITextAlignmentCenter;
    }
    else if([align isEqualToString:@"right"]){
        alignment = UITextAlignmentRight;
    }

    return alignment;
}

-(CGSize) layoutChildren:(UIEdgeInsets)padding{
    CGRect r = [self frame];
    
    if(r.size.width == MAXFLOAT || r.size.height == MAXFLOAT){

        NSString * text = [self text];
        
        if(text){
            
            CGSize s = [text sizeWithFont:[self font] constrainedToSize:r.size lineBreakMode:self.lineBreakMode];
            
            if(r.size.width == MAXFLOAT){
                r.size.width = s.width;
            }
            
            if(r.size.height == MAXFLOAT){
                r.size.height = s.height;
            }
        }
        else{
            if(r.size.width == MAXFLOAT){
                r.size.width = 0;
            }
            
            if(r.size.height == MAXFLOAT){
                r.size.height = 0;
            }
        }
        
        [self setFrame:r];

    }
    return r.size;
}

-(void) draw:(CGRect) rect context:(CGContextRef) context{
    [super draw:rect context:context];

    NSString * text = [self text];
    
    if(text){
        
        UIFont * font = [self font];
        
        UIColor * color = [self textColor];
    
        UILineBreakMode breakMode = [self lineBreakMode];
        
        UITextAlignment alignment = [self alignment];
        
        CGContextSetFillColorWithColor(context, [color CGColor]);
    
        CGContextSetStrokeColorWithColor(context, [color CGColor]);

        UIGraphicsPushContext(context);

        CGSize size = self.frame.size;
        
        [text drawInRect:CGRectMake(0, 0, size.width, size.height) withFont:font lineBreakMode:breakMode alignment:alignment];
        
        UIGraphicsPopContext();
    }

}


@end

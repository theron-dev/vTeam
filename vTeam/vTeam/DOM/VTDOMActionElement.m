//
//  VTDOMActionElement.m
//  vTeam
//
//  Created by zhang hailong on 13-8-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMActionElement.h"
#import <vTeam/VTDOMDocument.h>
#import <vTeam/VTDOMElement+Style.h>
#import <vTeam/VTDOMElement+Control.h>
#import <QuartzCore/QuartzCore.h>

@interface VTDOMActionElement(){
    CALayer * _highlightedLayer;
}

@property(nonatomic,assign) BOOL insetTouch;

@end

@implementation VTDOMActionElement

@synthesize insetTouch = _insetTouch;

-(void) dealloc{
    [_highlightedLayer release];
    [super dealloc];
}

-(BOOL) isAllowLongTapAction{
    return [self booleanValueForKey:@"long-tap"];
}

-(void) longAction{
    
    [self setAttributeValue:@"true" forKey:@"long-action"];
    
    if([self.delegate respondsToSelector:@selector(vtDOMElementDoAction:)]){
        [self.delegate vtDOMElementDoAction:self];
    }
    
}

-(BOOL) touchesBegan:(CGPoint)location{
    
    if([self booleanValueForKey:@"disabled"]){
        return NO;
    }
    
    [super touchesBegan:location];
    _insetTouch = YES;
    
    if([self isAllowLongTapAction]){
        [self performSelector:@selector(longAction) withObject:nil afterDelay:0.8];
    }
    
    return YES;
}

-(void) touchesCancelled:(CGPoint)location{
    if([self isHighlighted]){
        [self setHighlighted:NO];
    }
    _insetTouch = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(longAction) object:nil];
    [self setAttributeValue:nil forKey:@"long-action"];
}

-(void) touchesEnded:(CGPoint)location{
    
    if(_insetTouch && ! [self booleanValueForKey:@"long-action"]){
        if([self.delegate respondsToSelector:@selector(vtDOMElementDoAction:)]){
            [self.delegate vtDOMElementDoAction:self];
        }
    }
    
    _insetTouch = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(longAction) object:nil];
    [self setAttributeValue:nil forKey:@"long-action"];
    
    [super touchesEnded:location];
}

-(void) setDelegate:(id)delegate{
    [super setDelegate:delegate];
    [_highlightedLayer removeFromSuperlayer];
}

-(void) refreshHighlightedLayer{
    
    if([self isHighlighted] || [self isSelected]){
        
        if([self.delegate respondsToSelector:@selector(vtDOMElement:addLayer:frame:)]){
            
            CGSize size = self.frame.size;
            
            if(_highlightedLayer == nil){
                _highlightedLayer = [[CALayer alloc] init];
            }
            
            UIColor * actionColor = [self colorValueForKey:@"action-color"];
            
            if(actionColor == nil){
                actionColor = [UIColor colorWithWhite:1.0 alpha:0.2];
            }
            
            _highlightedLayer.cornerRadius = [self floatValueForKey:@"corner-radius"];
            _highlightedLayer.masksToBounds = YES;
            _highlightedLayer.backgroundColor = [actionColor CGColor];
            
            UIImage * actionImage = [self imageValueForKey:@"action-image" bundle:self.document.bundle];
            
            if(actionImage){
                
                _highlightedLayer.contents = (id)[actionImage CGImage];
                _highlightedLayer.contentsRect = CGRectMake(0, 0, 1.0, 1.0);
                
                NSString * gravity = [self stringValueForKey:@"action-gravity"];
                
                if([gravity isEqualToString:@"center"]){
                    _highlightedLayer.contentsGravity = kCAGravityCenter;
                }
                else if([gravity isEqualToString:@"resize"]){
                    _highlightedLayer.contentsGravity = kCAGravityResize;
                }
                else if([gravity isEqualToString:@"top"]){
                    _highlightedLayer.contentsGravity = kCAGravityTop;
                }
                else if([gravity isEqualToString:@"bottom"]){
                    _highlightedLayer.contentsGravity = kCAGravityBottom;
                }
                else if([gravity isEqualToString:@"left"]){
                    _highlightedLayer.contentsGravity = kCAGravityLeft;
                }
                else if([gravity isEqualToString:@"right"]){
                    _highlightedLayer.contentsGravity = kCAGravityRight;
                }
                else if([gravity isEqualToString:@"topleft"]){
                    _highlightedLayer.contentsGravity = kCAGravityTopLeft;
                }
                else if([gravity isEqualToString:@"topright"]){
                    _highlightedLayer.contentsGravity = kCAGravityTopRight;
                }
                else if([gravity isEqualToString:@"bottomleft"]){
                    _highlightedLayer.contentsGravity = kCAGravityBottomLeft;
                }
                else if([gravity isEqualToString:@"bottomright"]){
                    _highlightedLayer.contentsGravity = kCAGravityBottomRight;
                }
                else if([gravity isEqualToString:@"aspect"]){
                    _highlightedLayer.contentsGravity = kCAGravityResizeAspect;
                }
                else{
                    _highlightedLayer.contentsGravity = kCAGravityResizeAspectFill;
                }
                
            }
            else{
                _highlightedLayer.contents = nil;
            }
            
            [self.delegate vtDOMElement:self addLayer:_highlightedLayer frame:CGRectMake(0, 0, size.width, size.height)];
            
        }
    }
    else{
        [_highlightedLayer removeFromSuperlayer];
        
    }
    
}

-(void) setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    for(VTDOMElement * el in [self childs]){
        [el setHighlighted:highlighted];
    }
    
    [self refreshHighlightedLayer];
}

-(void) setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    [self refreshHighlightedLayer];
}


-(NSString *) actionName{
    return [self attributeValueForKey:@"action-name"];
}

-(void) setActionName:(NSString *)actionName{
    [self setAttributeValue:actionName forKey:@"action-name"];
}

-(id) userInfo{
    return [self attributeValueForKey:@"user-info"];
}

-(void) setUserInfo:(id)userInfo{
    [self setAttributeValue:userInfo forKey:@"user-info"];
}

-(NSArray *) actionViews{
    return nil;
}

-(void) setActionViews:(NSArray *)actionViews{
    
}

@end

//
//  VTDOMLinkElement.m
//  vTeam
//
//  Created by zhang hailong on 14-1-6.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDOMLinkElement.h"

#import <vTeam/VTDOMDocument.h>
#import <vTeam/VTDOMElement+Style.h>
#import <vTeam/VTDOMElement+Control.h>
#import <QuartzCore/QuartzCore.h>

@interface VTDOMLinkElement(){
    CALayer * _highlightedLayer;
}


@property(nonatomic,assign) BOOL insetTouch;

@end

@implementation VTDOMLinkElement

@synthesize insetTouch = _insetTouch;

-(void) dealloc{
    [_highlightedLayer release];
    [super dealloc];
}

-(BOOL) touchesBegan:(CGPoint)location{
    [super touchesBegan:location];
    _insetTouch = YES;
    return YES;
}

-(void) touchesCancelled:(CGPoint)location{
    if([self isHighlighted]){
        [self setHighlighted:NO];
    }
    _insetTouch = NO;
}

-(void) touchesEnded:(CGPoint)location{
    
    if(_insetTouch){
        if([self.delegate respondsToSelector:@selector(vtDOMElementDoAction:)]){
            [self.delegate vtDOMElementDoAction:self];
        }
    }
    
    _insetTouch = NO;
    
    [super touchesEnded:location];
}

-(void) setDelegate:(id)delegate{
    [super setDelegate:delegate];
    [_highlightedLayer removeFromSuperlayer];
}

-(void) setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    for(VTDOMElement * el in [self childs]){
        [el setHighlighted:highlighted];
    }
    
    if(highlighted){
        
        if([self.delegate respondsToSelector:@selector(vtDOMElement:addLayer:frame:)]){
            
            CGSize size = self.frame.size;
            
            if(_highlightedLayer == nil){
                _highlightedLayer = [[CALayer alloc] init];
            }
            
            UIColor * actionColor = [self colorValueForKey:@"action-color"];
            
            if(actionColor == nil){
                actionColor = [UIColor colorWithWhite:1.0 alpha:0.3];
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

//
//  VTDOMLabel.m
//  vTeam
//
//  Created by zhang hailong on 13-9-3.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTDOMLabel.h"

#import "VTDOMDocument.h"
#import "VTDOMParse.h"
#import "VTDOMElement+Frame.h"
#import "VTDOMElement+Render.h"
#import "VTDOMElement+Layout.h"

@interface VTDOMLabel(){

}

@property(nonatomic,retain) VTDOMDocument * document;

@end

@implementation VTDOMLabel

@synthesize document = _document;

-(void) dealloc{
    [_document release];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(ctx , CGAffineTransformIdentity);
    
    [_document.rootElement render:_document.rootElement.frame context:ctx];
    
}

- (void) setText:(NSString *)text{
    [super setText:text];
    
    if(text){
        
        VTDOMDocument * document = [[VTDOMDocument alloc] init];
        
        VTDOMParse * parse = [[VTDOMParse alloc] init];
        
        [parse parseHTML:text toDocument:document];
        
        [document.rootElement layout:self.bounds.size];
        
        [self setDocument:document];
        
        [document release];
        
        [parse release];
    }
    else{
        [self setDocument:nil];
    }
    [self setNeedsDisplay];
}

-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    [_document.rootElement layout:self.bounds.size];
    [self setNeedsDisplay];
}

@end

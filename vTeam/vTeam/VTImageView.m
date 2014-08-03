//
//  VTImageView.m
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "VTImageView.h"

#import <QuartzCore/QuartzCore.h>

#import "UIView+VTDOMElement.h"

#import "VTDOMElement+Style.h"

@implementation VTImageView

@synthesize src = _src;
@synthesize source = _source;
@synthesize loading = _loading;
@synthesize defaultImage = _defaultImage;
@synthesize loaded = _loaded;
@synthesize defaultSrc = _defaultSrc;
@synthesize reuseFileURI = _reuseFileURI;
@synthesize localAsyncLoad = _localAsyncLoad;

-(void) dealloc{
    [_src release];
    [_defaultImage release];
    [_defaultSrc release];
    [_reuseFileURI release];
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

-(void) setImage:(UIImage *)image{
    [self setImage:image isLocal:NO];
}

-(void) setImage:(UIImage *) image isLocal:(BOOL) isLocal{
    if(image == nil){
        if(!isLocal){
            self.loaded = YES;
        }
        [super setImage:_defaultImage];
    }
    else{
        self.loaded = YES;
        [super setImage:image];
    }
    if((_fitHeight || _fitWidth) && self.image){
        CGSize imageSize = [self.image size];
        CGRect r = [self frame];
        
        if(_fitWidth){
            
            if(r.size.width && r.size.height && imageSize.width && imageSize.height){
                
                if(r.size.width / r.size.height != imageSize.width / imageSize.height){
                    r.size.width = imageSize.width / imageSize.height * r.size.height;
                    
                    if(_maxWidth && r.size.width > _maxWidth){
                        r.size.width = _maxWidth;
                    }
                    
                    if(_minWidth && r.size.width < _minWidth){
                        r.size.width = _minWidth;
                    }
                    
                    [self setFrame:r];
                }
                
            }
            
        }
        
        if(_fitHeight){
            
            if(r.size.width && r.size.height && imageSize.width && imageSize.height){
                
                if(r.size.width / r.size.height != imageSize.width / imageSize.height){
                    
                    r.size.height = imageSize.height / imageSize.width * r.size.width;
                    
                    if(_maxHeight && r.size.height > _maxHeight){
                        r.size.height = _maxHeight;
                    }
                    
                    if(_minHeight && r.size.height < _minHeight){
                        r.size.height = _minHeight;
                    }
                    
                    [self setFrame:r];
                }
                
            }
            
        }
    }
}

-(void) setDefaultImage:(UIImage *)defaultImage{
    if(_defaultImage != defaultImage){
        if([self image] == _defaultImage){
            [super setImage:nil];
        }
        [_defaultImage release];
        _defaultImage = [defaultImage retain];
        if(self.image == nil){
            [super setImage:_defaultImage];
        }
    }
}

-(void) setSrc:(NSString *)src{
    if(_src != src && ! [_src isEqualToString:src]){
        [src retain];
        [_src release];
        _src = src;
        self.loaded = NO;
        [super setImage:_defaultImage];
    }
}


-(void) setElement:(VTDOMElement *)element{
    [super setElement:element];
    
    self.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.maxWidth = [element floatValueForKey:@"max-width"];
    self.maxHeight = [element floatValueForKey:@"max-height"];
    self.minWidth = [element floatValueForKey:@"min-width"];
    self.minHeight = [element floatValueForKey:@"min-height"];
    self.fitWidth = [element booleanValueForKey:@"fit-width"];
    self.fitHeight = [element booleanValueForKey:@"fit-height"];
    self.defaultSrc = [element attributeValueForKey:@"default-src"];
    self.src = [element attributeValueForKey:@"src"];
    
}


@end

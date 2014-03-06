//
//  VTStyleSheet.m
//  vTeam
//
//  Created by zhang hailong on 13-4-25.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <vTeam/VTStyleSheet.h>

@interface VTStyleSheet(){
    NSMutableDictionary * _images;
}

@end

@implementation VTStyleSheet

@synthesize version = _version;
@synthesize styleController = _styleController;

-(id) init{
    if((self = [super init])){

    }
    return self;
}


-(void) dealloc{
    [_styleController release];
    [_images release];
    [super dealloc];
}

-(NSDictionary *) selectorStyle:(NSString *) styleName{
    
    [_styleController view];
    
    NSArray * names=  [styleName componentsSeparatedByString:@" "];
    
    NSMutableDictionary * styles = [NSMutableDictionary dictionaryWithCapacity:4];
    
    for(NSString * name in names){
        for(VTStyle * style in [_styleController styles]){
            if([style.name isEqualToString:name]){
                [styles setValue:style forKey:style.key];
            }
        }
    }
    
    return styles;
}

-(UIColor *) styleValueColor:(NSString *) value{
    int r=0,g=0,b=0;
    float a = 1.0;
    sscanf([value UTF8String], "#%02x%02x%02x %f",&r,&g,&b,&a);
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

-(UIFont *) styleValueFont:(NSString *) value{
    char name[256] = "";
    float size = 0;
    sscanf([value UTF8String], "%f %s",&size,name);
    if(strcmp(name, "bold") ==0){
        return [UIFont boldSystemFontOfSize:size];
    }
    if(strcmp(name, "italic") ==0){
        return [UIFont italicSystemFontOfSize:size];
    }
    if(strlen(name) >0){
        return [UIFont fontWithName:[NSString stringWithCString:name encoding:NSUTF8StringEncoding] size:size];
    }
    return [UIFont systemFontOfSize:size];
}

-(CGFloat) styleValueFloat:(NSString *) value{
    return [value floatValue];
}

-(UIImage *) styleValueImage:(NSString *) image{
    NSRange r = [image rangeOfString:@" "];
    double left = 0,top = 0;
    
    UIImage * img = nil;
    
    if(r.location != NSNotFound){
        sscanf([[image substringFromIndex:r.location + 1] UTF8String], "%lf %lf",&left,&top);
        image = [image substringToIndex:r.location];
    }
    
    if([image hasPrefix:@"@"]){
        img = [UIImage imageNamed:[image substringFromIndex:1]];
        if(left && top){
            img = [img stretchableImageWithLeftCapWidth:left topCapHeight:top];
        }
        return img;
    }
    
    NSBundle * bundle = [_styleController nibBundle];
    
    if(bundle == nil){
        bundle = [NSBundle mainBundle];
    }
    
    NSString * path = [[bundle bundlePath] stringByAppendingPathComponent:image];
    
    img = [_images objectForKey:path];
    
    if(img == nil){
        
        UIScreen * screen = [UIScreen mainScreen];
        
        if([screen respondsToSelector:@selector(scale)] && [screen scale] > 1.0){
            NSString * pathExtension = [path pathExtension];
            NSString * p = [[[path stringByDeletingPathExtension] stringByAppendingString:@"@2x"] stringByAppendingPathExtension:pathExtension];
            img = [UIImage imageWithContentsOfFile:p];
        }
        
        if(img == nil){
            img = [UIImage imageWithContentsOfFile:path];
        }
        if(img == nil){
            //如果没有一倍图，就用二倍图
            NSString * pathExtension = [path pathExtension];
            NSString * p = [[[path stringByDeletingPathExtension] stringByAppendingString:@"@2x"] stringByAppendingPathExtension:pathExtension];
            img = [UIImage imageWithContentsOfFile:p];
        }

        if(img){
            if(_images == nil){
                _images = [[NSMutableDictionary alloc] initWithCapacity:32];
            }
            [_images setObject:img forKey:path];
        }
    }
    
    if(left && top){
        img = [img stretchableImageWithLeftCapWidth:left topCapHeight:top];
    }
    
    return img;
}

-(void) didReceiveMemoryWarning{
    [_images release];
    _images = nil;
}

-(void) setStyleController:(VTStyleController *) styleController{
    if(_styleController != styleController){
        [styleController retain];
        [_styleController release];
        _styleController = styleController;
        self.version = self.version + 1;
    }
}

@end

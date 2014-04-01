//
//  IVTImageTask.h
//  vTeam
//
//  Created by zhang hailong on 13-4-26.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vTeam/VTTask.h>

@protocol IVTImageTask <IVTTask>

@property(nonatomic,assign,getter = isLoaded) BOOL loaded;
@property(nonatomic,retain) NSString * defaultSrc;
@property(nonatomic,retain) NSString * src;
@property(nonatomic,assign,getter = isLoading) BOOL loading;
@property(nonatomic,retain) NSString * reuseFileURI;

-(void) setImage:(UIImage *) image;

-(void) setImage:(UIImage *) image isLocal:(BOOL) isLocal;

-(void) setDefaultImage:(UIImage *) image;

@end

@protocol IVTLocalImageTask <IVTImageTask>


@end

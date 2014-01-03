//
//  VTAudioService.h
//  vTeam
//
//  Created by zhang hailong on 14-1-3.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTService.h>

#import <vTeam/VTAudioTask.h>

#import <vTeam/VTHttpTask.h>

@interface VTAudioService : VTService<IVTHttpTaskDelegate>

-(NSString *) absoluteURL:(NSString *)url;

-(NSString *) audioLocalFilePath:(NSString *) url;

-(BOOL) isPlaying:(id<IVTAudioPlayTask>) playTask;

-(BOOL) play:(id<IVTAudioPlayTask>) playTask;

-(void) stop:(id<IVTAudioPlayTask>) playTask;

@end

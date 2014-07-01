//
//  VTAudioTask.h
//  vTeam
//
//  Created by zhang hailong on 14-1-3.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import <vTeam/VTTask.h>

typedef enum _VTAudioTaskStatus{
    VTAudioTaskStatusNone,VTAudioTaskStatusLoaded,VTAudioTaskStatusLoading,VTAudioTaskStatusPlaying
} VTAudioTaskStatus;

@protocol IVTAudioTask <IVTTask>

@property(nonatomic,retain) NSString * url;
@property(nonatomic,assign) VTAudioTaskStatus status;

@end

@protocol IVTAudioPlayTask <IVTAudioTask>

@property(nonatomic,assign,getter = isCancelPlay) BOOL cancelPlay;

@end


@interface VTAudioTask : VTTask<IVTAudioPlayTask>

@end

//
//  VTDBDataContext.m
//  vTeam
//
//  Created by zhang hailong on 14-4-3.
//  Copyright (c) 2014年 hailong.org. All rights reserved.
//

#import "VTDBDataContext.h"

#import "NSObject+VTValue.h"

NSString * VTDBDataObjectChangedNotification = @"VTDBDataObjectChangedNotification";

NSString * VTDBDataObjectSetKey = @"dataObjects";

@interface VTDBDataContext (){
    NSMutableDictionary * _dataTables;
    NSMutableArray * _updates;
}

-(void) removeDataObject:(VTDBDataObject *) dataObject;

@end

@interface VTDBDataObject (){
    VTDBDataContext * _dataContext;
}

-(void) setDataContext:(VTDBDataContext  *) dataContext;

@end

@implementation VTDBDataObject

-(void) setDataContext:(VTDBDataContext  *) dataContext{
    _dataContext = dataContext;
}

- (oneway void)release{
    
    if([self retainCount] == 2 && _dataContext){
        VTDBDataContext * ctx = _dataContext;
        _dataContext = nil;
        [ctx removeDataObject:self];
    }
    
    [super release];
}

+(NSString *) dataKey{
    return @"rowid";
}

-(NSString *) dataKey{
    return [self stringValueForKey:[[self class] dataKey]];
}

@end

@implementation VTDBDataContext

-(void) removeDataObject:(VTDBDataObject *) dataObject{
    
    if(dataObject){
        @synchronized(self) {
            
            Class tableClass = [[dataObject class] tableClass];
            
            NSString * tableName = NSStringFromClass(tableClass);
            
            NSMutableDictionary * table = [_dataTables valueForKey:tableName];
        
            NSString * key = [dataObject stringValueForKey:[tableClass dataKey]];
        
            [table removeObjectForKey:key];
            
        }
    }
}

-(void) dealloc{
    
    for (NSDictionary * table in [_dataTables allValues]) {
        
        for (VTDBDataObject * dataObject in [table allValues]) {
            [dataObject setDataContext:nil];
        }
        
    }
    
    [_updates release];

    [super dealloc];
}

-(id) dataObjectForKey:(NSString *) key tableClass:(Class) tableClass{
    
    VTDBDataObject * dataObject = nil;
    
    @synchronized(self) {
        
        NSString * tableName = NSStringFromClass(tableClass);
        
        NSMutableDictionary * table = [_dataTables valueForKey:tableName];

        dataObject =  [table valueForKey:key];
        
        if(dataObject == nil){
            
            NSString * query = [NSString stringWithFormat:@"SELECT * FROM [%@] WHERE [%@]=:key",NSStringFromClass(tableClass),[tableClass dataKey]];
            
            id<IVTSqliteCursor> cursor = [self.db query:query withData:[NSDictionary dictionaryWithObject:key forKey:@"key"]];

            if([cursor next]){
                
                dataObject = [[[tableClass alloc] init] autorelease];
                
                [cursor toDataObject:dataObject];
                
                if(_dataTables == nil){
                    _dataTables = [[NSMutableDictionary alloc] initWithCapacity:4];
                }
                
                if(table == nil){
                    table = [NSMutableDictionary dictionaryWithCapacity:4];
                    [_dataTables setValue:table forKey:tableName];
                }

                [table setValue:dataObject forKey:key];
                
                [dataObject setDataContext:self];
            }
            
            [cursor close];
        }

    }
    
    return dataObject;
}

-(id) dataObjectForCacheKey:(NSString *) key tableClass:(Class) tableClass{
    
    VTDBDataObject * dataObject = nil;
    
    @synchronized(self) {
        
        NSString * tableName = NSStringFromClass(tableClass);
        
        NSMutableDictionary * table = [_dataTables valueForKey:tableName];
        
        dataObject =  [table valueForKey:key];
    
    }
    
    return dataObject;

}

-(void) setDataObject:(VTDBDataObject *) dataObject{
    
    @synchronized(self) {
        
        Class tableClass = [[dataObject class] tableClass];
        
        NSString * tableName = NSStringFromClass(tableClass);
        
        NSString * key = [dataObject dataKey];
        
        NSMutableDictionary * table = [_dataTables valueForKey:tableName];
        
        VTDBDataObject * object =  [table valueForKey:key];
        
        if(object != dataObject){
            
            if(_dataTables == nil){
                _dataTables = [[NSMutableDictionary alloc] initWithCapacity:4];
            }
            
            if(table == nil){
                table = [NSMutableDictionary dictionaryWithCapacity:4];
                [_dataTables setValue:table forKey:tableName];
            }

            [object setDataContext:nil];
            
            [table setValue:dataObject forKey:key];
            
            [dataObject setDataContext:self];
        }
        
    }
    
    
}

-(BOOL) fillDataObject:(VTDBDataObject *) dataObject{
    
    Class tableClass = [[dataObject class] tableClass];
    
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM [%@] WHERE [%@]=:key",NSStringFromClass(tableClass),[tableClass dataKey]];
    
    id<IVTSqliteCursor> cursor = [self.db query:query withData:dataObject];
    
    BOOL rs = NO;
    
    if([cursor next]){
        [cursor toDataObject:dataObject];
        rs = YES;
    }
    
    [cursor close];
    
    return rs;
}

-(NSSet *) dataObjects:(Class) tableClass{
    
    NSMutableSet * dataObjects = [NSMutableSet setWithCapacity:4];
    
    @synchronized(self) {
        
        NSString * tableName = NSStringFromClass(tableClass);
        
        NSMutableDictionary * table = [_dataTables valueForKey:tableName];

        [dataObjects addObjectsFromArray:[table allValues]];
        
    }
    
    return dataObjects;
}

-(NSArray *) dataKeys:(Class) tableClass query:(NSString *) query data:(id) data{
    
    NSString * sql = [NSString stringWithFormat:@"SELECT [%@] FROM [%@] %@",[tableClass dataKey], NSStringFromClass(tableClass),query == nil ? @"" :query ];
    
    id<IVTSqliteCursor> cursor = [self.db query:sql withData:data];
    
    NSMutableArray * dataKeys = [NSMutableArray arrayWithCapacity:4];
    
    while ([cursor next]) {
        
        NSString * dataKey = [cursor stringValueAtIndex:0];
        
        if(dataKey == nil){
            dataKey = @"";
        }
        
        [dataKeys addObject:dataKey];
    }
    
    [cursor close];
    
    return dataKeys;
}

-(BOOL) insertObject:(VTDBObject *) dbObject{
    
    BOOL rs = [super insertObject:dbObject];
    
    if(rs){
        
        if([dbObject isKindOfClass:[VTDBDataObject class]]){
            
            @synchronized(self) {
                
                Class tableClass = [[dbObject class] tableClass];
                
                NSString * tableName = NSStringFromClass(tableClass);
                
                NSMutableDictionary * table = [_dataTables valueForKey:tableName];
                
                if(_dataTables == nil){
                    _dataTables = [[NSMutableDictionary alloc] initWithCapacity:4];
                }
                
                if(table == nil){
                    table = [NSMutableDictionary dictionaryWithCapacity:4];
                    [_dataTables setValue:table forKey:tableName];
                }
                
                NSString * key = [dbObject stringValueForKey:[tableClass dataKey]];

                [table setValue:dbObject forKey:key];
                
                [(VTDBDataObject *) dbObject setDataContext:self];
                
                [[_updates lastObject] addObject:dbObject];
            }
            
        }
        
    }
    
    return rs;
}

-(BOOL) updateObject:(VTDBObject *)dbObject{
    
    BOOL rs = [super updateObject:dbObject];
    
    if(rs){
        
        if([dbObject isKindOfClass:[VTDBDataObject class]]){
            
            @synchronized(self) {
                [[_updates lastObject] addObject:dbObject];
            }
        
        }
        
    }
    return rs;
}

-(BOOL) deleteObject:(VTDBObject *)dbObject{
    
    BOOL rs = [super deleteObject:dbObject];
    
    if(rs){
        
        if([dbObject isKindOfClass:[VTDBDataObject class]]){
            
            [self removeDataObject:(VTDBDataObject *) dbObject];
            
            
            @synchronized(self) {
                
                dbObject.rowid = 0;
                
                [[_updates lastObject] addObject:dbObject];
            }

        }
        
    }
    return rs;
}

-(void) beginUpdate{
    
    @synchronized(self) {
        
        if(_updates == nil){
            _updates = [[NSMutableArray alloc] initWithCapacity:4];
        }
    
        [_updates addObject:[NSMutableSet setWithCapacity:4]];
    }
    
}

-(void) endUpdate{
    
    NSSet * dataObjects = nil;
    
    @synchronized(self) {
        
        dataObjects = [_updates lastObject];
        
        if(dataObjects){
            [[dataObjects retain] autorelease];
            
            [_updates removeLastObject];
        }
    }
    
    if([dataObjects count]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:VTDBDataObjectChangedNotification object:self userInfo:[NSDictionary dictionaryWithObject:dataObjects forKey:VTDBDataObjectSetKey]];
        
    }
    
}

@end

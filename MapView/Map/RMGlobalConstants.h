/*
 *  RMGlobalConstants.h
 *  MapView
 *
 *  Created by My Home on 4/29/09.
 *  Copyright 2009 Brandon "Quazie" Kwaselow. All rights reserved.
 *
 */

#define kMaxLong 180 
#define kMaxLat 90

static NSString* const METRE = @"METER";
static NSString* const KILOMETER = @"KILOMETER";
static NSString* const MILE = @"MILE";
/*
static NSString* const METRE = @"METRE";
static NSString* const METRE = @"METRE";
static NSString* const METRE = @"METRE";
static NSString* const METRE = @"METRE";
static NSString* const METRE = @"METRE";
static NSString* const METRE = @"METRE";
static NSString* const METRE = @"METRE";
static NSString* const METRE = @"METRE";
static NSString* const METRE = @"METRE";
static NSString* const METRE = @"METRE";
*/
enum MeasureMode {
    DISTANCE = 0,
    AREA
};

static NSString* const GeometryType_LINE = @"LINE";
static NSString* const GeometryType_LINEM = @"LINEM";
static NSString* const GeometryType_POINT = @"POINT";
static NSString* const GeometryType_REGION = @"REGION";
static NSString* const GeometryType_ELLIPSE = @"ELLIPSE";
static NSString* const GeometryType_CIRCLE = @"CIRCLE";
static NSString* const GeometryType_TEXT = @"TEXT";
static NSString* const GeometryType_UNKNOWN = @"UNKNOWN";

static NSString* const EngineType_IMAGEPLUGINS=@"IMAGEPLUGINS";
static NSString* const EngineType_OGC = @"OGC";
static NSString* const EngineType_ORACLEPLUS = @"ORACLEPLUS";
static NSString* const EngineType_SDBPLUS = @"SDBPLUS";
static NSString* const EngineType_SQLPLUS = @"SQLPLUS";
static NSString* const EngineType_UDB = @"UDB";

static NSString* const JoinType_INNERJOIN = @"INNERJOIN";
static NSString* const JoinType_LEFTJOIN = @"LEFTJOIN";

static NSString* const QueryOption_ATTRIBUTE = @"ATTRIBUTE";
static NSString* const QueryOption_ATTRIBUTEANDGEOMETRY = @"ATTRIBUTEANDGEOMETRY";
static NSString* const QueryOption_GEOMETRY = @"GEOMETRY";

static NSString* const  SpatialQueryMode_CONTAIN = @"CONTAIN";
static NSString* const  SpatialQueryMode_CROSS = @"CROSS";
static NSString* const  SpatialQueryMode_DISJOINT = @"DISJOINT";
static NSString* const  SpatialQueryMode_IDENTITY = @"IDENTITY";
static NSString* const  SpatialQueryMode_INTERSECT = @"INTERSECT";
static NSString* const  SpatialQueryMode_NONE = @"NONE";
static NSString* const  SpatialQueryMode_OVERLAP = @"OVERLAP";
static NSString* const  SpatialQueryMode_TOUCH = @"TOUCH";
static NSString* const  SpatialQueryMode_WITHIN = @"WITHIN";

static NSString* const  DATASET_AND_RECORDSET = @"DATASET_AND_RECORDSET";
static NSString* const  DATASET_ONLY = @"DATASET_ONLY";
static NSString* const  RECORDSET_ONLY = @"RECORDSET_ONLY";



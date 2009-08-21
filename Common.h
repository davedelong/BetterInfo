//
//  Common.h
//  BetterInfo
//
//  Created by Dave DeLong on 8/19/09.
//  Copyright 2009 Home. All rights reserved.
//

struct BIItemSize {
	UInt64 dataLogicalSize;
	UInt64 resourceLogicalSize;
	UInt64 logicalSize;
	UInt64 dataPhysicalSize;
	UInt64 resourcePhysicalSize;
	UInt64 physicalSize;
	UInt64 fileCount;
};

typedef struct BIItemSize            BIItemSize;

#define BIItemSizeClearSize(s) s.fileCount = s.dataLogicalSize = s.dataPhysicalSize = s.resourceLogicalSize = s.resourcePhysicalSize = s.logicalSize = s.physicalSize = 0
#define BIItemSizeAddSizes(s, r){ \
s.dataLogicalSize += r.dataLogicalSize;\
s.dataPhysicalSize += r.dataPhysicalSize;\
s.resourceLogicalSize += r.resourceLogicalSize;\
s.resourcePhysicalSize += r.resourcePhysicalSize;\
s.logicalSize += r.logicalSize;\
s.physicalSize += r.physicalSize;\
s.fileCount += r.fileCount;\
}
#define BIItemSizeAddCatalogInfo(s,i){ \
s.dataLogicalSize += i.dataLogicalSize;\
s.dataPhysicalSize += i.dataPhysicalSize;\
s.resourceLogicalSize += i.rsrcLogicalSize;\
s.resourcePhysicalSize += i.rsrcPhysicalSize;\
s.logicalSize += i.dataLogicalSize + i.rsrcLogicalSize;\
s.physicalSize += i.dataPhysicalSize + i.rsrcPhysicalSize;\
s.fileCount++;\
}

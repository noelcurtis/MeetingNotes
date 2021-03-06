/**
 * Autogenerated by Thrift
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 */

#import <Foundation/Foundation.h>

#import <TProtocol.h>
#import <TApplicationException.h>
#import <TProtocolUtil.h>
#import <TProcessor.h>

#import "UserStore.h"
#import "Types.h"
#import "Errors.h"
#import "Limits.h"

@interface EDAMSyncState : NSObject <NSCoding> {
  EDAMTimestamp __currentTime;
  EDAMTimestamp __fullSyncBefore;
  int32_t __updateCount;
  int64_t __uploaded;

  BOOL __currentTime_isset;
  BOOL __fullSyncBefore_isset;
  BOOL __updateCount_isset;
  BOOL __uploaded_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=currentTime, setter=setCurrentTime:) EDAMTimestamp currentTime;
@property (nonatomic, getter=fullSyncBefore, setter=setFullSyncBefore:) EDAMTimestamp fullSyncBefore;
@property (nonatomic, getter=updateCount, setter=setUpdateCount:) int32_t updateCount;
@property (nonatomic, getter=uploaded, setter=setUploaded:) int64_t uploaded;
#endif

- (id) initWithCurrentTime: (EDAMTimestamp) currentTime fullSyncBefore: (EDAMTimestamp) fullSyncBefore updateCount: (int32_t) updateCount uploaded: (int64_t) uploaded;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (EDAMTimestamp) currentTime;
- (void) setCurrentTime: (EDAMTimestamp) currentTime;
- (BOOL) currentTimeIsSet;

- (EDAMTimestamp) fullSyncBefore;
- (void) setFullSyncBefore: (EDAMTimestamp) fullSyncBefore;
- (BOOL) fullSyncBeforeIsSet;

- (int32_t) updateCount;
- (void) setUpdateCount: (int32_t) updateCount;
- (BOOL) updateCountIsSet;

- (int64_t) uploaded;
- (void) setUploaded: (int64_t) uploaded;
- (BOOL) uploadedIsSet;

@end

@interface EDAMSyncChunk : NSObject <NSCoding> {
  EDAMTimestamp __currentTime;
  int32_t __chunkHighUSN;
  int32_t __updateCount;
  NSArray * __notes;
  NSArray * __notebooks;
  NSArray * __tags;
  NSArray * __searches;
  NSArray * __resources;
  NSArray * __expungedNotes;
  NSArray * __expungedNotebooks;
  NSArray * __expungedTags;
  NSArray * __expungedSearches;

  BOOL __currentTime_isset;
  BOOL __chunkHighUSN_isset;
  BOOL __updateCount_isset;
  BOOL __notes_isset;
  BOOL __notebooks_isset;
  BOOL __tags_isset;
  BOOL __searches_isset;
  BOOL __resources_isset;
  BOOL __expungedNotes_isset;
  BOOL __expungedNotebooks_isset;
  BOOL __expungedTags_isset;
  BOOL __expungedSearches_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=currentTime, setter=setCurrentTime:) EDAMTimestamp currentTime;
@property (nonatomic, getter=chunkHighUSN, setter=setChunkHighUSN:) int32_t chunkHighUSN;
@property (nonatomic, getter=updateCount, setter=setUpdateCount:) int32_t updateCount;
@property (nonatomic, retain, getter=notes, setter=setNotes:) NSArray * notes;
@property (nonatomic, retain, getter=notebooks, setter=setNotebooks:) NSArray * notebooks;
@property (nonatomic, retain, getter=tags, setter=setTags:) NSArray * tags;
@property (nonatomic, retain, getter=searches, setter=setSearches:) NSArray * searches;
@property (nonatomic, retain, getter=resources, setter=setResources:) NSArray * resources;
@property (nonatomic, retain, getter=expungedNotes, setter=setExpungedNotes:) NSArray * expungedNotes;
@property (nonatomic, retain, getter=expungedNotebooks, setter=setExpungedNotebooks:) NSArray * expungedNotebooks;
@property (nonatomic, retain, getter=expungedTags, setter=setExpungedTags:) NSArray * expungedTags;
@property (nonatomic, retain, getter=expungedSearches, setter=setExpungedSearches:) NSArray * expungedSearches;
#endif

- (id) initWithCurrentTime: (EDAMTimestamp) currentTime chunkHighUSN: (int32_t) chunkHighUSN updateCount: (int32_t) updateCount notes: (NSArray *) notes notebooks: (NSArray *) notebooks tags: (NSArray *) tags searches: (NSArray *) searches resources: (NSArray *) resources expungedNotes: (NSArray *) expungedNotes expungedNotebooks: (NSArray *) expungedNotebooks expungedTags: (NSArray *) expungedTags expungedSearches: (NSArray *) expungedSearches;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (EDAMTimestamp) currentTime;
- (void) setCurrentTime: (EDAMTimestamp) currentTime;
- (BOOL) currentTimeIsSet;

- (int32_t) chunkHighUSN;
- (void) setChunkHighUSN: (int32_t) chunkHighUSN;
- (BOOL) chunkHighUSNIsSet;

- (int32_t) updateCount;
- (void) setUpdateCount: (int32_t) updateCount;
- (BOOL) updateCountIsSet;

- (NSArray *) notes;
- (void) setNotes: (NSArray *) notes;
- (BOOL) notesIsSet;

- (NSArray *) notebooks;
- (void) setNotebooks: (NSArray *) notebooks;
- (BOOL) notebooksIsSet;

- (NSArray *) tags;
- (void) setTags: (NSArray *) tags;
- (BOOL) tagsIsSet;

- (NSArray *) searches;
- (void) setSearches: (NSArray *) searches;
- (BOOL) searchesIsSet;

- (NSArray *) resources;
- (void) setResources: (NSArray *) resources;
- (BOOL) resourcesIsSet;

- (NSArray *) expungedNotes;
- (void) setExpungedNotes: (NSArray *) expungedNotes;
- (BOOL) expungedNotesIsSet;

- (NSArray *) expungedNotebooks;
- (void) setExpungedNotebooks: (NSArray *) expungedNotebooks;
- (BOOL) expungedNotebooksIsSet;

- (NSArray *) expungedTags;
- (void) setExpungedTags: (NSArray *) expungedTags;
- (BOOL) expungedTagsIsSet;

- (NSArray *) expungedSearches;
- (void) setExpungedSearches: (NSArray *) expungedSearches;
- (BOOL) expungedSearchesIsSet;

@end

@interface EDAMNoteFilter : NSObject <NSCoding> {
  int32_t __order;
  BOOL __ascending;
  NSString * __words;
  EDAMGuid __notebookGuid;
  NSArray * __tagGuids;
  NSString * __timeZone;
  BOOL __inactive;

  BOOL __order_isset;
  BOOL __ascending_isset;
  BOOL __words_isset;
  BOOL __notebookGuid_isset;
  BOOL __tagGuids_isset;
  BOOL __timeZone_isset;
  BOOL __inactive_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=order, setter=setOrder:) int32_t order;
@property (nonatomic, getter=ascending, setter=setAscending:) BOOL ascending;
@property (nonatomic, retain, getter=words, setter=setWords:) NSString * words;
@property (nonatomic, retain, getter=notebookGuid, setter=setNotebookGuid:) EDAMGuid notebookGuid;
@property (nonatomic, retain, getter=tagGuids, setter=setTagGuids:) NSArray * tagGuids;
@property (nonatomic, retain, getter=timeZone, setter=setTimeZone:) NSString * timeZone;
@property (nonatomic, getter=inactive, setter=setInactive:) BOOL inactive;
#endif

- (id) initWithOrder: (int32_t) order ascending: (BOOL) ascending words: (NSString *) words notebookGuid: (EDAMGuid) notebookGuid tagGuids: (NSArray *) tagGuids timeZone: (NSString *) timeZone inactive: (BOOL) inactive;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (int32_t) order;
- (void) setOrder: (int32_t) order;
- (BOOL) orderIsSet;

- (BOOL) ascending;
- (void) setAscending: (BOOL) ascending;
- (BOOL) ascendingIsSet;

- (NSString *) words;
- (void) setWords: (NSString *) words;
- (BOOL) wordsIsSet;

- (EDAMGuid) notebookGuid;
- (void) setNotebookGuid: (EDAMGuid) notebookGuid;
- (BOOL) notebookGuidIsSet;

- (NSArray *) tagGuids;
- (void) setTagGuids: (NSArray *) tagGuids;
- (BOOL) tagGuidsIsSet;

- (NSString *) timeZone;
- (void) setTimeZone: (NSString *) timeZone;
- (BOOL) timeZoneIsSet;

- (BOOL) inactive;
- (void) setInactive: (BOOL) inactive;
- (BOOL) inactiveIsSet;

@end

@interface EDAMNoteList : NSObject <NSCoding> {
  int32_t __startIndex;
  int32_t __totalNotes;
  NSArray * __notes;
  NSArray * __stoppedWords;
  NSArray * __searchedWords;

  BOOL __startIndex_isset;
  BOOL __totalNotes_isset;
  BOOL __notes_isset;
  BOOL __stoppedWords_isset;
  BOOL __searchedWords_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=startIndex, setter=setStartIndex:) int32_t startIndex;
@property (nonatomic, getter=totalNotes, setter=setTotalNotes:) int32_t totalNotes;
@property (nonatomic, retain, getter=notes, setter=setNotes:) NSArray * notes;
@property (nonatomic, retain, getter=stoppedWords, setter=setStoppedWords:) NSArray * stoppedWords;
@property (nonatomic, retain, getter=searchedWords, setter=setSearchedWords:) NSArray * searchedWords;
#endif

- (id) initWithStartIndex: (int32_t) startIndex totalNotes: (int32_t) totalNotes notes: (NSArray *) notes stoppedWords: (NSArray *) stoppedWords searchedWords: (NSArray *) searchedWords;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (int32_t) startIndex;
- (void) setStartIndex: (int32_t) startIndex;
- (BOOL) startIndexIsSet;

- (int32_t) totalNotes;
- (void) setTotalNotes: (int32_t) totalNotes;
- (BOOL) totalNotesIsSet;

- (NSArray *) notes;
- (void) setNotes: (NSArray *) notes;
- (BOOL) notesIsSet;

- (NSArray *) stoppedWords;
- (void) setStoppedWords: (NSArray *) stoppedWords;
- (BOOL) stoppedWordsIsSet;

- (NSArray *) searchedWords;
- (void) setSearchedWords: (NSArray *) searchedWords;
- (BOOL) searchedWordsIsSet;

@end

@interface EDAMNoteCollectionCounts : NSObject <NSCoding> {
  NSDictionary * __notebookCounts;
  NSDictionary * __tagCounts;
  int32_t __trashCount;

  BOOL __notebookCounts_isset;
  BOOL __tagCounts_isset;
  BOOL __trashCount_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=notebookCounts, setter=setNotebookCounts:) NSDictionary * notebookCounts;
@property (nonatomic, retain, getter=tagCounts, setter=setTagCounts:) NSDictionary * tagCounts;
@property (nonatomic, getter=trashCount, setter=setTrashCount:) int32_t trashCount;
#endif

- (id) initWithNotebookCounts: (NSDictionary *) notebookCounts tagCounts: (NSDictionary *) tagCounts trashCount: (int32_t) trashCount;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (NSDictionary *) notebookCounts;
- (void) setNotebookCounts: (NSDictionary *) notebookCounts;
- (BOOL) notebookCountsIsSet;

- (NSDictionary *) tagCounts;
- (void) setTagCounts: (NSDictionary *) tagCounts;
- (BOOL) tagCountsIsSet;

- (int32_t) trashCount;
- (void) setTrashCount: (int32_t) trashCount;
- (BOOL) trashCountIsSet;

@end

@interface EDAMAdImpressions : NSObject <NSCoding> {
  int32_t __adId;
  int32_t __impressionCount;
  int32_t __impressionTime;

  BOOL __adId_isset;
  BOOL __impressionCount_isset;
  BOOL __impressionTime_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=adId, setter=setAdId:) int32_t adId;
@property (nonatomic, getter=impressionCount, setter=setImpressionCount:) int32_t impressionCount;
@property (nonatomic, getter=impressionTime, setter=setImpressionTime:) int32_t impressionTime;
#endif

- (id) initWithAdId: (int32_t) adId impressionCount: (int32_t) impressionCount impressionTime: (int32_t) impressionTime;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (int32_t) adId;
- (void) setAdId: (int32_t) adId;
- (BOOL) adIdIsSet;

- (int32_t) impressionCount;
- (void) setImpressionCount: (int32_t) impressionCount;
- (BOOL) impressionCountIsSet;

- (int32_t) impressionTime;
- (void) setImpressionTime: (int32_t) impressionTime;
- (BOOL) impressionTimeIsSet;

@end

@interface EDAMAdParameters : NSObject <NSCoding> {
  NSString * __clientLanguage;
  NSArray * __impressions;
  BOOL __supportHtml;
  NSDictionary * __clientProperties;

  BOOL __clientLanguage_isset;
  BOOL __impressions_isset;
  BOOL __supportHtml_isset;
  BOOL __clientProperties_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=clientLanguage, setter=setClientLanguage:) NSString * clientLanguage;
@property (nonatomic, retain, getter=impressions, setter=setImpressions:) NSArray * impressions;
@property (nonatomic, getter=supportHtml, setter=setSupportHtml:) BOOL supportHtml;
@property (nonatomic, retain, getter=clientProperties, setter=setClientProperties:) NSDictionary * clientProperties;
#endif

- (id) initWithClientLanguage: (NSString *) clientLanguage impressions: (NSArray *) impressions supportHtml: (BOOL) supportHtml clientProperties: (NSDictionary *) clientProperties;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (NSString *) clientLanguage;
- (void) setClientLanguage: (NSString *) clientLanguage;
- (BOOL) clientLanguageIsSet;

- (NSArray *) impressions;
- (void) setImpressions: (NSArray *) impressions;
- (BOOL) impressionsIsSet;

- (BOOL) supportHtml;
- (void) setSupportHtml: (BOOL) supportHtml;
- (BOOL) supportHtmlIsSet;

- (NSDictionary *) clientProperties;
- (void) setClientProperties: (NSDictionary *) clientProperties;
- (BOOL) clientPropertiesIsSet;

@end

@interface EDAMNoteEmailParameters : NSObject <NSCoding> {
  NSString * __guid;
  EDAMNote * __note;
  NSArray * __toAddresses;
  NSArray * __ccAddresses;
  NSString * __subject;
  NSString * __message;

  BOOL __guid_isset;
  BOOL __note_isset;
  BOOL __toAddresses_isset;
  BOOL __ccAddresses_isset;
  BOOL __subject_isset;
  BOOL __message_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, retain, getter=guid, setter=setGuid:) NSString * guid;
@property (nonatomic, retain, getter=note, setter=setNote:) EDAMNote * note;
@property (nonatomic, retain, getter=toAddresses, setter=setToAddresses:) NSArray * toAddresses;
@property (nonatomic, retain, getter=ccAddresses, setter=setCcAddresses:) NSArray * ccAddresses;
@property (nonatomic, retain, getter=subject, setter=setSubject:) NSString * subject;
@property (nonatomic, retain, getter=message, setter=setMessage:) NSString * message;
#endif

- (id) initWithGuid: (NSString *) guid note: (EDAMNote *) note toAddresses: (NSArray *) toAddresses ccAddresses: (NSArray *) ccAddresses subject: (NSString *) subject message: (NSString *) message;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (NSString *) guid;
- (void) setGuid: (NSString *) guid;
- (BOOL) guidIsSet;

- (EDAMNote *) note;
- (void) setNote: (EDAMNote *) note;
- (BOOL) noteIsSet;

- (NSArray *) toAddresses;
- (void) setToAddresses: (NSArray *) toAddresses;
- (BOOL) toAddressesIsSet;

- (NSArray *) ccAddresses;
- (void) setCcAddresses: (NSArray *) ccAddresses;
- (BOOL) ccAddressesIsSet;

- (NSString *) subject;
- (void) setSubject: (NSString *) subject;
- (BOOL) subjectIsSet;

- (NSString *) message;
- (void) setMessage: (NSString *) message;
- (BOOL) messageIsSet;

@end

@protocol EDAMNoteStore <NSObject>
- (EDAMSyncState *) getSyncState: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMSyncChunk *) getSyncChunk: (NSString *) authenticationToken : (int32_t) afterUSN : (int32_t) maxEntries : (BOOL) fullSyncOnly;  // throws EDAMUserException *, EDAMSystemException *, TException
- (NSArray *) listNotebooks: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMNotebook *) getNotebook: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNotebook *) getDefaultNotebook: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMNotebook *) createNotebook: (NSString *) authenticationToken : (EDAMNotebook *) notebook;  // throws EDAMUserException *, EDAMSystemException *, TException
- (int32_t) updateNotebook: (NSString *) authenticationToken : (EDAMNotebook *) notebook;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) expungeNotebook: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSArray *) listTags: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (NSArray *) listTagsByNotebook: (NSString *) authenticationToken : (EDAMGuid) notebookGuid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMTag *) getTag: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMTag *) createTag: (NSString *) authenticationToken : (EDAMTag *) tag;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) updateTag: (NSString *) authenticationToken : (EDAMTag *) tag;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (void) untagAll: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) expungeTag: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSArray *) listSearches: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMSavedSearch *) getSearch: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMSavedSearch *) createSearch: (NSString *) authenticationToken : (EDAMSavedSearch *) search;  // throws EDAMUserException *, EDAMSystemException *, TException
- (int32_t) updateSearch: (NSString *) authenticationToken : (EDAMSavedSearch *) search;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) expungeSearch: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNoteList *) findNotes: (NSString *) authenticationToken : (EDAMNoteFilter *) filter : (int32_t) offset : (int32_t) maxNotes;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMNoteCollectionCounts *) findNoteCounts: (NSString *) authenticationToken : (EDAMNoteFilter *) filter : (BOOL) withTrash;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMNote *) getNote: (NSString *) authenticationToken : (EDAMGuid) guid : (BOOL) withContent : (BOOL) withResourcesData : (BOOL) withResourcesRecognition : (BOOL) withResourcesAlternateData;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSString *) getNoteContent: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSString *) getNoteSearchText: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSArray *) getNoteTagNames: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNote *) createNote: (NSString *) authenticationToken : (EDAMNote *) note;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMNote *) updateNote: (NSString *) authenticationToken : (EDAMNote *) note;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) expungeNote: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) expungeNotes: (NSString *) authenticationToken : (NSArray *) noteGuids;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) expungeInactiveNotes: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMNote *) copyNote: (NSString *) authenticationToken : (EDAMGuid) noteGuid : (EDAMGuid) toNotebookGuid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMResource *) getResource: (NSString *) authenticationToken : (EDAMGuid) guid : (BOOL) withData : (BOOL) withRecognition : (BOOL) withAttributes : (BOOL) withAlternateData;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int32_t) updateResource: (NSString *) authenticationToken : (EDAMResource *) resource;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSData *) getResourceData: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMResource *) getResourceByHash: (NSString *) authenticationToken : (EDAMGuid) noteGuid : (NSData *) contentHash : (BOOL) withData : (BOOL) withRecognition : (BOOL) withAlternateData;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSData *) getResourceRecognition: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (NSData *) getResourceAlternateData: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMResourceAttributes *) getResourceAttributes: (NSString *) authenticationToken : (EDAMGuid) guid;  // throws EDAMUserException *, EDAMSystemException *, EDAMNotFoundException *, TException
- (int64_t) getAccountSize: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMSystemException *, TException
- (NSArray *) getAds: (NSString *) authenticationToken : (EDAMAdParameters *) adParameters;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMAd *) getRandomAd: (NSString *) authenticationToken : (EDAMAdParameters *) adParameters;  // throws EDAMUserException *, EDAMSystemException *, TException
- (EDAMNotebook *) getPublicNotebook: (EDAMUserID) userId : (NSString *) publicUri;  // throws EDAMSystemException *, EDAMNotFoundException *, TException
- (EDAMSharedNotebook *) createSharedNotebook: (NSString *) authenticationToken : (EDAMSharedNotebook *) sharedNotebook;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (NSArray *) listSharedNotebooks: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (int32_t) expungeSharedNotebooks: (NSString *) authenticationToken : (NSArray *) sharedNotebookIds;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (EDAMLinkedNotebook *) createLinkedNotebook: (NSString *) authenticationToken : (EDAMLinkedNotebook *) linkedNotebook;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (EDAMLinkedNotebook *) updateLinkedNotebook: (NSString *) authenticationToken : (EDAMLinkedNotebook *) linkedNotebook;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (NSArray *) listLinkedNotebooks: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (int32_t) expungeLinkedNotebook: (NSString *) authenticationToken : (int64_t) linkedNotebookId;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (EDAMAuthenticationResult *) authenticateToSharedNotebook: (NSString *) shareKey : (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (EDAMSharedNotebook *) getSharedNotebookByAuth: (NSString *) authenticationToken;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
- (void) emailNote: (NSString *) authenticationToken : (EDAMNoteEmailParameters *) parameters;  // throws EDAMUserException *, EDAMNotFoundException *, EDAMSystemException *, TException
@end

@interface EDAMNoteStoreClient : NSObject <EDAMNoteStore> {
  id <TProtocol> inProtocol;
  id <TProtocol> outProtocol;
}
- (id) initWithProtocol: (id <TProtocol>) protocol;
- (id) initWithInProtocol: (id <TProtocol>) inProtocol outProtocol: (id <TProtocol>) outProtocol;
@end

@interface EDAMNoteStoreProcessor : NSObject <TProcessor> {
  id <EDAMNoteStore> mService;
  NSDictionary * mMethodMap;
}
- (id) initWithNoteStore: (id <EDAMNoteStore>) service;
- (id<EDAMNoteStore>) service;
@end

@interface EDAMNoteStoreConstants : NSObject {
}
@end

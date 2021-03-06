#Version 82.0.1, August 20 2018

#Set your paths here.
ZLIB_PATH = ./src/zlib-1.2.8
MZPARSER_PATH = ./src/mzParser
EXPAT_PATH = ./src/expat-2.2.0
SQLITE_PATH = ./src/sqlite-3.7.7.1
MST_PATH = ./src/MSToolkit
MZIMLTOOLS_PATH = ./src/mzIMLTools

HEADER_PATH = ./include

MZPARSER = mzp.MSNumpress.o mzp.mzp_base64.o mzp.BasicSpectrum.o mzp.mzParser.o mzp.RAMPface.o mzp.saxhandler.o mzp.saxmzmlhandler.o \
	mzp.saxmzxmlhandler.o mzp.Czran.o mzp.mz5handler.o mzp.mzpMz5Config.o mzp.mzpMz5Structs.o mzp.BasicChromatogram.o mzp.PWIZface.o
MZPARSERLITE = mzp.MSNumpress.o mzp.mzp_base64_lite.o mzp.BasicSpectrum_lite.o mzp.mzParser_lite.o mzp.RAMPface_lite.o mzp.saxhandler_lite.o mzp.saxmzmlhandler_lite.o \
  mzp.saxmzxmlhandler_lite.o mzp.Czran_lite.o mzp.mz5handler_lite.o mzp.mzpMz5Config_lite.o mzp.mzpMz5Structs_lite.o mzp.BasicChromatogram_lite.o mzp.PWIZface_lite.o
MZIMLTOOLS = mzid.CAdditionalSearchParams.o mzid.CAnalysisCollection.o mzid.CAnalysisData.o mzid.CAnalysisParams.o mzid.CAnalysisProtocolCollection.o \
             mzid.CAnalysisSoftware.o mzid.CAnalysisSoftwareList.o mzid.CContactRole.o mzid.CCvList.o mzid.CDatabaseName.o mzid.CDataCollection.o mzid.CDBSequence.o \
             mzid.CFileFormat.o mzid.CFragmentArray.o mzid.CFragmentation.o mzid.CFragmentationTable.o mzid.CInputs.o mzid.CIonType.o mzid.CMeasure.o \
             mzid.CModification.o mzid.CModificationParams.o mzid.CMzIdentML.o mzid.CPeptide.o mzid.CPeptideEvidence.o mzid.CPeptideHypothesis.o \
             mzid.CProteinAmbiguityGroup.o mzid.CProteinDetection.o mzid.CProteinDetectionHypothesis.o  mzid.CProteinDetectionList.o mzid.CProteinDetectionProtocol.o \
             mzid.CPSM.o mzid.CRole.o mzid.CSearchDatabase.o mzid.CSearchModification.o mzid.CSearchType.o mzid.CSequenceCollection.o mzid.CSoftwareName.o \
             mzid.CSourceFile.o mzid.CSpecificityRules.o mzid.CSpectraData.o mzid.CSpectrumIdentification.o mzid.CSpectrumIdentificationItem.o \
             mzid.CSpectrumIdentificationList.o mzid.CSpectrumIdentificationProtocol.o mzid.CSpectrumIdentificationResult.o mzid.CSpectrumIDFormat.o \
             mzid.CThreshold.o
EXPAT = xmlparse.o xmlrole.o xmltok.o
ZLIB = adler32.o compress.o crc32.o deflate.o inffast.o inflate.o infback.o inftrees.o trees.o uncompr.o zutil.o
MSTOOLKIT = Spectrum.o MSObject.o mzMLWriter.o pepXMLWriter.o
READER = MSReader.o
READERLITE = MSReaderLite.o
SQLITE = sqlite3.o 

CC = g++
GCC = gcc
NOSQLITE = -D_NOSQLITE

SOVER = 82
RELVER = $(SOVER).0.1

AR_CFLAGS = -O3 -static -I. -I$(HEADER_PATH) -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DGCC -DHAVE_EXPAT_CONFIG_H
SO_CFLAGS = -O3 -shared -fPIC -g -I. -I$(HEADER_PATH) -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DGCC -DHAVE_EXPAT_CONFIG_H
LIBS = -lm -lpthread
CLEAN_LIBS = libmstoolkitlite.lib libmstoolkitlite.dll libmstoolkitlite.dll.$(SOVER)* libmstoolkit.lib libmstoolkit.dll libmstoolkit.dll.$(SOVER)*

all: 
	make arlib 
	make solib
	

.PHONY: objects
objects: $(ZLIB) $(MZPARSER) $(MZPARSERLITE) $(MZIMLTOOLS) $(MSTOOLKIT) $(READER) $(READERLITE) $(EXPAT) $(SQLITE)

arlib: CFLAGS = $(AR_CFLAGS)
arlib: clean_objects objects
	ar rcs libmstoolkitlite.lib $(ZLIB) $(EXPAT) $(MZIMLTOOLS) $(MZPARSERLITE) $(MSTOOLKIT) $(READERLITE)
	ar rcs libmstoolkit.lib $(ZLIB) $(EXPAT) $(MZIMLTOOLS) $(MZPARSER) $(MSTOOLKIT) $(READER) $(SQLITE)
#	$(CC) $(CFLAGS) MSTDemo.cpp -L. -lmstoolkitlite -o MSTDemo
	$(CC) $(CFLAGS) -I./include MSSingleScan/MSSingleScan.cpp -L. -llibmstoolkitlite -o msSingleScan
#	$(CC) $(CFLAGS) MSConvertFile.cpp -L. -lmstoolkitlite -o MSConvertFile

solib: CFLAGS = $(SO_CFLAGS)
solib: clean_objects objects 
	$(CC) $(CFLAGS) -o libmstoolkitlite.dll.$(RELVER) -Wl,-soname,libmstoolkitlite.dll.$(SOVER) $(LIBS) $(ZLIB) $(EXPAT) $(MZIMLTOOLS) $(MZPARSERLITE) $(MSTOOLKIT) $(READERLITE)
	ln -sf libmstoolkitlite.dll.$(RELVER) libmstoolkitlite.dll.$(SOVER)
	ln -sf libmstoolkitlite.dll.$(SOVER) libmstoolkitlite.dll
	$(CC) $(CFLAGS) -o libmstoolkit.dll.$(RELVER) -Wl,-soname,libmstoolkit.dll.$(SOVER) $(LIBS) $(ZLIB) $(EXPAT) $(MZIMLTOOLS) $(MZPARSER) $(MSTOOLKIT) $(READER) $(SQLITE)
	ln -sf libmstoolkit.dll.$(RELVER) libmstoolkit.dll.$(SOVER)
	ln -sf libmstoolkit.dll.$(SOVER) libmstoolkit.dll
	# Be careful not to include in the linker command line below the compilation -shared -fPIC flags!
	$(CC) -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DGCC -DHAVE_EXPAT_CONFIG_H -I./include -L. MSSingleScan/MSSingleScan.cpp -lmstoolkitlite -o msSingleScan.exe 

clean_objects: 
	rm -f *.o msSingleScan.*

clean_libs: 
	rm -f $(CLEAN_LIBS)

clean: clean_libs clean_objects

# zLib objects

adler32.o : $(ZLIB_PATH)/adler32.c
	$(GCC) $(CFLAGS) $(ZLIB_PATH)/adler32.c -c

compress.o : $(ZLIB_PATH)/compress.c
	$(GCC) $(CFLAGS) $(ZLIB_PATH)/compress.c -c

crc32.o : $(ZLIB_PATH)/crc32.c
	$(GCC) $(CFLAGS) $(ZLIB_PATH)/crc32.c -c

deflate.o : $(ZLIB_PATH)/deflate.c
	$(GCC) $(CFLAGS) $(ZLIB_PATH)/deflate.c -c

inffast.o : $(ZLIB_PATH)/inffast.c
	$(GCC) $(CFLAGS) $(ZLIB_PATH)/inffast.c -c

inflate.o : $(ZLIB_PATH)/inflate.c
	$(GCC) $(CFLAGS) $(ZLIB_PATH)/inflate.c -c

infback.o : $(ZLIB_PATH)/infback.c
	$(GCC) $(CFLAGS) $(ZLIB_PATH)/infback.c -c

inftrees.o : $(ZLIB_PATH)/inftrees.c
	$(GCC) $(CFLAGS) $(ZLIB_PATH)/inftrees.c -c

trees.o : $(ZLIB_PATH)/trees.c
	$(GCC) $(CFLAGS) $(ZLIB_PATH)/trees.c -c

uncompr.o : $(ZLIB_PATH)/uncompr.c
	$(GCC) $(CFLAGS) $(ZLIB_PATH)/uncompr.c -c

zutil.o : $(ZLIB_PATH)/zutil.c
	$(GCC) $(CFLAGS) $(ZLIB_PATH)/zutil.c -c



#mzParser objects
mzp.%.o : $(MZPARSER_PATH)/%.cpp
	$(CC) $(CFLAGS) $(MZ5) $< -c -o $@

#mzParserLite objects
mzp.%_lite.o : $(MZPARSER_PATH)/%.cpp
	$(CC) $(CFLAGS) $< -c -o $@


#expat objects
xmlparse.o : $(EXPAT_PATH)/xmlparse.c
	$(GCC) $(CFLAGS) $(EXPAT_PATH)/xmlparse.c -c
xmlrole.o : $(EXPAT_PATH)/xmlrole.c
	$(GCC) $(CFLAGS) $(EXPAT_PATH)/xmlrole.c -c
xmltok.o : $(EXPAT_PATH)/xmltok.c
	$(GCC) $(CFLAGS) $(EXPAT_PATH)/xmltok.c -c



#SQLite object
sqlite3.o : $(SQLITE_PATH)/sqlite3.c
	$(GCC) $(CFLAGS) $(SQLITE_PATH)/sqlite3.c -c


#mzIMLTools objects
mzid.%.o : $(MZIMLTOOLS_PATH)/%.cpp
	$(CC) $(CFLAGS) $< -c -o $@


#MSToolkit objects

Spectrum.o : $(MST_PATH)/Spectrum.cpp
	$(CC) $(CFLAGS) $(MST_PATH)/Spectrum.cpp -c

MSReader.o : $(MST_PATH)/MSReader.cpp
	$(CC) $(CFLAGS) $(MZ5) $(MST_PATH)/MSReader.cpp -c

MSReaderLite.o : $(MST_PATH)/MSReader.cpp
	$(CC) $(CFLAGS) $(NOSQLITE) $(MST_PATH)/MSReader.cpp -c -o MSReaderLite.o

MSObject.o : $(MST_PATH)/MSObject.cpp
	$(CC) $(CFLAGS) $(MST_PATH)/MSObject.cpp -c

mzMLWriter.o : $(MST_PATH)/mzMLWriter.cpp
	$(CC) $(CFLAGS) $(MST_PATH)/mzMLWriter.cpp -c
	
pepXMLWriter.o : $(MST_PATH)/pepXMLWriter.cpp
	$(CC) $(CFLAGS) $(MST_PATH)/pepXMLWriter.cpp -c






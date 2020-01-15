#
# GNU makefile for hough3d-IPOL
#==============================


# compiler settings
#--------------------------------

# this will restrict size of Hough space and point cloud for the IPOL demo
# do NOT enable it for production use!
#DEMOMODE = -DWEBDEMO

# include directory of libeigen
LIBEIGEN = /usr/include/eigen3

# settings for GNU C compiler
CC = g++
#CFLAGS = -Wall -g -I$(LIBEIGEN) $(DEMOMODE)
CFLAGS = -Wall -O3 -I$(LIBEIGEN) $(DEMOMODE)
LDFLAGS = -lstdc++


# from here on, no alterations
# should be necessary
#----------------------------------

PROGRAM = hough3dlines
OBJECTS = hough.o  pointcloud.o  sphere.o  vector3d.o
TGZDIR = hough3d-src

all: $(PROGRAM)

$(PROGRAM): $(PROGRAM).o $(OBJECTS)
	$(CC) -o $@ $+ $(LDFLAGS)

$(PROGRAM).o: $(PROGRAM).cpp
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $*.cpp

%.o: %.cpp %.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $*.cpp

tags: *.cpp *.h
	etags *.cpp *.h

test: testdata.dat $(PROGRAM)
	$(PROGRAM) $< -dx 0.4

clean:
	rm -f *.o $(PROGRAM)

tgz:
	ln -s . $(TGZDIR)
	tar cvzf $(TGZDIR).tgz \
		$(TGZDIR)/*.cpp $(TGZDIR)/*.h $(TGZDIR)/testdata.dat \
		$(TGZDIR)/README $(TGZDIR)/LICENSE-BSD2 $(TGZDIR)/Makefile $(TGZDIR)/CHANGES
	rm $(TGZDIR)

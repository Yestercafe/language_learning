cc           := g++
ccflags      := -std=c++11 -Wall
object_files := LinkedListDemo

prj: ${object_files}

LinkedListDemo: LinkedListDemo.cpp LinkedList.hpp
	${cc} ${ccflags} -o $@ LinkedListDemo.cpp

.PHONY:
clean:
	rm -f ${object_files}
bfs: bfs.cpp
	g++ graphio.c -c -O3
	g++ mmio.c -c -O3
#	gcc graph.c -c -O3
	nvcc -O3 -c cudabfs.cu
	g++ bfs.cpp -fopenmp -c -O3
	g++ -o bfs bfs.o mmio.o graphio.o cudabfs.o -O3 -lcuda -lcudart -L/usr/local/cuda/lib64/ -fpermissive
clean:
	rm -f bfs *.o

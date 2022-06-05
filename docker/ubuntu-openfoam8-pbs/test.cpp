#include <stdio.h>
#include <iostream>
#include <mpi.h>


int main ( int argc, char** argv ) {

	// declaring
	int numproc=1, myrank=0;

	// MPI initialization
	if ( MPI_Init(&argc, &argv) != MPI_SUCCESS )
		MPI_Abort(MPI_COMM_WORLD, 1);

	// get num of processes and my rank
	MPI_Comm_size(MPI_COMM_WORLD, &numproc);
	MPI_Comm_rank(MPI_COMM_WORLD, &myrank);

	std::cout << "test: proc id = " << myrank << " / " << numproc << std::endl;

	// MPI finalization
	MPI_Finalize();
	return 0;
}

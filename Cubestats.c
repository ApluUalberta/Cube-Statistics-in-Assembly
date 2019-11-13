
/* then read several cube specifications 
  */

#include <stdio.h>
#include <stdlib.h>

int totalPos;
int totalNeg;
int countPos;
int countNeg;

//void CubeStats(int first, int edge,int dimension,int size,int * averageNeg,int * averagePos);

int power(int base, int exponent)
{
  int r = 1;
  int t;
  for(t = exponent ; t>0 ; t--)
    r = r*base;
  return r;
}

void CubeStats(int* first, int edge, int dimension, int size, int* averageNeg, int* averagePos){

    //first specifies the dimension of the toal array
    //edge specifies the size of the edge of the mother array
    // dimension represents the address of the top left corner of the sub-cube
    //countpos and countneg count the number of positive and negative elements within the given cube
    //totalpos and total neg update every time a new variable is added to the total
		//may need to adjust because the variable names are mixed up

    // catch statement


    //THE NEXT PART DEPENDS ON WHETHER OR NOT THE CUBE IS TO BE REFERENCED AS A WHOLE OR PER LAYER OF A TOTAL OF K DIMENSIONS
		if (dimension == 0){
			if (*first > 0){
				totalPos += *first;
				countPos += 1;
			}

			else if (*first < 0){
				totalNeg = totalNeg + *first;
				countNeg = countNeg + 1;
			}
		}

    //utilize the mother array's edge to put bounds on the end of each layer of the cube, create a pointer to this index

    /*if (*first == -1 && (countPos != 0) && (countNeg != 0)){ //wrong ouput for the end point potentially... try editting this
			*averagePos = totalPos/countPos;
			*averageNeg = totalNeg/countNeg;
			return;    
    }*/

		
    //reference the beginning of the malloc array with a pointer (THIS IS FIRST)
    //utilize the mother array's edge to put bounds on the end of each layer of the cube, create a pointer to this index

		if (dimension == 1){
			//handle
			//return 
		}
    //create a pointer to the top left of the contents of dimension (this is already done with dimension)


		//handle dimension 0,1,2

    
    //create a counter that increments until size
    int rowcounter = 1;

    //intialize another variable that counts until size*size
    int totalcounter = 1;

    //nested loop with total counter on he outside and rowcounter on the inside
		int *apointer;
		apointer = first;

    while (totalcounter <= edge*edge){ //this size*size condition is likely where 1d will fail. this is because 1d arrays only need rowcounter. figure out how to filter this
			//printf("1\n");
			while (rowcounter <= edge){
				//printf("2\n");
				printf("blaaa %d \n",*apointer);
				if (*apointer > 0){
					//printf("3\n");
					totalPos = totalPos + *apointer;
					countPos = countPos + 1;
				}
				else if (*first < 0){
					//printf("4\n");
					totalNeg = totalNeg + *apointer;
					countNeg = countNeg + 1;
				}
				apointer++;
				totalcounter++;
				rowcounter++;

			}
			rowcounter = 1;
			apointer = apointer + (size - edge);
  	}

    //inner loop: start at the address (dimension) and then add the contents to totalpos. Access the next element and  Then just increment rowcounter. this repeats until the rowcounter = size. (also increments total_counter)
    //after the inner loop finishes, find the next row, add he offset, and then reference the next address. do not increment totalpos
    //end loop
    
    // then call cube statistics again on itself for every layer, but start from totalsize, and dimension should be the address offset by edge*edge

		//if the dimension is 3, execute this recursion
		if (dimension == 3){
   		CubeStats(first + size*size,edge,dimension, size, averageNeg, averagePos);
			return;
		}

}

int main(int argc, char **argv)
{
	int dimension;
	int size;
	int numelems;
	
	int *A;
	int *cursor, d;
	
	int cubed;
	
	int *first;
	int edge;

	int averageNeg;
	int averagePos;
	
	int *lastelem;
	
	scanf("%d %d", &dimension, &size);                  // takes dimension and size input
	numelems = power(size,dimension);                   // takes in the input of k dimensions and the edge size inputted in order to compute the TOTAL SIZE OF THE ARRAY
	A = (int *)malloc(numelems*sizeof(int));            // allocations 4*numelems of space for the total size of the array
	lastelem = &(A[numelems]);                          // the address of the stored array (represents the end of the stack)
        /* Read in all the elements of the array */
	for(cursor=A ; cursor<lastelem ; cursor++) {        // the stored array is initialized with he inputted numbers.
		scanf("%d",cursor);
	}
	
	while(1) {
		first = A;                                                                                  // initialize a pointer to the beginning of the stack array
		for(d=0 ; d<dimension ; d++) {                                                              // loop until d reaches dimensions
			scanf("%d",&cubed);                                                                     // reads input into cubed variable
			if(cubed < 0)                                                                           // ends the program if the cubed variable is negative
				exit(0);
	 		first = first + cubed*power(size,dimension-d-1);                                        // multiplies adds first to cubed computation
		}
		scanf("%d",&edge);                                                                          // reads in edge size
                totalPos = totalNeg = countPos = countNeg = averageNeg = averagePos = 0;                                      // initialize all global variables to 0
		CubeStats(first,edge,dimension,size,&averageNeg,&averagePos);                               // passes global variables ino CubeStats
		
		if (countPos != 0){
			averagePos = totalPos/countPos;
		}
		if (countNeg != 0){
			averageNeg = totalNeg/countNeg;
		}

       		printf("Positive Average = %d; Negative Average = %d\n",averagePos,averageNeg);         // prints computations for all dimensions
    }
}




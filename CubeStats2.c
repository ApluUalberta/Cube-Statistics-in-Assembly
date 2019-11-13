
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
				countPos++;

			}

			else if (*first < 0) {
				totalNeg = totalNeg + *first;
				countNeg++;

			}
			if (countPos != 0){
				
				*averagePos = totalPos/countPos;
			}
			else {
				*averagePos = 0;
			}
			if (countNeg != 0){
				*averageNeg = totalNeg/countNeg;
			}
			else{
				*averageNeg = 0;
			}

      return;
		}

    for (int i = 0; i < edge; i++){
      CubeStats(first + i*(power(size,dimension-1)),edge, dimension-1,size, averageNeg, averagePos);
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
                totalPos = totalNeg = countPos = countNeg = 0;                                      // initialize all global variables to 0
		CubeStats(first,edge,dimension,size,&averageNeg,&averagePos);                               // passes global variables ino CubeStats

    	printf("Positive Average = %d; Negative Average = %d\n",averagePos,averageNeg);         // prints computations for all dimensions
    }
}




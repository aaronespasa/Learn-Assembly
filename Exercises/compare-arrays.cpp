#include <iostream>

// I used two for loops instead of one because in Assembly
// we'll use also two.

int main() {
    // .data
    int A[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int B[10] = {2, 3, 4, 1, 2, 3, 9, 9, 6, 24};
    int C[10] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};

    // .text
    int A_len = sizeof(A) / sizeof(A[0]);
    
    for(int i = 0; i < A_len; i++) {
        if(A[i] <= B[i]) C[i] = 0;
    }

    // Print the results
    std::cout << "Array C: ";

    for(int i = 0; i < A_len; i++) {
        std::cout << C[i] << " ";
    }
    std::cout << "\n";
}
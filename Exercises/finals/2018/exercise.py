# The subroutine inserts the vector passed as the secondargument into row j of the matrix.
# It also inserts this vector into column j of the matrix.
# Insertion involves copying the vector into the corresponding row and column.
# If the value of j is out of range, the subroutine returns -1 and does not perform any insertion,
# otherwise, it returns 0 and performs the insertion in the corresponding row and column.

def exercise(matrix, vector, N, j):
    if j < 0 or j > N:
        # return -1
        raise Exception('j should be greater than 0 and smaller than N')

    i = 0
    while i < len(matrix):
        element = vector[i]
        # Substitute row
        matrix[j][i] = element
        # Substitute column
        matrix[i][j] = element
        i += 1
    
    # return 0
    for row in matrix:
        print(row)

if __name__ == '__main__':
    matrix = [[1.1, 1.3, 1.5],
            [3.5, 8.3, 2.1],
            [2.3, 2.1, 5.5]]

    vector = [0.5, 0.2, 0.1]

    N = 3
    j = 1

    exercise(matrix, vector, N, j)
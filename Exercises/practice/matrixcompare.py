import sys


def add_one_to_counter(count: int, sum_different_seq: int):
    count += 1
    if count == 2:
        sum_different_seq += 1

    return count, sum_different_seq


def matrixcompare(A: list, M: int, N: int, num_to_search: int, num_occurences: int):
    total_sum_seq = 0
    for i in range(M):
        sum_different_seq = 0
        count = 0

        for j in range(N):
            if A[i][j] == num_to_search:
                count, sum_different_seq = add_one_to_counter(count, sum_different_seq)
            else:
                count = 0 
        
        total_sum_seq += sum_different_seq

    print(total_sum_seq)
    return total_sum_seq

def main():
    A = [[2, 3, 0, 4, 5, 8, 3],
         [3, 0, 3, 3, 3, 0, 9],
         [3, 3, 8, 9, 6, 7, 4],
         [3, 0, 3, 3, 0, 8, 9]]
    M = len(A)
    N = len(A[0])
    num_to_search = 3
    num_occurrences = 2

    if (num_occurrences < 1) or (M < 1) or (N < 1):
        print("-1")
        sys.exit()

    print(0, end='')
    # Call matrixcompare
    matrixcompare(A, M, N, num_to_search, num_occurrences)

    sys.exit()


if __name__ == "__main__":
    main()
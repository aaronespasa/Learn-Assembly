import sys

def add_one_to_counter(count:int, sum_different_seq:int):
    count += 1
    if count == 2:
        sum_different_seq += 1
    
    return count, sum_different_seq

def arraycompare(A:list, N:int, num_to_search:int, num_occurences:int):
    sum_different_seq = 0
    count = 0
    for i in range(N):
        if A[i] == num_to_search:
            count, sum_different_seq = add_one_to_counter(count, sum_different_seq)
        else:
            count = 0

    print(sum_different_seq)
    return sum_different_seq

def main():
    A = [7, 3, 6, 6, 0, 1, 6, 6, 6, 6, 0, 0, 6, 5, 2, 0, 2, 4, 5, 6, 6, 6]
    N = len(A)
    num_to_search = 6
    num_occurrences = 2

    if (num_occurrences < 1) or (N < 1):
        print("-1")
        sys.exit()

    print(0, end='')
    # Call arraycompare
    arraycompare(A, N, num_to_search, num_occurrences)

    sys.exit()

if __name__ == "__main__":
    main()

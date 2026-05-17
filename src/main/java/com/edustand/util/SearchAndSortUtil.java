package com.edustand.util;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

/**
 * Academic-compliant search and sort utilities designed for CS5005.
 * Implements a custom generic Merge Sort algorithm (O(N log N)) and
 * a custom generic Linear Search algorithm (O(N)) for memory-level filtering.
 */
public class SearchAndSortUtil {

    /**
     * Custom generic implementation of Merge Sort to sort a list in-place.
     * Time Complexity: O(N log N) in all cases (best, average, worst).
     * Space Complexity: O(N) auxiliary space.
     * Stable sorting algorithm.
     *
     * @param list       The list of elements to be sorted.
     * @param comparator The comparator determining the sorted order.
     * @param <T>        The generic type of elements in the list.
     */
    public static <T> void mergeSort(List<T> list, Comparator<? super T> comparator) {
        if (list == null || list.size() <= 1) {
            return;
        }
        System.out.println("[CS5005 Merge Sort] Initiating Divide-and-Conquer Merge Sort on list of size " + list.size() + "...");
        // Initialize auxiliary storage for merge steps
        List<T> temp = new ArrayList<>(list);
        mergeSort(list, temp, 0, list.size() - 1, comparator);
        System.out.println("[CS5005 Merge Sort] Generic sort completed successfully.");
    }

    private static <T> void mergeSort(List<T> list, List<T> temp, int left, int right, Comparator<? super T> comparator) {
        if (left < right) {
            int mid = left + (right - left) / 2;
            
            // Divide and Conquer
            mergeSort(list, temp, left, mid, comparator);
            mergeSort(list, temp, mid + 1, right, comparator);
            
            // Combine / Merge
            merge(list, temp, left, mid, right, comparator);
        }
    }

    private static <T> void merge(List<T> list, List<T> temp, int left, int mid, int right, Comparator<? super T> comparator) {
        // Copy elements from current partition into auxiliary list
        for (int i = left; i <= right; i++) {
            temp.set(i, list.get(i));
        }

        int i = left;      // Pointer for left sub-array
        int j = mid + 1;   // Pointer for right sub-array
        int k = left;      // Destination pointer in original list

        // Merge elements back in sorted order
        while (i <= mid && j <= right) {
            if (comparator.compare(temp.get(i), temp.get(j)) <= 0) {
                list.set(k, temp.get(i));
                i++;
            } else {
                list.set(k, temp.get(j));
                j++;
            }
            k++;
        }

        // Copy any remaining elements from the left sub-array (right is already in place)
        while (i <= mid) {
            list.set(k, temp.get(i));
            i++;
            k++;
        }
    }

    /**
     * Custom generic implementation of Linear Search.
     * Iterates linearly through the collection to identify elements matching
     * the predicate criteria.
     * Time Complexity: O(N) linear time scan.
     * Ideal for unsorted datasets or multi-field contains matching.
     *
     * @param list      The source list to search/filter.
     * @param predicate The matching condition defining hits.
     * @param <T>       The generic type of elements in the list.
     * @return A new list containing only the elements that match the predicate.
     */
    public static <T> List<T> linearSearch(List<T> list, SearchPredicate<T> predicate) {
        List<T> result = new ArrayList<>();
        if (list == null || predicate == null) {
            return result;
        }
        System.out.println("[CS5005 Linear Search] Scanning through collection of size " + list.size() + " for criteria matching...");
        int checked = 0;
        for (T item : list) {
            checked++;
            if (predicate.test(item)) {
                result.add(item);
            }
        }
        System.out.println("[CS5005 Linear Search] Scan completed. Found " + result.size() + " matches out of " + checked + " elements.");
        return result;
    }

    /**
     * Functional interface representing a single condition predicate for search.
     * Compatible with Java 8+ lambda expressions.
     */
    @FunctionalInterface
    public interface SearchPredicate<T> {
        boolean test(T t);
    }
}

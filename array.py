# =====================================================================
# QUESTION ID: LC 88 (Alternative 1)
# TOPIC: Sorting - Merge Sorted Array (Built-in Sort)
# LINK: https://leetcode.com/problems/merge-sorted-array/
# =====================================================================
class Solution:
    def merge(self, nums1: list[int], m: int, nums2: list[int], n: int) -> None:
        """
        Do not return anything, modify nums1 in-place instead.
        """
        # 1. Overwrite the tail zeros of nums1 with all elements of nums2 using a slice
        nums1[m:] = nums2
    
        # 2. Sort the entire array in-place
        nums1.sort()

# --- Driver Code for Test ---
array1 = [1, 2, 3, 0, 0, 0]
array2 = [2, 5, 6]  # Match the n parameter below

# Create the object instance with parentheses ()
s = Solution() 

# Pass matching lengths (m=3 elements, n=3 elements)
s.merge(array1, 3, array2, 3) 

print("Built-in Sort Method:", array1)

# =====================================================================
# QUESTION ID: LC 283
# TOPIC: Two Pointers - Move Zeroes (Optimal In-Place Pointer Swap)
# LINK: https://leetcode.com/problems/move-zeroes/
# =====================================================================
class Solution:
    def moveZeroes(self, nums: list[int]) -> None:
        """
        Do not return anything, modify nums in-place instead.
        
        Space Complexity: O(1) - Constant space modifying the array in-place.
        Time Complexity:  O(N) - Linear single-pass execution.
        """
        # Keeps track of where the next non-zero element should be placed
        last_non_zero = 0
        
        # Iterate through the array
        for current in range(len(nums)):
            # When we find a non-zero element, swap it to the front tracker
            if nums[current] != 0:
                nums[last_non_zero], nums[current] = nums[current], nums[last_non_zero]
                last_non_zero += 1

# --- Driver Code for Test ---
array = [0, 1, 0, 3, 12]

s = Solution()
print("Original:", array)
s.moveZeroes(array)
print("Modified:", array)

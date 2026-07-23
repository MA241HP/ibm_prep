# =====================================================================
# QUESTION ID: LC341
# TOPIC: Stack / Lazy Evaluation - Flatten Nested List Iterator
# LINK: https://leetcode.com/problems/flatten-nested-list-iterator/
# =====================================================================
def flatten_stream(nested_list):
    for item in nested_list:
        if isinstance(item, int):
            yield item
        else:
            yield from flatten_stream(item) # do iteration for sublist

# Pass the raw value directly
nested_list = [[1, 1], 2, [3, [4, 5]]]

# Convert the streaming generator into a single list
stream = flatten_stream(nested_list)   
flat_list = list(stream)

print(flat_list)#

#############################################################################################################
# =====================================================================
# QUESTION ID: LC347 (Alternative HashMap Solution)
# TOPIC: HashMap & Sorting - Top K Frequent Elements
# LINK: https://leetcode.com/problems/top-k-frequent-elements/
# =====================================================================

def topKFrequent(nums: list[int], k: int) -> list[int]:
    """
    Finds the k most frequent elements using a HashMap and Sorting.
    Time Complexity: O(N log N) | Space Complexity: O(N)
    """
    # Step 1: Count frequency of each number using a standard dictionary (HashMap)
    frequency_map = {}
    for num in nums:
        if num in frequency_map:
            frequency_map[num] += 1
        else:
            frequency_map[num] = 1
            
    # Step 2: Sort the unique elements by their frequency in descending order
    # frequency_map.keys() gives the unique numbers (e.g., [1, 2, 3])
    # The key=lambda x: frequency_map[x] tells Python to sort them by their count values
    sorted_elements = sorted(frequency_map.keys(), key=lambda x: frequency_map[x], reverse=True)
    
    # Step 3: Return the first k elements from the sorted list
    return sorted_elements[:k]


# --- Quick Test Execution Block ---
if __name__ == "__main__":
    test_nums = [1, 1, 1, 2, 2, 3]
    k = 2
    print(f"LC347 Result: {topKFrequent(test_nums, k)}")  # Expected Output: [1, 2]

#############################################################################################################
# =====================================================================
# QUESTION ID: LC 344
# TOPIC: Two Pointers - Reverse String (Optimal In-Place Mutation)
# LINK: https://leetcode.com/problems/reverse-string/
# =====================================================================
def reverseStringPointer(s: list[str]) -> None:
    """
    Do not return anything, modify s in-place instead.
    
    Space Complexity: O(1) - Optimal constant space allocation.
    Time Complexity:  O(N) - Single pass with N/2 swaps.
    """
    left, right = 0, len(s) - 1
    
    while left < right:
        # Swap characters in-place using two pointers
        s[left], s[right] = s[right], s[left]
        left += 1
        right -= 1

# --- Driver Code for Test ---
my_list_1 = ["h", "e", "l", "l", "o"]
print("Original (Pointer):", my_list_1)
reverseStringPointer(my_list_1)
print("Reversed (Pointer):", my_list_1)


# =====================================================================
# QUESTION ID: LC 344
# TOPIC: Slicing & Slice Assignment - Reverse String (Pythonic Mutation)
# LINK: https://leetcode.com/problems/reverse-string/
# =====================================================================
def reverseStringSlice(s: list[str]) -> None:
    """
    Do not return anything, modify s in-place instead.
    
    Space Complexity: O(N) - Generates a temporary shallow copy of the list.
    Time Complexity:  O(N) - Highly optimized C-level loop execution in Python.
    """
    # s[:] ensures we overwrite the existing list container in-place, 
    # while s[::-1] generates the reversed copy to fill it.
    s[:] = s[::-1]

# =====================================================================
# QUESTION ID: LC 151
# TOPIC: String / Two Pointers - Reverse Words in a String
# LINK: https://leetcode.com/problems/reverse-words-in-a-string/
# =====================================================================
class Solution:
    def reverseWords(self, s: str) -> str:
        """
        Time Complexity:  O(N) - Single pass through the string to split, reverse, and join.
        Space Complexity: O(N) - To store the extracted words in memory.
        """
        return " ".join(s.split()[::-1])


# --- Driver Code ---
sol = Solution()
example1 = "the sky is blue"
example2 = "  hello world  "
example3 = "a good   example"

print("Result 1:", f'"{sol.reverseWords(example1)}"')  # Output: "blue is sky the"
print("Result 2:", f'"{sol.reverseWords(example2)}"')  # Output: "world hello"
print("Result 3:", f'"{sol.reverseWords(example3)}"')  # Output: "example good a"

# --- Driver Code for Test ---
my_list_2 = ["H", "a", "n", "n", "a", "h"]
print("\nOriginal (Slice):  ", my_list_2)
reverseStringSlice(my_list_2)
print("Reversed (Slice):  ", my_list_2)

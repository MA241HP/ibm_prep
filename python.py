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

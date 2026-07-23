# =====================================================================
# QUESTION ID: LC 217
# TOPIC: Hash Set - Contains Duplicate
# LINK: https://leetcode.com/problems/contains-duplicate/
# =====================================================================
from typing import List

class Solution:
    def containsDuplicate(self, nums: List[int]) -> bool:
        duplicate_map = set()
        
        for num in nums:
            if num in duplicate_map:
                return True
            duplicate_map.add(num)
            
        return False

# --- Driver Code ---
s = Solution()
nums = [1, 2, 3, 1]
print(s.containsDuplicate(nums))  # Output: True

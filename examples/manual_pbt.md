```python
import random


def test_sort_list_of_ints():
    for i in range(2, 101):
        ints = [random.randint(-1000, 1000) for _ in range(i)]
        result = sort(ints)
        assert all(x <= y for x, y in zip(result, result[1:]))
```

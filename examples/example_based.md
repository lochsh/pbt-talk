```python
def test_sort_list_of_ints():
    ints = [1, 5, 10, 0, 3, 11, 2]
    result = sort(ints)
    assert all(x <= y for x, y in zip(result, result[1:]))
```

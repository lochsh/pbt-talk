```python
import hypothesis
from hypothesis import strategies


@hypothesis.given(strategies.lists(strategies.integers(), min_size=2))
def test_sort_list_of_ints(ints):
    result = sort(ints)
    assert all(x <= y for x, y in zip(result, result[1:]))
```

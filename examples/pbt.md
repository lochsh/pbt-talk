```python
import hypothesis
from hypothesis import strategies as st


@hypothesis.given(st.lists(st.integers(), min_size=2))
def test_sort_list_of_ints(ints):
    result = sort(ints)
    assert all(x <= y for x, y in zip(result, result[1:]))
```

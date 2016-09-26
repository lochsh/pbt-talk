# Property based testing

## Intro

We all know the value of writing automated tests for our code, and James has 
done awesome work introducing us to Test Driven Development.  Today I want to 
talk about another technique that can improve the usefulness of your tests.

Property based testing involves running a single test many times with multiple 
randomly generated inputs.  This allows you to test more with less code.  It 
makes it easier for you to write better tests, and avoids the need for you to 
think up examples.

If we consider our tests as documentation, PBT improves the breadth and 
generality of that documentation.


## Example based testing

So, how is property based testing different from tests we've written before?  I 
can't speak for everyone, but when I have written tests in the past, they have 
been largely example-based.  I find myself having to think up example scenarios 
and manually code them.  For example, testing a sorting algorithm:

```python
def test_sort_list_of_ints():
    ints = [1, 5, 10, 0, 3, 11, 2]
    assert all(x <= y for x, y in zip(sort(ints, ints[1:])))
```

I want to ensure my function `sort` actually sorts a list of integers.  My 
test, however, only tests for one specific input.  It's possible that even if 
it passes, other values could cause problems.  It also doesn't document the 
desired behaviour of my code very well.  It's just an example of how the could 
should work, rather than a statement defining a more general property.

It's inherently difficult or lengthy demonstrate generic properties with 
example based testing.

With this in mind, here is an improved test:

```python
import random


def test_sort_list_of_ints():
    ints = [random.randint(-1000, 1000) for _ in range(random.randint(2, 100))]
    assert all(x <= y for x, y in zip(sort(ints, ints[1:])))
```

This is better &ndash; we are now testing for list between 2 and 100 elements 
long, with integers &plusmn;1000.  A property based testing framework can make 
this easier and better still.


## Property based testing

So, what can a property based testing framework add to this?  David MacIver, 
who created the framework `hypothesis`, describes a PBT framework as consisting 
of:

* A fuzzer
* A library of tools for making it easy to construct property-based tests using 
  that fuzzer.

In the above example, we did the fuzzing ourselves by creating a random list.  
A testing framework can do this for us:

```python
import hypothesis


@hypothesis.strategies.lists(hypothesis.strategies.integers(), min_size=2)
def test_sort_list_of_ints(ints):
    assert all(x <= y for x, y in zip(sort(ints, ints[1:])))
```

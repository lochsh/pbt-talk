# Property based testing

## Intro

We all know the value of writing automated tests for our code, and James has 
done awesome work introducing us to Test Driven Development.  Today I want to 
talk about another technique that can improve the usefulness of our tests.

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
    for i in range(2, 101):
        ints = [random.randint(-1000, 1000) for _ in range(i)]
        assert all(x <= y for x, y in zip(sort(ints, ints[1:])))
```

This is better &ndash; we are now testing for lists with  between 2 and 100 
elements long, containing random integers in the range &plusmn;1000.  There are 
some difficulties here:

* This test may pass sometimes and fail others.  Even though it may have failed 
  in the past, we don't have a record of the example that caused it to fail.

* Although this is more general than the single example based test, it still 
  relies on us choosing which range of values we want to test.

A property based testing framework can help resolve these issues.


## Property based testing

So, what can a property based testing framework add to this?

Here is the above example test modified to use the `hypothesis` framework for 
Python:

```python
import hypothesis


@hypothesis.strategies.lists(hypothesis.strategies.integers(), min_size=2)
def test_sort_list_of_ints(ints):
    assert all(x <= y for x, y in zip(sort(ints, ints[1:])))
```

The key differences:

* When running the test, `hypothesis` actively seeks out falsifying examples.  
  Not only that, but the examples are simplified until a smaller example is 
  found that still causes the problem.  These examples are then stored in a 
  cache, so that a test that fails once will always fail, until the code is 
  updated.

* From an ergonomic point of view, it's much easier to see straight away what 
  property we are testing.  The decorator line specifies that this test should 
  pass for all list of integers of length &ge;2.  We test more, but with less 
  code.


## Use cases

I think these kind of tests are useful in any software project, but here are 
some particularly motivating examples:

* Testing the parsing of user text input.  It's infeasible to think of every 
  possible string a user could input to your GUI; property based tests can give 
  you more confidence in your sanitising and parsing.

* Many mathematical calculations lend themselves well to being tested this way. 
  For example, the objective function in Expectation-Maximisation should always 
  decrease or plateau.  If it increases at any iteration, you have a problem.

* The Fourier Transforms of a pure sine wave should have constant magnitude 
  across time samples.

These are invariant properties that are poorly demonstrated with examples.  
Property based testing makes your tests function better both as documentation, 
and as proof of the robustness of your code.  Each test is more concise, and 
each test goes further.  For these hopefully very compelling reasons, I hope 
you'll all consider giving PBT a try and using it in your work!

Some frameworks to read up on are:

* `hypothesis` by David MacIver, which is currently available for Python only.  
  Java, C and C++ implementations will hopefully come some time in the future.

* `QuickCheck` is the classic property based testing framework, released for 
  Haskell in 1999 and ported to Erlang, Scala and other functional languages.

* `RapidCheck` for C++

* `FsCheck` for .NET languages (C# etc.)

Enjoy!

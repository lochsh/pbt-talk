# Property based testing


## Intro

We all know the value of writing automated tests for our code, and James has 
done awesome work introducing us to TDD.  Today I want to talk about another 
technique that can improve the usefulness of your tests.  Property based 
testing involves running a single test many times with multiple randomly 
generated inputs.  This allows you to test more with less code, without the 
need for you to think up examples, and helps you find edge cases.  If we 
consider our tests as documentation, it also improves the breadth and 
generality of that documentation.



## Example based testing

I can't speak for everyone, but when I have written tests in the past, they 
have been largely example-based.  I often found myself having to create example 
data to use.  Here is an overly simplistic example.  I want to ensure my 
function `foo` returns zero if both its inputs are equal.  My test, however, 
only tests for one value!  It's possible that even if it passes, other values 
could cause problems.  They might be edge cases, or it could be that our code 
doesn't work at all, and this pass is merely a fluke.

```python
def test_foo():
    """Test function foo returns zero when both inputs are equal"""
    assert foo(5, 5) == 0
```

So, what is a better way?  We want to try a range of values and check them all.

```python
def test_foo()
    """Test function foo returns zero when both inputs are equal"""
    for i in range(1000):
        assert foo(i, i) == 0
```

This is better.  We now test 1000 different integers, rather than just 1.  We 
can still do better though!


## Property based testing

The previous example was an improvement, but it still involved us having to 
pick some examples to test with.  We picked more examples, sure, but it's still 
limited.  If your test really does only want to cover those 1000 values, then 
it's ok, but often we will have to cover a lot more.

Property based testing frameworks automate the random generation of values to 
test with, as well as keeping a database of values that break your tests.  They 
actively find edge cases and errors in your code, and keep track of them in 
order to speed up testing.

Here is how I would write that test using the Python property testing framework 
hypothesis.

```python

import hypothesis
from hypothesis import strategies

@hypothesis.given(strategies.integers())
def test_foo(input):
    """Test function foo returns zero when both inputs are equal"""
    assert foo(input, input)
```

# Use cases

Tests like these are useful everywhere, but some good examples are when testing 
user input that might not have been properly sanitised, or doing mathematical 
calculations with some known rules.  An example of the second case: imagine you 
have an iteration that should always decrease or remain constant, but never 
increase, regardless of what input it is given.  Property based testing is 
perfect for this!

It is nice to think about your tests as documentation for your code.  They show 
what your code should be doing.  It makes sense that this documentation should 
be about generic properties, rather than specific tests.

Another example: the Fourier transform of a pure sine wave should be the same 
at every time sample.  One way you might document your Fourier transform code 
is by having a test that tests for this for a variety of sine wave frequencies 
and offsets (I recently did something v similar).

## Interactive test writing?

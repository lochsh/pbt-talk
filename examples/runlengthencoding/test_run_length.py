import run_length


def test_encoding_all_distinct():
    assert run_length.encode([1, 2, 3]) == [[1, 1], [2, 1], [3, 1]]


def test_encoding_all_the_same():
    assert run_length.encode([1, 1, 1]) == [[1, 3]]


def test_decoding():
    assert run_length.decode([[1, 1], [2, 2], [3, 3]]) == [1, 2, 2, 3, 3, 3]

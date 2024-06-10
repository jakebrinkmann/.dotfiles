import pytest


@pytest.fixture
def order():
    return []


@pytest.fixture
def top(order, innermost):
    order.append("top")


class Fruit:
    def __init__(self, name):
        self.name = name

    def __eq__(self, other):
        return self.name == other.name

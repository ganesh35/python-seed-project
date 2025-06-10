from py_hello import main


def test_main_output():
    assert main.main() == "Hello World!"

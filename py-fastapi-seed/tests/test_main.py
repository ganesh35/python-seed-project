def test_main_output():
    from app import config

    assert config.HELLO_MESSAGE in ["World!", "All!"]

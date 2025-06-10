from py_hello import config


def main():
    print(f"Hello {config.HELLO_MESSAGE}")
    return "Hello " + config.HELLO_MESSAGE


if __name__ == "__main__":
    main()

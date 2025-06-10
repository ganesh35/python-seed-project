import os
from setuptools import setup, find_packages

setup(
    name="py-fastapi-seed",
    version="0.1.0",
    package_dir={"": "src"},
    packages=find_packages(where="src"),
    install_requires=[],
    author="Your Name",
    author_email="your.email@example.com",
    description="A basic Python project",
    long_description=(open("README.md").read() if os.path.exists("README.md") else ""),
    long_description_content_type="text/markdown",
    url="https://github.com/yourusername/py-fastapi-seed",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
    ],
    entry_points={
        "console_scripts": [
            "py-fastapi-seed=py_fastapi_seed.main:main",
        ],
    },
)

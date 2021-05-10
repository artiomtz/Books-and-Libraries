# Client application for the ECE356 Project
import argparse

from frontend.service import login_or_signup, show_menu_options

welcome = "A CLI to Interact with a Library Management System"

parser = argparse.ArgumentParser(description=welcome)
parser.parse_args()


def main():
    while 1:
        login_or_signup()
        show_menu_options()


main()


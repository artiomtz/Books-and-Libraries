import re

from backend.service import retrieve_user

from .utilities import format_sentence


def get_username(message):
    exception_message = ""
    if re.search("[^-a-z0-9_.]", message):
        exception_message += "The username entered is invalid. "
    elif retrieve_user(message) is None:
        exception_message += f"The username '{message}' does not exist."
    if exception_message:
        raise Exception(format_sentence(exception_message))

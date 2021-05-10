import re

from backend.service import retrieve_user

from .utilities import format_sentence


def get_first_name(message):
    exception_message = ""

    if not re.match("^[a-zA-Z]*$", message):
        exception_message += "First name can only contain letters a-z. "
    if len(message) > 50:
        exception_message += "First name cannot exceed 50 characters. "
    if exception_message:
        raise Exception(format_sentence(exception_message))


def get_last_name(message):
    exception_message = ""

    if not re.match("^[a-zA-Z]*$", message):
        exception_message += "Last name can only contain letters a-z. "
    if len(message) > 50:
        exception_message += "Last name cannot exceed 50 characters. "
    if exception_message:
        raise Exception(format_sentence(exception_message))


def get_username(message):
    exception_message = ""
    if re.search("[^-a-z0-9_.]", message):
        exception_message += "Username can only contain letters a-z, numbers from 0-9, and characters '.' '_'. "
    if len(message) > 12 or len(message) < 3:
        exception_message += "Username must be between 4-14 characters long. "
    if retrieve_user(message) is not None:
        exception_message += f"The username '{message}' is already taken, please choose a different one. "
    if exception_message:
        raise Exception(format_sentence(exception_message))


def get_address(message):
    if len(message) > 255:
        raise Exception("Address should be less than 255 characters. ")


def get_city(message):
    if len(message) > 20:
        raise Exception("City should be less than 20 characters. ")


def get_zip(message):
    exception_message = ""
    if len(message) > 10:
        exception_message += "Zip code should be less than 10 characters. "
    if not re.match("^[0-9]{5}(?:-[0-9]{4})?", message):
        exception_message += "The zip code entered is invalid. "
    if exception_message:
        raise Exception(exception_message)

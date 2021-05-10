import re

from .utilities import format_sentence


def get_review(message):
    exception_message = ""

    if len(message) > 1000:
        exception_message += "The review cannot be over 1000 characters. "
    if exception_message:
        raise Exception(format_sentence(exception_message))


def get_book_name(message):
    exception_message = ""

    if len(message) > 255:
        exception_message += "The name cannot be over 255 characters. "
    if exception_message:
        raise Exception(format_sentence(exception_message))


def get_isbn(message):
    exception_message = ""

    if len(message) > 13:
        exception_message += "The isbn cannot be over 13 characters. "
    if len(message) < 10:
        exception_message += "The isbn cannot be less than 10 characters. "
    if len(message) != 10 and len(message) != 13:
        exception_message += "The isbn has to be either 10 or 13 characters."
    if exception_message:
        raise Exception(format_sentence(exception_message))


def get_publish_year(message):
    exception_message = ""

    if not re.match('^\d{4}$', message):
        exception_message += "The entered year is invalid. "
    if exception_message:
        raise Exception(format_sentence(exception_message))


def get_subjects(message):
    exception_message = ""

    if len(message) > 255:
        exception_message += "The subject cannot be over 255 characters. "
    if exception_message:
        raise Exception(format_sentence(exception_message))

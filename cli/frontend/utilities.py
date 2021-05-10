from fuzzyfinder import fuzzyfinder
from prompt_toolkit.completion import Completer, Completion


class SearchCompleter(Completer):
    def __init__(self, search_list):
        self.search_list = search_list

    def get_completions(self, document, complete_event):
        text_before_cursor = document.text_before_cursor
        matches = fuzzyfinder(text_before_cursor, self.search_list)
        for m in matches:
            yield Completion(m, start_position=-len(text_before_cursor))


class Session:
    first_name = None
    last_name = None
    username = None
    role = None
    branch = None

    def __init__(self, first_name, last_name, username, role, branch=None):
        Session.first_name = first_name
        Session.last_name = last_name
        Session.username = username
        Session.role = role
        Session.branch = branch  # branch is optional since staff don't need it

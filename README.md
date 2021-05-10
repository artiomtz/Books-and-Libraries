# ECE356-Project

Marmoset setup to run the <b>CLI</b>:

1. Clone this repo by doing:
`ist-git@git.uwaterloo.ca:a42abdul/ece356-project.git`
   
2. `cd ece356-project`
3. Create a virtual environment: `python3 -m venv books_group30`
4. Start the virtual environment: `source books_group30/bin/activate`
5. Install requirements: `pip install -r requirements.txt`
6. Update DB credentials file: `vim cli/backend/db/config.py`
7. Fill out the empty fields (user and password)
```
credentials = {
    'user': '',
    'password': '',
    'host': 'marmoset04.shoshin.uwaterloo.ca',
    'port': '3306',
    'database': 'project_30',
    'raise_on_warnings': True
}
```
8. Go to the CLI folder: `cd ece356-project/cli`
9. Clear the console
10. Start the CLI: `python3 main.py`

Marmoset setup to run the <b>Data Mining</b>:

After successfully runnig the CLI follow these steps to run the book recommendation engine:

1. Go to top folder: `cd ece356-project`
2. Start the virtual environment: `source books_group30/bin/activate`
3. `cd DM/`
4. Update DB credentials file: `vim config.py`
5. Fill out the empty fields (user and password)
```
credentials = {
    'user': '',
    'password': '',
    'host': 'marmoset04.shoshin.uwaterloo.ca',
    'port': '3306',
    'database': 'project_30',
    'raise_on_warnings': True
}
```
6. Run the book recommendation engine: `python3 data_mining.py`
7. Enter the book name from which to recommend more books: `Enter book:<Book-Name-In-DB>`
8. Optional, to generate the graphs used simply run: `python3 data_mining.py -v -cap=4000000`


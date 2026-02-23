# Project Setup
The setup for this project can be done essentially just as described in the original readme. Simply clone the code, setup and activate the python venv with dependencies, setup the kernelspec, and create the database (make sure a user called "postgres" has create schema and create table permissions on the database, if they're not a superuser/admin by default). Once that's setup, you can run the code via `python main.py`, and once that's finished, check out the jupyter notebook. 

## Potential Throttling Issue sans app token
I opted to use the Socrata API to programmatically download the raw data in the fetch_collisions.py file. I did not include an app_token since sending that securely for this project would be a bit overkill IMO, but since the API does sometimes throttle traffic without the app_token, occassionally the code will need to be rerun if another request to the API has recently been made. Of course, any real production environment would include an app_token and retry logic. 
 
## Time 
This project took me around 4 hours. 

## Feelings on Project & Concerns
Overall, I really enjoyed this project--it was fun to work with real world data that's close to home (I live in New York)! There were a lot of different ways the problem could have been approached, especially since it was open ended what type of system we wanted to optimize for. Since the example code included analytics SQL table, I went with that approach as well, creating both raw, partially cleaned, and analytic summary sql tables that could then be queried. The amount of data actually being queried in this case was honestly probably small enough to explore just via pandas (which would usually be how I'd start, pre-productionizing), but the SQL/data warehouse type of approach is much better if we want to simulate situations with larger amounts of data that business users need to be able to quickly see updated reports on. 

There were a lot of things that I'd add in anything going into production, such as much more thorough data cleaning, type constraints, error handling, etc. I also would love to work with a dataset that has information on traffic patterns in NYC generally in order to better answer some of the questions posed in the analysis. Since we only have collision data, we can't properly answer questions on what makes a person, car, etc. more likely to crash in the first place, since we only have information on the people/vehicles who *did* crash. Having information on the baseline about what kinds of vehicles, drivers, traffic spikes, etc. are on the road generally would provide a lot of helpful context. 

All that to say--thanks for a thought provoking little experiment! 


# ORIGINAL README TEXT BELOW
# SL/VF Data Engineer Technical Take Home

> Build is a mini ELT pipeline that extracts recent NYC traffic collision data, loads it into a database, transforms it into an analytical tables, and display the information in a meaningful way. 

- [Evaluation](#evaluation)
- [What we are looking for](#what-we-are-looking-for)
- [Submitting your code](#submitting-your-code)
- [Questions or Concerns](#questions-or-concerns)
- [Running the code](#running-the-code)


## Evaluation

We are compiling a report of the motor vehicle collisions from 2024 and trying to determine what contributing factors lead to collisions, injuries, and fatalities. We have started the code for you already, but its up to you to finish the code, transform and model the data, and then use the data to make a report.  

1. Extracts collision data from NYC Open Data API for 2024 and save raw data to a .csv file 
    - [Collision Crashes](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Crashes/h9gi-nx95)
    - [Collision Vehicles](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Vehicles/bm4k-52h4/about_data)
    - [Collision Persons](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Person/f55k-p6yu/about_data)
2. Loads the raw data from previously saved .csv files into a local Postgres database 
3. Transform the data into analytical tables
4. Directly query transforms from a Jupyter notebook and display the data in a meaningful way. You can use the notebook provided as a blueprint, or you can choose to display information you find relevant.

**We have provided starter code. Feel free to use as much or as little as you would like. If you decide to use different technologies than what is provided please leave detailed instructions on how to run your project in a README during submission**


## What we are looking for

- Does it work?
- Is the code clean and accessible to others?
- Decision on data modeling and transformation
    - We want to be able to understand your thought process 
    - How did you handle cleaning the data
- SQL and python knowlege 


## Time Limit

The purpose of the test is not to measure the speed of code creation. Please try to finish within 5 days of being sent the code test, but extra allowances are fine and will not be strictly penalized.

## Submitting Your Code

The preferred way to submit your code is to create a fork of this repo, push your changes to the forked repo, and then either:
- open a pull request against the original repo from your forked repo
- grant access to your forked repo to erhowell, so that we can access the code there.
Alternatively, you may submit the code in the form of a zip file and send it to erhowell@swingleft.org. 

Please be sure to include a README in your submission with full details on how to set up and run your code as well as answer the following questions:
- Roughly how long did this project take you
- How you felt about this project, and what issues did you face, if any.  

Speed is not what we are evaluating; we are evaluating the process as a whole and the effort it takes to complete it.


## Questions or Concerns

If you have any questions at all, feel free to reach out to [erhowell@swingleft.org](mailto:erhowell@swingleft.org)

## Running The Code

[If you choose to clone this repo and work from the hello-world sample, please use the directions below. If you implement another solution using a different language or framework, please update these directions to reflect your code.]

## Setup
This project requires python. Everyone has their preferred python setup. If you don't, try [pyenv](https://github.com/pyenv/pyenv). If you're also looking for a way to manage virtual python environments, consider [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv). Regardless, these instructions assume you have a working python environment.

# Set up virtual environment

```bash
cd /where/you/like/source/code
# Check to make sure the version of python is correct.
# The starter code is utilizing Python 3.11 to match the environment we are currently on
python -V

python -m venv <env-name>
cd <env-name>
git clone <github-url>
cd <env-name>

Activate your virtualenv so that pip packages are installed
# locally for this project instead of globally.
source ../bin/activate

pip3 install -r requirements.txt

# Installed kernelspec sl-data-eng-take-home
python -m ipykernel install --user --name=<env-name> --display-name "Python (NYC Collisions)"


```
# Create your postgres DB.

```bash
# Set up the initial state of your DB.
# You can change the name of the db from nyc_collisions to anything you'd like. 
# Just be sure to update the postgres url in the .env 
brew services start postgresql 
createdb <nyc_collisions>
```

### Running the server

```bash
# Make sure your environment is running correctly
python main.py

#working with the notebook
jupyter notebook <path_to_notebook>
```

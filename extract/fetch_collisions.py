import requests
import pandas as pd
from sodapy import Socrata
import csv
import os
from enum import Enum
import itertools


# API endpoints for NYC Motor Vehicle Collisions
CRASH_COLLISION_ID = 'h9gi-nx95'
CRASH_VEHICLE_ID = 'bm4k-52h4'
CRASH_PERSONS_ID = 'f55k-p6yu'

# CSV to save to
RAWDIR = os.getenv("RAWDIR")
if not RAWDIR:
    raise RuntimeError("RAWDIR not set in .env")

class CrashDataType(Enum):
    COLLISIONS = "Collisions"
    VEHICLES = "Vehicles"
    PERSONS = "Persons"

#fetch data from NYC Open Data API on all crashes for 2024
def fetch_data(
        id: str,
        name: str, 
        filepath: str,
        limit: int = 100000, 
        date_start: str = "2024-01-01T00:00:00",  # inclusive. assumes local timezone.
        date_end: str = "2025-01-01T00:00:00",  # exclusive. assumes local timezone.
) -> None:
    print(f"Fetching {name} from NYC Open Data...")

    # In a real sytem, we'd want to pass in an app-specific app token and 
    # potentially add rety/waiting logic in case of throttling. 
    client = Socrata("data.cityofnewyork.us", None)  

    md = client.get_metadata(id)
    field_names = [cn['fieldName'] for cn in md['columns']]
    records = client.get_all(
        id, 
        limit=limit, # used for pagination within get_all internals, not a total limit
        where=f"crash_date >= '{date_start}' AND crash_date < '{date_end}'"
    )

    with open(filepath, "w", newline="") as csvfile:
        wr = csv.DictWriter(csvfile, fieldnames=field_names)
        wr.writeheader()
        for rr in records:
            wr.writerow(rr)

    print(f"Saved {name} to {filepath}")

def get_all_crash_data() -> None:
    if not os.path.exists(RAWDIR):
        os.makedirs(RAWDIR)

    for dtype, fid in [
        (CrashDataType.COLLISIONS, CRASH_COLLISION_ID), 
        (CrashDataType.VEHICLES, CRASH_VEHICLE_ID), 
        (CrashDataType.PERSONS, CRASH_PERSONS_ID),
    ]:
        fp = f"{RAWDIR}/data_raw_{dtype.value.lower()}.csv"
        fetch_data(id=fid, name=dtype.value, filepath=fp)

if __name__ == "__main__":
    get_all_crash_data() 
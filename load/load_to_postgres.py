import os
import pandas as pd
from sqlalchemy import create_engine, schema, text
from dotenv import load_dotenv
from typing import Optional

load_dotenv()

POSTGRES_URL = os.getenv("POSTGRES_URL")
if not POSTGRES_URL:
    raise RuntimeError("POSTGRES_URL not set in .env")

RAWDIR = os.getenv("RAWDIR")
if not RAWDIR:
    raise RuntimeError("RAWDIR not set in .env")

engine = create_engine(POSTGRES_URL)

RAW_SCHEMA = "raw"
CLEAN_SCHEMA = "clean"
ANALYTICS_SCHEMA = "analytics"

def load_table(
        df_raw: pd.DataFrame, 
        df_clean: pd.DataFrame,
        table_name: str, 
        pkey: Optional[str] = None, 
        indices: Optional[dict[str, str]] = None,
) -> None:
    """Load a dataframe into PostgreSQL, replacing if exists"""
    print(
        f"Loading {len(df_raw)} rows into {RAW_SCHEMA}.{table_name} and {len(df_clean)} rows into {CLEAN_SCHEMA}.{table_name}..."
    )
    with engine.begin() as conn:
        df_raw.to_sql(table_name, conn, schema=RAW_SCHEMA, if_exists="replace", index=False)
        df_clean.to_sql(table_name, conn, schema=CLEAN_SCHEMA, if_exists="replace", index=False)

        if pkey:
            conn.execute(text(f'ALTER TABLE {CLEAN_SCHEMA}.{table_name} ADD PRIMARY KEY ({pkey})'))

        for ind, ind_name in (indices or dict()).items():
            conn.execute(text(f'CREATE INDEX {ind_name} ON {CLEAN_SCHEMA}.{table_name} ({ind})'))

    print(f"✅ {RAW_SCHEMA}.{table_name} loaded successfully")
    print(f"✅ {CLEAN_SCHEMA}.{table_name} loaded successfully")

def _standardize_string_columns(df: pd.DataFrame, cols: list[str]) -> pd.DataFrame:
    """Helper function to standardize string columns by uppercasing and stripping whitespace"""
    for col in cols:
        df[col] = df[col].str.upper().str.strip()
    return df

def clean_and_load_data():
    """
    This is a very simple cleaning function that drops duplicates and standardizes string columns that
    are in use in the analysis. In a real system, we'd want to add much more robust cleaning and validation, 
    do stricter type checking/conversions, etc. Keeping things simple for this exercise.
    """
    with engine.begin() as conn:
        # create schemas if not exist
        for sc in [RAW_SCHEMA, CLEAN_SCHEMA, ANALYTICS_SCHEMA]:
            conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {sc}"))

    # Load crashes
    df_crashes = pd.read_csv(f"{RAWDIR}/data_raw_collisions.csv")
    df_crashes_clean = df_crashes.drop_duplicates()
    df_crashes_clean = _standardize_string_columns(
        df_crashes_clean, 
        [
            "borough", 
            "contributing_factor_vehicle_1", "contributing_factor_vehicle_2",
            "contributing_factor_vehicle_3", "contributing_factor_vehicle_4",
            "contributing_factor_vehicle_5"
        ]
    )
    load_table(
        df_raw=df_crashes, df_clean=df_crashes_clean, 
        table_name="collisions", pkey="collision_id"
    )

    # Load vehicles
    df_vehicles = pd.read_csv(f"{RAWDIR}/data_raw_vehicles.csv")
    df_vehicles_clean = df_vehicles.drop_duplicates()
    df_vehicles_clean = _standardize_string_columns(
        df_vehicles_clean, 
        [
            "vehicle_type",
            "contributing_factor_1", "contributing_factor_2",
        ]
    )
    load_table(
        df_raw=df_vehicles, df_clean=df_vehicles_clean, 
        table_name="collision_vehicles", pkey="unique_id", 
        indices={"collision_id": "idx_vehicle_collision_id", "vehicle_id": "idx_vehicle_id"}
    )

    # Load persons
    df_persons = pd.read_csv(f"{RAWDIR}/data_raw_persons.csv")
    df_persons_clean = df_persons.drop_duplicates()
    df_persons_clean = _standardize_string_columns(
        df_persons_clean, 
        ["person_type", "person_sex", "safety_equipment"]
    ) 

    # set invalid ages to null
    df_persons_clean.loc[df_persons_clean["person_age"] > 122, "person_age"] = None
    df_persons_clean.loc[df_persons_clean["person_age"] < 0, "person_age"] = None 

    # standardize the sex field
    df_persons_clean.loc[~df_persons_clean["person_sex"].isin(["M", "F", "U"]), "person_sex"] = "U"  
    load_table(
        df_raw=df_persons, df_clean=df_persons_clean, table_name="collision_persons", 
        pkey="unique_id", 
        indices={"collision_id": "idx_person_collision_id", "person_id": "idx_person_id"}
    )

if __name__ == "__main__":
    clean_and_load_data()
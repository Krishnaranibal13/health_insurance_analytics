import os
import urllib.parse
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

load_dotenv()

# 1. Database Credentials
# We use urllib.parse to safely encode your password just in case it has special characters like @ or #
db_user = os.getenv("DB_USER")
db_password = urllib.parse.quote_plus(os.getenv("DB_PASSWORD"))
db_host = os.getenv("DB_HOST")
db_port = os.getenv("DB_PORT")
db_name = os.getenv("DB_NAME")

# 2. The Connection String
SQLALCHEMY_DATABASE_URL = f"mysql+pymysql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"

# 3. Create the Engine (The actual bridge to MySQL)
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# 4. Create a SessionLocal class (This is what will spawn individual database conversations)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# 5. Create a Base class (Our Python models will inherit from this to know they are database tables)
Base = declarative_base()
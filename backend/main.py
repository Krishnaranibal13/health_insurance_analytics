from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
import models
from database import SessionLocal, engine

# Initialize the app
app = FastAPI(title="HealthPulse Analytics API")

# Define a "Route" (an endpoint the frontend can hit)
@app.get("/")
def read_root():
    return {"status": "success", "message": "Welcome to the HealthPulse API"}

@app.get("/api/test")
def test_endpoint():
    return {"data": [1, 2, 3, 4], "description": "This is dummy data"}

# Create the database tables (if they don't exist)
models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# Dependency to get a DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/members/{member_id}")
def get_member(member_id: int, db: Session = Depends(get_db)):
    member = db.query(models.Member).filter(models.Member.member_id == member_id).first()
    if not member:
        raise HTTPException(status_code=404, detail="Member not found")
    return member
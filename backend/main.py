from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
import models
from database import SessionLocal, engine
from typing import List

# Create the database tables in MySQL if they don't exist
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="HealthPulse Analytics API")

# Dependency to get a DB session for each request
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# --- BASIC ENDPOINTS ---

@app.get("/")
def read_root():
    return {"message": "HealthPulse API is Live"}

@app.get("/members/{member_id}")
def get_member(member_id: int, db: Session = Depends(get_db)):
    member = db.query(models.Member).filter(models.Member.member_id == member_id).first()
    if not member:
        raise HTTPException(status_code=404, detail="Member not found")
    return member

# --- ANALYTICS ENDPOINTS (For Dashboard Charts) ---

@app.get("/api/stats/summary")
def get_summary_stats(db: Session = Depends(get_db)):
    """Returns high-level KPIs for the dashboard header cards."""
    total_members = db.query(models.Member).count()
    
    # Calculate total claims value
    total_claims = db.query(func.sum(models.Claim.amount)).scalar()
    
    # Calculate average heart rate across entire population
    avg_heart_rate = db.query(func.avg(models.Member.heart_rate)).scalar()
    
    return {
        "total_members": total_members,
        "total_claims_value": round(float(total_claims), 2) if total_claims else 0,
        "average_heart_rate": round(float(avg_heart_rate), 1) if avg_heart_rate else 0
    }

@app.get("/api/stats/claims-trend")
def get_claims_trend(db: Session = Depends(get_db)):
    """Returns monthly claim totals for a line chart."""
    results = db.query(
        func.date_format(models.Claim.date, '%Y-%m').label('month'),
        func.sum(models.Claim.amount).label('total')
    ).group_by('month').order_by('month').all()
    
    return [{"month": r.month, "total": float(r.total)} for r in results]

@app.get("/api/stats/members-by-state")
def get_members_by_state(db: Session = Depends(get_db)):
    """Returns member counts by state for a geographic map or bar chart."""
    results = db.query(
        models.Member.State, 
        func.count(models.Member.member_id).label('count')
    ).group_by(models.Member.State).all()
    
    return [{"state": r.State, "count": r.count} for r in results]
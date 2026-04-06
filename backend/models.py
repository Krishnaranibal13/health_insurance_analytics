from sqlalchemy import Column, Integer, String, Date, ForeignKey, Numeric, Enum, SmallInteger, Boolean
from database import Base

class Member(Base):
    __tablename__ = "MEMBERS"

    member_id = Column(Integer, primary_key=True, index=True)
    DOB = Column(Date)
    Sex = Column(Enum('F', 'M', 'O'))
    State = Column(String(2))
    Weight = Column(Numeric(6, 2))
    Height = Column(Numeric(5, 2))
    heart_rate = Column(SmallInteger)
    blood_pressure = Column(String(15))
    blood_oxygen = Column(SmallInteger)
    smoker = Column(Boolean)
    drinker = Column(Boolean)
    housing_insecurity = Column(Boolean)
    employment_status = Column(Boolean)
    hours_sleep_per_day = Column(Numeric(4, 1))
    minutes_exercise_per_week = Column(SmallInteger)
    
    # These match the foreign keys in your ERD [cite: 1, 14, 17, 38, 39]
    Primary_Care_Facility_ID = Column(Integer, ForeignKey("FACILITY.Facility_ID"))
    Insurance_ID = Column(Integer, ForeignKey("INSURANCE.insurance_id"))
    Enrollment_ID = Column(Integer, ForeignKey("ENROLLMENT.Enrollment_ID"))
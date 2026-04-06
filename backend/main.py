from fastapi import FastAPI

# Initialize the app
app = FastAPI(title="HealthPulse Analytics API")

# Define a "Route" (an endpoint the frontend can hit)
@app.get("/")
def read_root():
    return {"status": "success", "message": "Welcome to the HealthPulse API"}

@app.get("/api/test")
def test_endpoint():
    return {"data": [1, 2, 3, 4], "description": "This is dummy data"}
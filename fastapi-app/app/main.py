# fastapi-app/app/main.py

from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, this is shubham creating a new devops project no-3"}
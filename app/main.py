from fastapi import FastAPI
from .db import get_connection
from .cache import r
import time
import random

app = FastAPI()


@app.get("/")
def root():
    return {"status": "ok"}


@app.get("/data")
def data():
    cached = r.get("data")

    if cached:
        return {"source": "cache", "data": cached.decode()}

    conn = get_connection()
    cur = conn.cursor()

    cur.execute("SELECT now();")
    result = str(cur.fetchone())

    cur.close()
    conn.close()

    r.set("data", result, ex=10)

    return {"source": "db", "data": result}


@app.get("/db-stress")
def db_stress():
    conns = []
    for _ in range(50):  
        conns.append(get_connection())

    time.sleep(5)

    for c in conns:
        c.close()

    return {"status": "stressed DB"}


@app.get("/slow")
def slow():
    time.sleep(3)
    return {"status": "slow response"}


@app.get("/random-fail")
def random_fail():
    if random.random() < 0.5:
        raise Exception("Random failure occurred")
    return {"status": "success"}


@app.get("/cache-break")
def cache_break():
    r.flushall()
    return {"status": "cache cleared"}
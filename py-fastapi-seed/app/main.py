from fastapi import FastAPI
from app import crud, probes, config

app = FastAPI(title="FastAPI CRUD App" + config.HELLO_MESSAGE)

# Probes
app.include_router(probes.router, tags=["Probes"])

# CRUD
app.include_router(crud.router, prefix="/items", tags=["Items"])

if __name__ == "__main__":
    import uvicorn

    uvicorn.run("app.main:app", host="0.0.0.0", port=config.PORT, reload=True)

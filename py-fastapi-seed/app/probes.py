from fastapi import APIRouter
import importlib.metadata
import os

router = APIRouter()


def get_commit_id():
    # In OpenShift, commit id is often injected as an env variable (e.g., GIT_COMMIT or SOURCE_COMMIT)
    commit_id = os.getenv("GIT_COMMIT") or os.getenv("SOURCE_COMMIT")
    if commit_id:
        return commit_id[:7]  # short hash
    # fallback to git if running locally
    try:
        import subprocess

        return (
            subprocess.check_output(["git", "rev-parse", "--short", "HEAD"])
            .decode("utf-8")
            .strip()
        )
    except Exception:
        return None


@router.get("/info")
def info():
    try:
        version = importlib.metadata.version("py-fastapi-seed")
    except importlib.metadata.PackageNotFoundError:
        version = "0.1.0"  # fallback if not installed as a package
    commit_id = get_commit_id()
    build_time = os.getenv("BUILD_TIMESTAMP")
    return {
        "app": "FastAPI CRUD",
        "version": version,
        "commitId": commit_id,
        "buildTime": build_time,
    }


@router.get("/health")
def health():
    return {"status": "healthy"}


@router.get("/liveness")
def liveness():
    return {"status": "alive"}


@router.get("/readiness")
def readiness():
    return {"status": "ready"}

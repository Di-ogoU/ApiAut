from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.dependencies import get_car_service, set_car_service
from app.models.car import HealthResponse
from app.routers.cars import router as cars_router
from app.routers.recommendations import router as recommendations_router
from app.routers.stats import router as stats_router
from app.services.car_service import CarService
from app.services.dataset_loader import load_dataset


@asynccontextmanager
async def lifespan(_: FastAPI):
    dataset = load_dataset()
    set_car_service(CarService(dataset))
    yield


app = FastAPI(title="Recomendador de autos API", lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
@app.get("/health", response_model=HealthResponse)
def health() -> HealthResponse:
    service = get_car_service()
    return HealthResponse(
        status="ok",
        dataset_loaded=True,
        total_records=len(service.dataset),
    )


app.include_router(cars_router)
app.include_router(recommendations_router)
app.include_router(stats_router)

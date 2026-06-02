from fastapi import APIRouter, Depends

from app.dependencies import get_car_service
from app.services.car_service import CarService

router = APIRouter(tags=["stats"])


@router.get("/stats/classes")
def get_class_stats(service: CarService = Depends(get_car_service)) -> dict[str, int]:
    return service.class_counts()

from fastapi import APIRouter, Depends, HTTPException, Query

from app.dependencies import get_car_service
from app.models.car import CarEvaluateRequest, CarsResponse, EvaluateResponse
from app.services.car_service import CarService

router = APIRouter(tags=["cars"])


@router.get("/cars", response_model=CarsResponse)
def get_cars(
    buying: str | None = None,
    maint: str | None = None,
    doors: str | None = None,
    persons: str | None = None,
    lug_boot: str | None = Query(default=None, alias="lug_boot"),
    safety: str | None = None,
    class_name: str | None = Query(default=None, alias="class_name"),
    limit: int = Query(default=20, ge=1, le=100),
    service: CarService = Depends(get_car_service),
) -> CarsResponse:
    filters = {
        "buying": buying,
        "maint": maint,
        "doors": doors,
        "persons": persons,
        "lug_boot": lug_boot,
        "safety": safety,
        "class_name": class_name,
    }
    items = service.filter_cars(filters, limit)
    return CarsResponse(total=len(items), items=items)


@router.post("/evaluate", response_model=EvaluateResponse)
def evaluate_car(
    request: CarEvaluateRequest,
    service: CarService = Depends(get_car_service),
) -> EvaluateResponse:
    item = service.evaluate(request)
    if item is None:
        raise HTTPException(status_code=404, detail="No se encontró la combinación solicitada")
    return EvaluateResponse(item=item, message=service.evaluate_message(item["class_name"]))

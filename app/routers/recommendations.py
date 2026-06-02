from fastapi import APIRouter, Depends, HTTPException, Query

from app.dependencies import get_car_service
from app.models.car import RecommendationsResponse
from app.services.car_service import CarService

router = APIRouter(tags=["recommendations"])


@router.get("/recommendations", response_model=RecommendationsResponse)
def get_recommendations(
    priority: str = Query(...),
    limit: int = Query(default=10, ge=1, le=100),
    service: CarService = Depends(get_car_service),
) -> RecommendationsResponse:
    try:
        items = service.recommend(priority, limit)
    except ValueError as error:
        raise HTTPException(status_code=400, detail=str(error)) from error
    return RecommendationsResponse(priority=priority, total=len(items), items=items)

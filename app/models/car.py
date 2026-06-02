from pydantic import BaseModel, Field


class CarItem(BaseModel):
    buying: str
    maint: str
    doors: str
    persons: str
    lug_boot: str
    safety: str
    class_name: str = Field(alias="class_name")

    class Config:
        allow_population_by_field_name = True


class CarEvaluateRequest(BaseModel):
    buying: str
    maint: str
    doors: str
    persons: str
    lug_boot: str
    safety: str


class CarsResponse(BaseModel):
    total: int
    items: list[CarItem]


class EvaluateResponse(BaseModel):
    item: CarItem
    message: str


class RecommendationsResponse(BaseModel):
    priority: str
    total: int
    items: list[CarItem]


class HealthResponse(BaseModel):
    status: str
    dataset_loaded: bool
    total_records: int

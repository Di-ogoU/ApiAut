from app.services.car_service import CarService


car_service: CarService | None = None


def set_car_service(service: CarService) -> None:
    global car_service
    car_service = service


def get_car_service() -> CarService:
    if car_service is None:
        raise RuntimeError("El dataset no está cargado")
    return car_service

import csv
from pathlib import Path


DATA_COLUMNS = (
    "buying",
    "maint",
    "doors",
    "persons",
    "lug_boot",
    "safety",
    "class_name",
)


def load_dataset() -> list[dict[str, str]]:
    data_path = Path(__file__).resolve().parent.parent / "data" / "car.data"
    if not data_path.exists():
        raise FileNotFoundError(f"Dataset no encontrado en: {data_path}")

    items: list[dict[str, str]] = []
    with data_path.open("r", encoding="utf-8", newline="") as dataset_file:
        reader = csv.reader(dataset_file)
        for row in reader:
            if len(row) != 7:
                continue
            items.append(dict(zip(DATA_COLUMNS, row)))
    return items

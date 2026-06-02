from collections import Counter

from app.models.car import CarEvaluateRequest


CLASS_ORDER = {"vgood": 0, "good": 1, "acc": 2, "unacc": 3}
BUYING_ORDER = {"low": 0, "med": 1, "high": 2, "vhigh": 3}
MAINT_ORDER = {"low": 0, "med": 1, "high": 2, "vhigh": 3}
DOORS_ORDER = {"5more": 0, "4": 1, "3": 2, "2": 3}
PERSONS_ORDER = {"more": 0, "4": 1, "2": 2}
LUG_BOOT_ORDER = {"big": 0, "med": 1, "small": 2}
SAFETY_ORDER = {"high": 0, "med": 1, "low": 2}
CLASS_LABELS = {
    "unacc": "No recomendable",
    "acc": "Aceptable",
    "good": "Bueno",
    "vgood": "Muy bueno",
}


class CarService:
    def __init__(self, dataset: list[dict[str, str]]) -> None:
        self.dataset = dataset

    def filter_cars(self, filters: dict[str, str | None], limit: int) -> list[dict[str, str]]:
        items = [item for item in self.dataset if self._matches(item, filters)]
        items.sort(key=self._balanced_sort_key)
        return items[:limit]

    def evaluate(self, request: CarEvaluateRequest) -> dict[str, str] | None:
        filters = request.dict()
        for item in self.dataset:
            if self._matches(item, filters):
                return item
        return None

    def evaluate_message(self, class_name: str) -> str:
        return f"Auto clasificado como {CLASS_LABELS.get(class_name, class_name)}"

    def recommend(self, priority: str, limit: int) -> list[dict[str, str]]:
        handlers = {
            "economic": self._economic_candidates,
            "family": self._family_candidates,
            "safe": self._safe_candidates,
            "balanced": self._balanced_candidates,
        }
        if priority not in handlers:
            raise ValueError("Priority inválida")

        items = handlers[priority]()
        return items[:limit]

    def class_counts(self) -> dict[str, int]:
        counts = Counter(item["class_name"] for item in self.dataset)
        return {
            "unacc": counts.get("unacc", 0),
            "acc": counts.get("acc", 0),
            "good": counts.get("good", 0),
            "vgood": counts.get("vgood", 0),
        }

    def _matches(self, item: dict[str, str], filters: dict[str, str | None]) -> bool:
        for key, value in filters.items():
            if value is None:
                continue
            if item.get(key) != value:
                return False
        return True

    def _economic_candidates(self) -> list[dict[str, str]]:
        items = [
            item
            for item in self.dataset
            if item["buying"] in {"low", "med"}
            and item["maint"] in {"low", "med"}
            and item["class_name"] != "unacc"
        ]
        items.sort(
            key=lambda item: (
                CLASS_ORDER[item["class_name"]],
                BUYING_ORDER[item["buying"]],
                MAINT_ORDER[item["maint"]],
                SAFETY_ORDER[item["safety"]],
            )
        )
        return items

    def _family_candidates(self) -> list[dict[str, str]]:
        items = [
            item
            for item in self.dataset
            if item["persons"] in {"4", "more"}
            and item["doors"] in {"4", "5more"}
            and item["lug_boot"] in {"med", "big"}
            and item["class_name"] != "unacc"
        ]
        items.sort(
            key=lambda item: (
                CLASS_ORDER[item["class_name"]],
                PERSONS_ORDER[item["persons"]],
                DOORS_ORDER[item["doors"]],
                LUG_BOOT_ORDER[item["lug_boot"]],
                SAFETY_ORDER[item["safety"]],
            )
        )
        return items

    def _safe_candidates(self) -> list[dict[str, str]]:
        items = [
            item
            for item in self.dataset
            if item["safety"] == "high" and item["class_name"] != "unacc"
        ]
        items.sort(
            key=lambda item: (
                CLASS_ORDER[item["class_name"]],
                BUYING_ORDER[item["buying"]],
                MAINT_ORDER[item["maint"]],
                PERSONS_ORDER[item["persons"]],
            )
        )
        return items

    def _balanced_candidates(self) -> list[dict[str, str]]:
        items = [
            item
            for item in self.dataset
            if item["class_name"] in {"good", "vgood"}
            and item["buying"] != "vhigh"
            and item["maint"] != "vhigh"
            and item["safety"] in {"med", "high"}
        ]
        items.sort(key=self._balanced_sort_key)
        return items

    def _balanced_sort_key(self, item: dict[str, str]) -> tuple[int, int, int, int, int, int]:
        return (
            CLASS_ORDER[item["class_name"]],
            SAFETY_ORDER[item["safety"]],
            BUYING_ORDER[item["buying"]],
            MAINT_ORDER[item["maint"]],
            PERSONS_ORDER[item["persons"]],
            LUG_BOOT_ORDER[item["lug_boot"]],
        )

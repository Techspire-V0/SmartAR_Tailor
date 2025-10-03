from jaxtyping import Float, jaxtyped
from beartype import beartype
from pathlib import Path
import torch

class Camera:
    def __init__(self, intrinsics: Float[torch.Tensor, "2"], w: int, h: int, path: Path):
        self.fx = intrinsics[0]
        self.fy = intrinsics[1]
        self.cx = w / 2
        self.cy = h / 2
        self.w = w
        self.h = h
        self.cameras_path = path / "cameras.txt"
        self.write_camera()

    def __str__(self):
        self.cameras_path

    @property
    def intrinsics(self):
        return [self.fx, self.fy, self.cx, self.cy]

    def write_camera(self):
        pass

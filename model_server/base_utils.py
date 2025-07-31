import numpy as np
from jaxtyping import Float, jaxtyped
from beartype import beartype
import torch
import torch.nn.functional as F
import torch

def normalize(v):
    return v / np.linalg.norm(v)


def point_dist(p1: Float[torch.Tensor, "2"], p2: Float[torch.Tensor, "2"]):
    return torch.linalg.norm(p1-p2)


class InputPadder:
    """ Pads images such that their height and width are divisible by `factor`. """
    def __init__(self, shape, mode='replicate', factor=8):
        self.mode = mode
        self.factor = factor
        h, w = shape[-2:]
        pad_h = (((h // factor) + 1) * factor - h) % factor
        pad_w = (((w // factor) + 1) * factor - w) % factor
        self.pad = [pad_w//2, pad_w - pad_w//2, pad_h//2, pad_h - pad_h//2]
        self.shape = shape

    def add_pad(self, *inputs):
        return [F.pad(x, self.pad, mode=self.mode) for x in inputs]

    def unpad(self, image):
        l, r, t, b = self.pad
        return image[..., t:image.shape[-2]-b, l:image.shape[-1]-r]

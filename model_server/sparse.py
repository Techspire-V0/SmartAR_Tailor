import os
import json
import time
import gc
import cv2
import torch
import shutil
import pathlib
import subprocess
import numpy as np
import torchvision
from PIL import Image
from uuid import uuid4
from tqdm import tqdm
import torch.nn.functional as F
from beartype import beartype
from moviepy.editor import VideoFileClip
from torchvision import transforms
from rembg import remove, new_session
from jaxtyping import Float, jaxtyped
from torchvision.utils import flow_to_image
from typing import List, Tuple

from camera import Camera
from d_types.conts import CORE_LANDMARKS, SHOULD_LANDMARKS
from base_utils import normalize, point_dist, InputPadder


origin_dir = pathlib.Path(__file__).resolve().parent


class Spare:
    height: Tuple[Tuple[int, int], Tuple[int, int]] = None
    real_height_m: float = 0.0
    device = "0"
    device_str = "cuda" if torch.cuda.is_available() else "cpu"
    seg_session = new_session("u2net_human_seg")

    def __init__(self, real_height: float):
        id = str(uuid4())
        self.base_dir = origin_dir / "input_data" / id
        self.base_dir.mkdir(parents=True)
        # self.file = file
        self.real_height_m = real_height

    def pipeline(self):
        self.preprocess()
        recon, output_path, dense_path = self.reconstruct()
        scale_factor = self.compute_metric_scale(reconstruction=recon)
        self.apply_global_scale(recon, scale_factor, output_path)
        self.gen_config(recon)

    def video_to_frames(self):
        video_path = str(origin_dir / "video.mp4")

        # 1. SETUP: Clean up destination directory
        frame_dir = pathlib.Path(self.base_dir) / "images"
        if frame_dir.exists():
            shutil.rmtree(frame_dir)
        frame_dir.mkdir(parents=True)
        self.frame_dir = frame_dir

        # 2. FAST VIDEO LOADING with torchvision
        # This reads the entire video into a tensor. It's fast but memory-intensive.
        # The tensor is (T, H, W, C) in RGB format on the CPU.
        print("Reading video with torchvision...")
        # video_frames, _, _ = torchvision.io.read_video(video_path, pts_unit='sec')
        # video_frames = video_frames.to('cuda')

        #     # --- Process first frame separately to initialize parameters ---
        # first_frame = video_frames[0].cpu().numpy() # Get first frame
        cap = cv2.VideoCapture(video_path)

        # first_frame = cv2.rotate(first_frame, cv2.ROTATE_90_COUNTERCLOCKWISE)
        # h, w, _ = first_frame.shape

        # foreground = remove(first_frame, session=self.seg_session)
        # cv2.imwrite(str(frame_dir / "0001.jpg"), cv2.cvtColor(foreground, cv2.COLOR_RGBA2BGR))

        # 3. BATCH PROCESSING: Process the rest of the video in chunks
        # kept_frame_count = 1
        kept_frame_count = 0
        num_frames_to_keep = 30
        # total_frames_count = len(video_frames)
        total_frames_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
        skip_count = (
            total_frames_count // num_frames_to_keep
        )  # Adjust based on your VRAM

        with tqdm(total=30, desc="Processing Video", unit="frame") as pbar:
            while True:
                ret, frame = cap.read()
                if not ret:
                    break
                if kept_frame_count % skip_count == 0:
                    frame_to_segment = cv2.rotate(frame, cv2.ROTATE_90_COUNTERCLOCKWISE)
                    foreground = remove(frame_to_segment, session=self.seg_session)
                    kept_frame_count += 1
                    frame_id = f"{kept_frame_count:04d}"
                    frame_path = frame_dir / f"{frame_id}.jpg"
                    cv2.imwrite(
                        str(frame_path), cv2.cvtColor(foreground, cv2.COLOR_RGBA2BGR)
                    )
                    pbar.update(1)
                kept_frame_count += 1
        cap.release()

        # for frame_loop_index in tqdm(range(num_frames_to_keep), desc="Processing frames"):
        #     frame_index = (frame_loop_index+1) * skip_count
        #     frame_index = frame_index if frame_index < total_frames_count else total_frames_count - 1
        #     frame_to_segment = video_frames[frame_index].cpu().numpy()
        #     frame_to_segment = cv2.rotate(frame_to_segment, cv2.ROTATE_90_COUNTERCLOCKWISE)

        #     foreground = remove(frame_to_segment, session=self.seg_session)
        #     kept_frame_count += 1
        #     frame_id = f"{kept_frame_count:04d}"
        #     frame_path = frame_dir / f"{frame_id}.jpg"
        #     cv2.imwrite(str(frame_path), cv2.cvtColor(foreground, cv2.COLOR_RGBA2BGR))

        print(
            f"\n✅ Finished. Selected and saved {kept_frame_count} frames to {frame_dir}"
        )
        return frame_dir

    def preprocess(self):
        # Extract frames
        pre_frames_dir = self.video_to_frames()
        print(f"Extracted frames to {pre_frames_dir}")

        env = os.environ.copy()
        env["ROOT_PATH"] = pre_frames_dir
        current_dir = os.getcwd()
        target_dir = os.path.abspath(os.path.join(current_dir, "./eva_avatar"))
        # Run the shell script with the environment variable set
        subprocess.run(
            ["bash", "Full_running_command.sh"],
            cwd=target_dir,
            capture_output=True,
            env=env,
            text=True,
            check=True,
        )

    # @jaxtyped(typechecker=beartype)
    def comput_height(
        self,
        mask_img: np.uint8,
        foot_l: Float[torch.Tensor, "2"],
        hip_l: Float[torch.Tensor, "2"],
        foot_r: Float[torch.Tensor, "2"],
        hip_r: Float[torch.Tensor, "2"],
    ):

        # mask_image: binary image or alpha channel where foreground = 255
        # Find topmost y where any foreground pixel exists
        coords = np.where(mask_img)
        top_y = np.min(coords[0])
        top_x_coords = coords[1][coords[0] == top_y]
        # Take the center x-coordinate if multiple pixels at same height
        top_x = int(np.mean(top_x_coords))
        ref_top = (top_x, int(top_y))

        # get  middle
        foot_y = max(foot_l.y, foot_r.y)
        ref_foot = foot_r if foot_y == foot_r.y else foot_l
        ref_hip = hip_r if foot_y == foot_r.y else hip_l
        leg_length = point_dist([ref_foot.x, ref_foot.y], [ref_hip.x, ref_hip.y])
        ref_hip.y += leg_length
        ref_bottom = (ref_top[0], int(ref_hip.y * self.camera.h))

        return ref_top, ref_bottom

    def compute_metric_scale(
        self,
        reconstruction,
    ):
        head_px, foot_px = self.height
        # Get the image's camera pose
        images = list(reconstruction.images.values())
        # Sort by the image name
        images_sorted = sorted(images, key=lambda img: img.name)
        image = images_sorted[0]

        # Camera extrinsics
        R = image.cam_from_world.rotation.matrix()  # 3x3 rotation matrix
        t = image.cam_from_world.translation.reshape((3, 1))  # 3x1 translation

        # Backproject head and foot into rays (camera coords)
        head_ray_cam = normalize(
            np.array(
                [
                    (head_px[0] - self.camera.cx) / self.camera.fx,
                    (head_px[1] - self.camera.cy) / self.camera.fy,
                    1.0,
                ]
            )
        )

        foot_ray_cam = normalize(
            np.array(
                [
                    (foot_px[0] - self.camera.cx) / self.camera.fx,
                    (foot_px[1] - self.camera.cy) / self.camera.fy,
                    1.0,
                ]
            )
        )

        # Convert camera rays to world coords
        head_ray_world = R.T @ head_ray_cam
        foot_ray_world = R.T @ foot_ray_cam
        cam_center = -R.T @ t

        # Pick a fixed distance along each ray (e.g., 1m) and get 3D points
        head_3d = cam_center + head_ray_world
        foot_3d = cam_center + foot_ray_world

        # Get estimated height in 3D
        est_height = np.linalg.norm(head_3d - foot_3d)

        # Compute scaling factor
        scale = self.real_height_m / est_height

        return scale, est_height

    def apply_global_scale(self, reconstruction, scale: float, output_dir: str):
        # Scale all camera translations
        for img in reconstruction.images.values():
            if img.has_pose:
                img.cam_from_world.translation *= scale

        # Scale all 3D points
        for point in reconstruction.points3D.values():
            point.xyz *= scale

        reconstruction.write(output_dir)

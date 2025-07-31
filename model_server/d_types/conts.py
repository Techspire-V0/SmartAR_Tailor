from typing import List

ALLOWED_MIME_TYPES = {"video/mp4", "video/quicktime", "video/x-matroska"}


SHOULD_LANDMARKS: List[int] = [23
    # mp.solutions.pose.PoseLandmark.LEFT_SHOULDER,
    # mp.solutions.pose.PoseLandmark.RIGHT_SHOULDER,
]

CORE_LANDMARKS: List[int] = [23
    # *SHOULD_LANDMARKS,
    # mp.solutions.pose.PoseLandmark.LEFT_ELBOW,
    # mp.solutions.pose.PoseLandmark.RIGHT_ELBOW,
    # mp.solutions.pose.PoseLandmark.LEFT_HIP,
    # mp.solutions.pose.PoseLandmark.RIGHT_HIP,
    # mp.solutions.pose.PoseLandmark.LEFT_KNEE,
    # mp.solutions.pose.PoseLandmark.RIGHT_KNEE,
]

from fastapi import FastAPI, UploadFile, File, Form, Request, HTTPException
from fastapi.responses import JSONResponse
from d_types import conts
from torch import Tensor
from jaxtyping import Float, jaxtyped
from beartype import beartype
from sparse import Spare
import pathlib
import sys
app = FastAPI()

base_url = pathlib.Path().resolve().parent
sys.path.append(f"{base_url}/eva_avatars")

# @app.get("/")
# @jaxtyped(typechecker=beartype)
# async def get_model(
#     video: UploadFile = File(...), instrinsics: Float[Tensor, "4"] = Form(...)
# ):
#     # authorize

#     # check inputs
#     if video.content_type not in conts.ALLOWED_MIME_TYPES:
#         raise HTTPException(status_code=400, detail="Invalid Inputs")
#     if isinstance(instrinsics, Float[Tensor, "4"]):

#         raise HTTPException(status_code=400, detail="Invalid Inputs")

#     file = video.read()

#     return {"message": "Hello World"}


if __name__ == "__main__":
    # get_model()
    s = Spare(real_height=1.7272)
    s.video_to_frames()

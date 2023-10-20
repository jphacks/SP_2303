import os

ORIGIN = "http://localhost:8000"  # TODO: 環境変数で指定する

PUBLIC_MEDIA_PATH = "/media/"
PUBLIC_MEDIA_IMAGE_PATH = os.path.join(PUBLIC_MEDIA_PATH, "images/")
PUBLIC_MEDIA_IMAGE_ANONYMOUS_POST_PATH = os.path.join(
    PUBLIC_MEDIA_IMAGE_PATH, "anonymous-post/"
)

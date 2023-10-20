from logging import DEBUG, INFO, Formatter, Handler, Logger, StreamHandler, getLogger


def get_logger() -> Logger:
    logger = getLogger("gohan_map")
    logger = _set_handler(logger, StreamHandler(), True)
    logger.setLevel(DEBUG)
    logger.propagate = False
    return logger


def _set_handler(logger: Logger, handler: Handler, verbose: bool) -> Logger:
    if verbose:
        handler.setLevel(DEBUG)
    else:
        handler.setLevel(INFO)
    handler.setFormatter(
        Formatter(
            "[%(levelname)s] %(asctime)s - %(filename)s:%(lineno)ss  - %(message)s"
        )
    )
    logger.addHandler(handler)
    return logger

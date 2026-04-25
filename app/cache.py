import redis
from .config import *

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT)
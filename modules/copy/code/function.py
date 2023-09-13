import json
import logging
import os
import sys
from urllib.parse import urlparse

import boto3


class Env(object):
    def __init__(self):
        self.LOG_LEVEL = {
            "": logging.INFO,
            "DEBUG": logging.DEBUG,
            "INFO": logging.INFO,
            "WARNING": logging.WARNING,
        }.get(os.environ.get("LOG_LEVEL", ""))

        if self.LOG_LEVEL is None:
            raise ValueError(
                "unknown value provided for LOG_LEVEL. Please select one of DEBUG, INFO or WARNING"
            )

        self.DESTINATION_URI = os.environ.get("DESTINATION_URI")
        if self.DESTINATION_URI is None:
            raise ValueError("no destination URI provided")


try:
    ENV = Env()
except ValueError as e:
    sys.exit(e)

logging.getLogger().setLevel(ENV.LOG_LEVEL)
if len(logging.getLogger().handlers) > 0:
    # handler already configured in lambda
    logging.getLogger().setLevel(ENV.LOG_LEVEL)
else:
    logging.basicConfig(level=ENV.LOG_LEVEL, format="%(asctime)s %(message)s")

# disable dumping request payload
logging.getLogger("botocore").setLevel(logging.CRITICAL)

session = boto3.Session()


def copy(context, src_uri, dst_uri):
    s3 = session.client("s3")
    src = urlparse(src_uri)
    dst = urlparse(dst_uri)

    if not dst.path:
        dst = dst._replace(path=src.path)
    else:
        dst = dst._replace(path=dst.path + src.path.lstrip("/"))

    logging.info(f"copying {src.geturl()} to {dst.geturl()}")
    response = s3.copy_object(
        Bucket=dst.hostname,
        Key=dst.path[1:],  # strip leading slash
        CopySource=src.hostname + src.path,
    )
    logging.debug(response)


def s3_record_handler(record, context):
    try:
        bucket_name = record["s3"]["bucket"]["name"]
        object_key = record["s3"]["object"]["key"]
    except KeyError:
        logging.info(f"failed processing record={json.dumps(record)}")
        raise
    copy(context, f"s3://{bucket_name}/{object_key}", f"{ENV.DESTINATION_URI}")


# handler is invoked from AWS lambda
def handler(event, context):
    if "Records" in event:
        for record in event["Records"]:
            handler(record, context)
        return

    eventSource = event.get("eventSource", "aws:s3")
    try:
        # unwrap SNS
        if "TopicArn" in event:
            handler(json.loads(event.get("Message")), context)
        # unwrap SQS
        elif eventSource == "aws:sqs":
            handler(json.loads(event.get("body")), context)
        # unwrap EventBridge
        elif "detail" in event:
            handler({"s3": event.get("detail")}, context)
        # assume S3 unless told otherwise
        elif eventSource == "aws:s3":
            s3_record_handler(event, context)
        else:
            raise ValueError(f"unrecognized eventSource {eventSource}")
    except Exception as e:
        logging.info(f"failed processing event={json.dumps(event)}")
        raise


if ENV.LOG_LEVEL == logging.DEBUG:
    fs.initialize_s3(fs.S3LogLevel.Debug)

if __name__ == "__main__":
    try:
        src, dst = sys.argv[1:3]
    except ValueError:
        sys.exit("function.py <source_uri> <dest_uri>")
    copy({}, src, dst)

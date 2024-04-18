#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function

import boto3
import json
import logging
import re
import random

from base64 import b64decode

try:
    # For Python 3.0 and later
    from urllib.request import Request, urlopen, URLError, HTTPError
except ImportError:
    # Fall back to Python 2's urllib2
    from urllib2 import Request, urlopen, URLError, HTTPError

HOOK_URL = "slack_url"

CHANNEL = 'monitoring'

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    logger.info("Event: " + str(event))

    contents = json.loads(event["Records"][0]["Sns"]["Message"])
    
    states_dict = {"OK": ":thumbsup:", "INSUFFICIENT_DATA": ":thinking_face:", "ALARM": ":fire:"}
    contents["OldStateValue"] = states_dict.get(contents["OldStateValue"], contents["OldStateValue"])
    contents["NewStateValue"] = states_dict.get(contents["NewStateValue"], contents["NewStateValue"])

    color = '#2596be'

    if contents["NewStateValue"] == ":thumbsup:":
        color = '#2596be'
    if contents["NewStateValue"] == ":thinking_face:":
        color = '#2596be'
    if contents["NewStateValue"] == ":fire:":
        color = '#2596be'

    message = (
        "*<https://console.aws.amazon.com/route53/healthchecks/home|Alarm> \"" + contents["AlarmName"] + "\"*:  \n"
        + "*State*: " + contents["OldStateValue"] + " ⟶ " + contents["NewStateValue"]
        + "\n_ *New state reason*: " + contents["NewStateReason"] +"_")

    slack_message = {
        'channel': CHANNEL,
        'attachments': [{
            'text': message,
            'color': color
        }],
        'username': contents["Trigger"]["MetricName"] + " ( " + contents["Trigger"]["Namespace"] + " )",
        'icon_emoji': ':fire_engine:',
    }

    req = Request(HOOK_URL, json.dumps(slack_message).encode("utf-8"))

    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", slack_message['channel'])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)
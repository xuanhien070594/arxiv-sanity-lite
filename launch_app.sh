#!/bin/bash

export FLASK_APP=serve.py
uv run flask run >> flask.log 2>&1 &

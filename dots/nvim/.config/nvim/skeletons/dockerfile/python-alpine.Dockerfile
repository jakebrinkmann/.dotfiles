FROM python:3.8-alpine

RUN pip install --no-cache-dir \
    awscli==1.19.3 \
    aws-sam-cli==1.17.0 \
    requests==2.23.0

RUN pip install --no-cache-dir \
    black \
    unittest2 \
    pytest \
    pytest-cov \
    pytest-mock \
    cfn-lint

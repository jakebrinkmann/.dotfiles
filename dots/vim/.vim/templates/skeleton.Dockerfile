#
#   docker build --progress=plain -f Dockerfile -t test:0.1.0 .
#
# Use a runtime that is compatible with Lambda
FROM public.ecr.aws/lambda/python:3.9
FROM public.ecr.aws/sam/build-python3.9:1.37-arm64

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=off \
    PYTHONDONTWRITEBYTECODE=true \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_VERSION=1.1.12

# Install the function's dependencies using file requirements.txt
# from your project folder.
COPY poetry.lock pyproject.toml ./
RUN poetry install --no-root

RUN pip3 install -r ../requirements.txt --target "${LAMBDA_TASK_ROOT}"

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "handlers.lambda_handler.salesforce_lambda_handler" ]

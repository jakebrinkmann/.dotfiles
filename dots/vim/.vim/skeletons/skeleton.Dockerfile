# syntax=docker/dockerfile:1
FROM registry.access.redhat.com/ubi8/nodejs-14:latest

# Copy package.json and package-lock.json
COPY package*.json ./

# Install npm production packages 
RUN npm install --production

COPY . /opt/app-root/src

ENV NODE_ENV production
ENV PORT 3000

EXPOSE 3000

CMD ["npm", "start"]
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

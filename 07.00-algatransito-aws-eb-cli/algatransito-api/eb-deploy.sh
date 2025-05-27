#!/bin/bash

# Check if profile is provided
PROFILE=${1:-default}
ENV_NAME=${2:-algatransito-dev}  # Default environment name if not provided
DB_USER=${3:-admin}
DB_PASS=${4:-SenhaForte123!}
DB_NAME=${5:-algatransito}

echo "Deploying to Elastic Beanstalk using profile: $PROFILE"
echo "Target environment: $ENV_NAME"

echo "Database user: $DB_USER"
echo "Database name: $DB_NAME"

# Initialize Elastic Beanstalk (skip if already initialized)
if [ ! -d ".elasticbeanstalk" ]; then
  echo "Initializing EB CLI..."
  eb init --profile $PROFILE
else
  echo "EB already initialized. Updating configuration..."
  sed -i "/profile:/c\  profile: $PROFILE" .elasticbeanstalk/config.yml
fi

# Check if environment exists
echo "Checking environments..."
ENVIRONMENTS=$(eb list --profile $PROFILE | grep -v '^$')

if [[ -z "$ENVIRONMENTS" ]]; then
  # No environments exist, create one
  echo "No environments found. Creating new environment: $ENV_NAME with RDS MySQL 8.0.35"
  eb create $ENV_NAME --profile $PROFILE \
    --instance_type t3a.micro \
    --single \
    --keyname my-mac-high \
    --database \
    --database.engine mysql \
    --database.version 8.0.35 \
    --database.instance db.t3.micro \
    --database.size 20 \
    --database.username $DB_USER \
    --database.password $DB_PASS
else
  # Environment exists, check if our target env exists
  if echo "$ENVIRONMENTS" | grep -q "$ENV_NAME"; then
    echo "Environment $ENV_NAME exists"
    # Set it as default environment
    echo "Setting $ENV_NAME as default environment"
    eb use $ENV_NAME --profile $PROFILE
  else
    # Our target environment doesn't exist
    echo "Environment $ENV_NAME not found. Available environments:"
    echo "$ENVIRONMENTS"
    
    # Ask user what to do
    echo "Do you want to:"
    echo "1. Create new environment: $ENV_NAME with RDS MySQL 8.0.35"
    echo "2. Use an existing environment"
    read -p "Enter choice (1/2): " CHOICE
    
    if [ "$CHOICE" == "1" ]; then
      eb create $ENV_NAME --profile $PROFILE \
        --instance_type t3a.micro \
        --single \
        --keyname my-mac-high \
        --database \
        --database.engine mysql \
        --database.version 8.0.35 \
        --database.instance db.t3.micro \
        --database.size 20 \
        --database.username $DB_USER \
        --database.password $DB_PASS
    else
      read -p "Enter name of existing environment to use: " SELECTED_ENV
      eb use $SELECTED_ENV --profile $PROFILE
      ENV_NAME=$SELECTED_ENV
    fi
  fi
fi

# Deploy to the environment
echo "Deploying to environment: $ENV_NAME"
eb deploy --profile $PROFILE

echo "Deployment completed!"

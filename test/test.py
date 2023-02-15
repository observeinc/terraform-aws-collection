import subprocess
import argparse
import os

AWS_PROFILE = os.environ["AWS_PROFILE"]

parser = argparse.ArgumentParser()
parser.add_argument("--all-regions", action="store_true", default=False)
args = parser.parse_args()
if args.all_regions:
    regions = [
        "us-east-1",
        "us-east-2",
        "us-west-1",
        "us-west-2",
        "ap-south-1",
        "ap-northeast-1",
        "ap-northeast-2",
        "ap-northeast-3",
        "ap-southeast-1",
        "ap-southeast-2",
        "eu-central-1",
        "eu-west-1",
        "eu-west-2",
        "eu-west-3",
        "eu-north-1",
        "sa-east-1",
    ]
else:
    regions = ["us-west-2"]

for region in regions:
    command = f"""
terraform init -upgrade -no-color
AWS_REGION={region} AWS_PROFILE={AWS_PROFILE} terraform apply -auto-approve -no-color -var="name=observe-${{USER}}"
terraform output
RESULT=$(terraform output -json result)
if [ "$RESULT" != "true" ]; then
    echo "Test failed"
    exit 1
fi
# Comment this to not destroy
AWS_REGION={region} AWS_PROFILE={AWS_PROFILE} terraform destroy -auto-approve -no-color -var="name=observe-${{USER}}"
"""
    print(f"runnning the following: {command}")
    subprocess.check_call(command, shell=True)

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/x2q3v6u1
docker build -t debenstack-lychee-base .
docker tag debenstack-lychee-base:latest public.ecr.aws/x2q3v6u1/debenstack-lychee-base:latest
docker push public.ecr.aws/x2q3v6u1/debenstack-lychee-base:latest
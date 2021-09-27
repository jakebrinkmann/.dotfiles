cd /tmp

arch=amd64
curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-${arch}"

mkdir -p ~/.local/bin
mv "gitlab-runner-linux-${arch}" ~/.local/bin/gitlab-runner
chmod +x ~/.local/bin/gitlab-runner

# Run Job: `gitlab-runner exec docker "lambda:lint"`
# List Jobs: `grep -E "^\w*:" .gitlab-ci.yml`

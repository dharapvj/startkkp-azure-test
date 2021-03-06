# start.kubermatic - Manual Deployment Steps for GitHub

Here's the list of exact steps to be followed if you want to validate everything yourself
(without having that delivered with GitHub Actions / Workflows).

This can be handy for testing everything locally, understanding the whole flow and to be able to customize
for your needs later on.

## Preparation

### Required Tools

 * `git`
 * `terraform` (1.0.4+)
 * `kubeone` (1.3.0+)
 * `sops` (3.7.1+)
 * `flux` v2 (0.16.1+)

### Setup environment variables

```bash
# from GitHub settings
export GITHUB_TOKEN=<GITHUB_TOKEN>
# your GitHub owner / username / organization
export GITHUB_OWNER=<GITHUB_OWNER>
# your GitHub repository name
export GITHUB_REPOSITORY=<GITHUB_REPOSITORY>
```

### Prepare GitHub repository

```bash
gh auth login
gh repo create --private $GITHUB_OWNER/$GITHUB_REPOSITORY
git init
git checkout -b main
# do not add .github directory!
git add README.md .gitignore flux/ kubermatic/ terraform/ kubeone/
git commit -m "Initial setup for KKP on Autopilot"
git remote add origin git@github.com:$GITHUB_OWNER/$GITHUB_REPOSITORY.git
git push -u origin main
```

## Deployment

### Prepare SSH key pair

```bash
ssh-keygen -t rsa -b 4096 -C "<ADMIN_EMAIL>" -f ~/.ssh/k8s_rsa
```

_*Note*:_ Make sure you don't have a passphrase set on the private key as it would cause an issue in automated pipeline.

If you choose a different location for the key, make sure to update the `ssh_public_key_file` variable in `terraform/main.tf`!

### Prepare infrastructure with Terraform

```bash
cd terraform
terraform init
terraform apply
terraform output -json > output.json
cd ..
```

### Initialize k8s cluster with KubeOne

```bash
cd kubeone
eval `ssh-agent`
ssh-add ~/.ssh/k8s_rsa
kubeone apply -m kubeone.yaml -t ../terraform/output.json -y -v
export KUBECONFIG=`pwd`/friendly-easley-kubeconfig
cd ..
```

### Deploy KKP

First we need to decrypt the kkp-config and helm values, put the secret key from secrets.md in `.age.txt`.

```bash
export SOPS_AGE_KEY_FILE=`pwd`/.age.txt
cd kubermatic
sops -d -i config.yaml
sops -d -i values.yaml
export VERSION=v2.20.0
wget https://github.com/kubermatic/kubermatic/releases/download/${VERSION}/kubermatic-ce-${VERSION}-linux-amd64.tar.gz
tar -xzvf kubermatic-ce-${VERSION}-linux-amd64.tar.gz
./kubermatic-installer deploy --config config.yaml --helm-values values.yaml --storageclass azure
cd ..
```

### Prepare other resources for KKP and Flux

```bash
# kubeconfig Secret to be used for Seed cluster configuration
kubectl create secret generic kubeconfig-cluster -n kubermatic --from-file=kubeconfig=`pwd`/kubeone/friendly-easley-kubeconfig --dry-run=client -o yaml | kubectl apply -f -
cat .age.txt | kubectl -n kubermatic create secret generic sops-age --from-file=age.agekey=/dev/stdin --dry-run=client -o yaml | kubectl apply -f -
```

### Update DNS records

At this point, you should manage the DNS records the Kubermatic Kubernetes platform.

See the related [documentation](https://docs.kubermatic.com/kubermatic/master/guides/installation/install_kkp_ce/#create-dns-records).

### Initialize Flux v2

```bash
flux bootstrap github --owner=$GITHUB_OWNER --repository=$GITHUB_REPOSITORY \
  --branch=main --personal=true --path flux/clusters/master
```

Your Kubermatic Kubernetes Platform is ready to use now, look around
all deployed services and custom resources in Kubernetes.

More cheat sheets to follow are summarized in [documentation](https://docs.kubermatic.com/kubermatic/master/installation/start_kkp/cheat_sheets).

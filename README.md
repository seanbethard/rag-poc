# Biker Scum

![Alt Text](https://static.wikia.nocookie.net/wasteland/images/4/4a/WL_ani_115.gif)

On-device, pre-quantum knowledge base with backoff retrieval and ASR support.<br>
Scumbag is a neurosymbolic AI for motorcycle mechanics.<br>
Neurosymbolic AI for Motorcycles (NAM) is an emergent area of research.

## Setup Python environment

### Install Python

```shell
which python
$HOME/.pyenv/shims/python
```

```bash
pyenv install -v 3.8.0
```

### Create virtualenv with project shim

```shell
pyenv version-file
$HOME/git/biker-scum/.python-version
```

```shell
pyenv version
3.8.0 (set by $HOME/git/biker-scum/.python-version)
```

```shell
pyenv local
3.8.0
```

```bash
pipenv install -v 3.8.0
```

### Activate virtualenv

```bash
pipenv shell
```

## Build the application

```bash
bun install
```

### Start the app in development mode (hot-code reloading, error reporting, etc.)

```bash
quasar dev
```

### Lint the files

```bash
bun lint
```

### Format the files

```bash
bun format
```

### Build the app for production

```bash
quasar build
```

## Deploy to Amplify

### Create a new feature

```bash
git checkout -b feature
amplify env checkout bikerscum
amplify pull
amplify env add feature
amplify push
amplify env checkout feature
amplify add function
amplify push
```

### Submit PR and preview for review

```bash
git commit -am 'Feature'
git push -u origin feature
aws amplify create-branch --app-id <app-id> --branch-name feature
aws amplify start-job --app-id <appid> --branch-name feature --job-type RELEASE
```

### Merge to development branch (https://test.bikerscum.ai)

```bash
git checkout biker-scum-dev
git merge feature
git push
```

### Delete feature branch, preview and environment

```bash
git push origin --delete feature
aws amplify delete-branch --app-id <appid> --branch-name feature
amplify env remove feature
```

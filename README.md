![Alt Text](https://static.wikia.nocookie.net/wasteland/images/4/4a/WL_ani_115.gif)

## What is Biker Scum?

_Biker Scum_ is the AI-powered voice assistant for motorcycle mechanics. _Biker Scum_ supports your motorcycle maintenance program with artificial intelligence to accelerate problem diagnosis and repair, improving mean time to repair, first-time fix rates and reducing mean time between failures.

## What is Biker Scum AI?

_Biker Scum_'s knowledge base (`RatBikeDB`) and inference potential. Use your own procedures, technical documents and diagrams to extend _Biker Scum_'s knowledge base for optimal prescriptive guidance. `BikerScumDB` supports on-device ASR, retrieval and neurosymbolic inference on classical computers.

## Why Biker Scum?

* Rising maintenance costs.
* Loss of talent and knowledge in workforce.
* Scarcity of tribal knowledge.
* Prescriptive repair guidance improves maintenance key performance indicators (KPIs).
* Improves first-time fix (FTF) rates.
* Improves mean time to repair (MTTR) rate.
* Reduces mean time between failures (MTBF).

## Make Biker Scum better

## Setup Python environment

### Install Python

```shell
which python
$HOME/.pyenv/shims/python
```

```bash
pyenv install -v 3.8.0
```

### Create virtual environment with project shim

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

### Activate virtual environment

```bash
pipenv shell
```

## Build the application

```bash
bun install
```

### Start the application in development mode

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

### Build the application for production

```bash
quasar build
```

## Deploy the application to Amplify

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

### Submit a pull request for review

```bash
git commit -am 'Feature'
git push -u origin feature
```

### Merge the feature branch into the [development branch](https://test.bikerscum.ai)

```bash
git checkout biker-scum-dev
git merge feature
git push
```

### Delete the feature branch and feature environment

```bash
git push origin --delete feature
amplify env remove feature
```

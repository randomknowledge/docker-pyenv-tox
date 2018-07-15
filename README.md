# Docker image with pyenv and npm

I use this for continuous integration with Gitlab CI, but it should be compatible with any CI/CD solution that supports docker.

## Example .gitlab-ci.yml

```yml
image: "randomknowledge/docker-pyenv-tox"

before_script:
  - eval $(ssh-agent -s)
  - ssh-add <(echo "$SSH_PRIVATE_KEY")

tests:
  script:
  - "tox"
  tags:
  stage: test
  except:
  - tags
  only:
  - develop
  - master
```

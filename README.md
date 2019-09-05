# [noti-in-docker](https://github.com/firepress-org/noti-in-docker)

**noti** in a docker container along a CI (continuous integration).

## Features

- an **everyday build** and on every commit (CI)
- a build from the **sources** (CI)
- a logic of **four docker tags** on the master branch (CI) and logic of **three docker tags** on any other branches (CI)
- few UAT **tests** (CI)
- an automatic push of the **README** to Dockerhub (CI)
- **Slack** notifications when a build succeed (Job 2) (CI)
- a **multi-stage** build (Dockerfile)
- an **alpine** base docker image (Dockerfile)
- a **non-root** user (Dockerfile)
- having this app running as PID 1 under **tiny** (Dockerfile)
- **Labels** (Dockerfile)
- this app is compressed using **UPX** (Dockerfile)
- a **small footprint** docker image's size (Dockerfile)
- `utility.sh` based on [bash-script-template](https://github.com/firepress-org/bash-script-template)
- and probably more, but hey, who is counting?

<br>

## About noti

At **FirePress**, we use noti to keep track of backups, cron, a critical error that could happen in our DevOps set up.

[Noti](https://github.com/variadico/noti/) let you trigger a notification.

Never sit and wait for some long-running process to finish. Noti can alert you when it's done. You can receive messages on your computer or phone.

<br>

## CI configuration & Github Actions

[See README-CI.md](./README-CI.md)

<br>

## Related docker images

[See README-related.md](./README-related.md)

<br>

## Docker hub

Always check on docker hub the most recent build:<br>
https://hub.docker.com/r/devmtl/noti/tags

You should use **this tag format** in production.<br>
`${VERSION} _ ${DATE} _ ${HASH-COMMIT}` 

```
devmtl/noti:3.2.0_2019-09-03_04H01s17_0d571ec
```

These tags are also available to try stuff quickly:

```
devmtl/noti:3.2.0
devmtl/noti:stable
devmtl/noti:latest
```

<br>

# How to use it

This example sends a message to a Slack.

```
IMG_noti="3.2.0_2019-09-03_04H01s17_0d571ec"

docker run --rm \
  --name noti \
  -e NOTI_MESSAGE="${NOTI_MESSAGE}" \
  -e SLACK_CHANNEL="${SLACK_CHANNEL}" \
  -e SLACK_TOKEN_CRON=$(cat ${secret_token_path}) \
  "$IMG_noti" sh -c \
  ' NOTI_SLACK_TOKEN="$SLACK_TOKEN_CRON" \
    NOTI_SLACK_CHANNEL="$SLACK_CHANNEL" \
    noti -k -m "$NOTI_MESSAGE" '
```    

<br>

&nbsp;

<p align="center">
    Brought to you by
</p>

<p align="center">
  <a href="https://firepress.org/">
    <img src="https://user-images.githubusercontent.com/6694151/50166045-2cc53000-02b4-11e9-8f7f-5332089ec331.jpg" width="340px" alt="FirePress" />
  </a>
</p>

<p align="center">
    <a href="https://firepress.org/">FirePress.org</a> |
    <a href="https://play-with-ghost.com/">play-with-ghost</a> |
    <a href="https://github.com/firepress-org/">GitHub</a> |
    <a href="https://twitter.com/askpascalandy">Twitter</a>
    <br /> <br />
</p>

&nbsp;


If you are looking for an alternative to WordPress, [Ghost](https://firepress.org/en/faq/#what-is-ghost) might be the CMS you are looking for. Check out our [hosting plans](https://firepress.org/en).

![ghost-v2-review](https://user-images.githubusercontent.com/6694151/64218253-f144b300-ce8e-11e9-8d75-312a2b6a3160.gif)

<br>

## Contributing

The power of communities pull request and forks means that `1 + 1 = 3`. You can help to make this repo a better one! Here is how:

1. Fork it
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

Check this post for more details: [Contributing to our Github project](https://pascalandy.com/blog/contributing-to-our-github-project/). Also, by contributing you agree to the [Contributor Code of Conduct on GitHub](https://pascalandy.com/blog/contributor-code-of-conduct-on-github/). 

<br>

## License

- This git repo is under the **GNU V3** license. [Find it here](./LICENSE.md).

<br>

## Why all this work?

Our [mission](https://firepress.org/en/our-mission/) is to empower freelancers and small organizations to build an outstanding mobile-first website.

Because we believe your website should speak up in your name, we consider our mission completed once your site has become your impresario.

Find me on Twitter [@askpascalandy](https://twitter.com/askpascalandy).

— The FirePress Team 🔥📰
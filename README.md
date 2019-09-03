# [noti-in-docker](https://github.com/firepress-org/noti-in-docker)

noti in a docker container using CI (continuous integration). It uses best practices: rebuild everyday, multi-stage builds, non-root, upx, labels, alpine, etc

**It features**:

- it builds **everyday** and on every commits
- it builds from the **go sources**
- it uses **multi-stage** build
- it uses **alpine** as final image
- it runs as **non-root**
- the app runs under **tiny**
- it push **four tags** to registry
- it uses **Labels**
- it compress the app with **UPX**
- the docker image's size (uncompressed) is ~~ **13MB**

<br>

## About noti

[Noti](https://github.com/variadico/noti/) let you trigger a notifications.

Never sit and wait for some long-running process to finish. Noti can alert you when it's done. You can receive messages on your computer or phone.

At FirePress we use noti to keep track of backups, cron, critical error that could happen in our DevOps set up.

<br>

## Regarding Github Actions & CI configuration

[See README-CI.md](./README-CI.md)

<br>

## Docker hub

Always check on docker hub the most recent build:<br>
https://hub.docker.com/r/devmtl/noti/tags

You should use **this tag format** `$VERSION_$DATE_$HASH-COMMIT` in production.

```
devmtl/rclone:3.2.0_2019-08-31_10H54s57_23a4829
```

These tags are also available to quickly test stuff:

```
devmtl/rclone:3.2.0
devmtl/rclone:stable
devmtl/rclone:latest
```

<br>


# How to use it

This example is the send messages to a slack channel.

```
IMG_noti="3.2.0_2019-08-31_10H54s57_23a4829"

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

<br>

## Hosting

At FirePress we empower entrepreneurs and small organizations to create their websites on top of [Ghost](https://firepress.org/en/faq/#what-is-ghost).

At the moment, our **pricing** for hosting one Ghost website is $15 (Canadian dollars). This price will be only available for our first 100 new clients, starting May 1st, 2019 🙌. [See our pricing section](https://firepress.org/en/pricing/) for details.

More details [about this annoucement](https://forum.ghost.org/t/host-your-ghost-website-on-firepress/7092/1) on Ghost's forum.

<br>

## Contributing

The power of communities pull request and forks means that `1 + 1 = 3`. You can help to make this repo a better one! Here is how:

1. Fork it
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

Check this post for more details: [Contributing to our Github project](https://pascalandy.com/blog/contributing-to-our-github-project/). Also, by contributing you agree to the [Contributor Code of Conduct on GitHub](https://pascalandy.com/blog/contributor-code-of-conduct-on-github/). It's plain common sense really.

<br>

## License

- This git repo is under the **GNU V3** license. [Find it here](https://github.com/pascalandy/GNU-GENERAL-PUBLIC-LICENSE/blob/master/LICENSE.md).

<br>

## Why all this work?

Our [mission](https://firepress.org/en/our-mission/) is to empower freelancers and small organizations to build an outstanding mobile-first website.

Because we believe your website should speak up in your name, we consider our mission completed once your site has become your impresario.

For more info about the man behind the startup, check out my [now page](https://pascalandy.com/blog/now/). You can also follow me on Twitter [@askpascalandy](https://twitter.com/askpascalandy).

— The FirePress Team 🔥📰
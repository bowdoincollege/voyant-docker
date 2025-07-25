# Voyant Tools in Docker

**This repository is no longer used. In fact, it was never used outside of testing.**

Enable running [Voyant Tools](https://github.com/sgsinclair/Voyant) and [Voyant Server](https://github.com/sgsinclair/VoyantServer) in a docker container in a variety of situations useful in an educational setting.

The goal is to enable:

1. (Default) Open for uploads and exploration with transient data. E.g. for classroom use where the data is removed at the end of a session, course, or perhaps never.

2. With a preconfigured (read-only) set of corpora. E.g. for publication

## Using Custom Voyant Tools or Voyant Server Build

The default Dockerfile uses the latest pre-built [VoyantServer bundle](https://github.com/sgsinclair/VoyantServer) from the GitHub distribution running under Tomcat with an ngnix font-end proxy (for SSL). The tools are downloaded at container build time, extracted, and put into place for later execution. The `VoyantServer.jar` (which includes the Jetty servlet engine) is *not* used.

I have built versions of the container by simply substituting the `wget` download URL where the Voyant Server archive is downloaded from with a COPY command. As long as the `.zip` file has the right contents, the `VoyantServer.jar` and web application `_app` directories, things should work.

Alternatively, if your _release_ were web-accessible, you could change the URL to your custom package.

## Temp directories

Voyant Tools puts all the uploaded corpora and derivative data into Java (Jetty) temporary directories. This seems a little odd to me when thinking about persisting corpus data across launches. To resolve that, there's a little bit of a dance in the `Dockerfile` to symbolic link the actual data directories needed from the `/data` directory. `/data` is intended to be mounted as a VOLUME in Docker terms and contain your persistent data files (corpora and resources).

## Alternate Servlet Container (Jetty)

The preferred method of running a Voyant Tools server appears to be with the VoyantServer built-in Jetty servlet engine from the Eclipse foundation. The [VoyantServer](https://github.com/sgsinclair/VoyantServer) project implements this method, but it is not used as the default for this project. Look in the `voyant-jetty` subdirectory for an example of that implementation.

Why Tomcat? The 'hosted version' of [Voyant Tools](http://voyant-tools.org) uses Tomcat and nginx as noted in [this GitHub issue](https://github.com/sgsinclair/VoyantServer/issues/24) about path traversal problems with Jetty. This [issue](https://github.com/sgsinclair/VoyantServer/issues/17) shows their ngnix configuration for SSL. So, given the live, running, hosted version uses this configuration, it seems the most robustly tested option.

## Tomcat Configuration

The Tomcat (Catalina) configuration *ignores the `server-settings.txt` file*. That's because when using tomcat we are running the web application directly and not using the `VoyantServer.jar` wrapper. Thus you need to configure things using `CATALINA_OPTS`. When using `docker-compose.yaml` this looks like:

```
    environment:
        # Don't allow uploads, though hoses whole server
        CATALINA_OPTS: -Dorg.voyanttools.server.allowinput=false 

        # Show specific corupuses on 'open' menu
       CATALINA_OPTS: -Dorg.voyanttools.voyant.openmenu=shakespeare:ShakespearePlays
```

## Outstanding Questions

1. How can I disable uploads but still have usable corpuses? `allow_input` seems to disable the whole interface, not just the uploading portions as expected.
2. How can I disable uploads but still show 'open' menu?
3. How can I name a corpus
4. How can I delete a corpus
5. Can I set metadata on a corpus (e.g. flag it as transient or permanent)
6. What is the process for creating corpus and then exporting and moving it to a 'permanent' server.
7. Should there just be one 'server' per corpus, and then have a front-end dispatch among them?
8. What is the purpose of `hasNoAllowInputText (no-allow-input-text)` and `hasCorpusCreatorText (corpus-creator-text)` and where do those files go?
9. Why does Voyant use 'tmpdir' How does data persist in this situation!? It even overwrites any command line set tmpdir which is where I want the jetty temp files to go. My corpora should be in a persistent location.


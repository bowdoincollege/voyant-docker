# Voyant Tools in Docker

Enable running Voyant Tools in a docker container in a variety of situations useful in an educational setting.

1. Default: Open for uploads and exploration with transient data. E.g. for classroom use where the data is removed at the end of a session, course, or perhaps never.

2. With a preconfigured (read-only) set of corpora. E.g. for publication

## Which version of Voyant Tools

The preferred method of running a Voyant Tools server appears to be with the VoyantServer built-in Jetty servlet engine from the Eclipse foundation. The [VoyantServer]() project implements this and this project encapsulates that process into a docker container.

Voyant Tools can be run as a web application within the Tomcat container, the `voyant-tomcat` subdirectory contains this alternate container implementation.

## Options

1. docker container using tomcat
    a.  using 'latest release' from github
    b.  using built from sources

2. docker container using VoyantServer.jar (with built-in jetty)

## Configuration

in docker-compose set CATALINA_OPTS:

```
    environment:
        # Don't allow uploads, though hoses whole server
        CATALINA_OPTS: -Dorg.voyanttools.server.allowinput=false 

        # Show specific corupuses on 'open' menu
       CATALINA_OPTS: -DDorg.voyanttools.voyant.openmenu=shakespeare:ShakespearePlays
```

## Questions

1. How can I disable uploads but still have usable corpuses?
2. How can I disable uploads but still show 'open' menu
3. How can I name a corpus
4. How can I delete a corpus
5. Can I set metadata on a corpus (e.g. flag it as transient or permanent)
6. What is the process for creating corpus and then exporting and moving it to a 'permanent' server.
7. Should there just be one 'server' per corpus, and then have a front-end dispatch among them?
8. What is the purpose of `hasNoAllowInputText (no-allow-input-text)` and `hasCorpusCreatorText (corpus-creator-text)` and where do those files go?
9. Why does Voyant use 'tmpdir' How does data persist in this situation!? It even overwrites any command line set tmpdir which is where I want the jetty temp files to go. My corpora should be in a persistent location.

### Directories

Data: 


## Build

```
docker build . -t voyant:latest -t voyant:2.4-M17
```


## Run

```
docker run -v /Users/houser/tmp/data:/data --name voyant -p 8080:8080 voyant:latest
```


# This option defines which corpora appear in the drop-down menu when the user opens an
# existing corpus. If this is commented out or blank then the default value is used
# (currently the Austen and Shakespeare corpora). Corpora are defined using a special
# syntax: corpusID:label and multiple corpora are separated by semi-colon. For instance,
# this would be the default:
# open_menu = shakespeare:Shakespeare's Plays;austen:Austen's Novels

    openMenu: System.getProperty("org.voyanttools.voyant.openmenu")

File exists: true or false
hasCorpusCreatorText: org.voyanttools.voyant.Trombone.hasVoyantServerResource("corpus-creator-text")

File Exists: true or false
hasNoAllowInputText: org.voyanttools.voyant.Trombone.hasVoyantServerResource("no-allow-input-text") 


# This allows you to prevent Voyant from accepting any further input, in other words no new
# documents can be added. That doesn't necessarily mean no new corpora can be created, there
# may be a new corpus based on a subset of an existing corpus. The default value is true
# (to allow new input), set this to false to prevent new input from being added.

    allowInput: System.getProperty("org.voyanttools.server.allowinput")
        true or false

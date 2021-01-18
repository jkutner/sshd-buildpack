# SSH Server Buildpack

![Version](https://img.shields.io/badge/dynamic/json?url=https://cnb-registry-api.herokuapp.com/api/v1/buildpacks/jkutner/ngrok&label=Version&query=$.latest.version)

This is a [Cloud Native Buildpack](https://buildpacks.io) that configures and runs `sshd` inside of a container.

## Usage

The buildpack automatically generates a host key when you run a build:

```
$ pack build --buildpack jkutner/sshd myapp
```

You can customize the SSH configuration by creating a `.ssh` directory in your application, and adding files like:

* `authorized_keys`
* `sshd_config`

The buildpack will merge these with the default configuration.



## Example

If I want to add my own public key to the SSH server's authorized_keys and restrict password authentication, I might run:

```
$ mkdir .ssh
$ ssh-keygen -f .ssh/id_rsa -t rsa -N ''
$ cat .ssh/id_rsa.pub > .ssh/authorized_keys
$ echo "PasswordAuthentication no" > .ssh/sshd_config
$ pack build --buildpack jkutner/sshd myapp
```

Then I can start my container

```
$ docker run -it -p 2222:2222 myapp
```

And in another terminal I can run:

```
$ ssh -p 2222 -i .ssh/id_rsa myuser@localhost
```

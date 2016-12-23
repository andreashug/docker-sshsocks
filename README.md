# docker-sshsocks

Minimalistic image with SSH server configured as socks proxy.

Sometimes you need to change the IP of a domain but don't want to touch `/etc/hosts`. In this case, you can start this image with an added host, create a tunnel with SSH and configure your browser to use the container as socks proxy.

## Start Image

### One-liner for copy-paste

```
docker run -d -p 127.0.0.1:2222:2222 --security-opt no-new-privileges --cap-drop ALL -v ${HOME}/.ssh/id_rsa.pub:/proxy/authorized_keys:ro --add-host example.com:127.0.0.1 --name sshsocks sshsocks
```

### Options Explained

Bind to local IP and port 2222
```
-p 127.0.0.1:2222:2222
```

Drop capabilities and prohibit gaining new privileges
```
--security-opt no-new-privileges
--cap-drop ALL
```

Mount your public key for authentication (read-only)
```
-v ${HOME}/.ssh/id_rsa.pub:/proxy/authorized_keys:ro
```

Add one or multiple hosts with the IP you want them to be resolved to.
```
--add-host example.com:127.0.0.1
```



## Create SSH Tunnel

```
ssh -p 2222 -N -D 8282 proxy@localhost
```
If you connect to different containers and virtual machines on localhost with SSH, you might run into a warning that the remote host identification has changed. To avoid this, you can disable host key checking and prevent that the host key is stored. Be aware of the security issues that might come with that!

```
ssh -p 2222 -N -D 8282 proxy@localhost -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
```

## Configure your Browser

You can either edit the proxy settings in your browser directly or use a plugin. Be sure to mark it as SOCKS proxy and let the proxy resolve the host name if there is an option for that.
```
127.0.0.1:8282
```
### curl
```
curl --socks5-hostname 127.0.0.1:8282 https://example.com
```

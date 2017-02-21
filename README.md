Git New Task
------------

This script will create a new branch with the *issue* id on your repository and change from **Stage: Analysis** to **Stage: In Progress**

How to use
----------

If you want to use this script you have to set the environment variables bellow on `~/.bashrc` (or another file as your choice):
```sh
export GITHUB_TOKEN=tokenValue
#OR
export GITHUB_USER=username
export GITHUB_PASSWORD=userpass
```

Usage:

```sh
cd /path/your-project
g-new-task issueID

```

```sh
    --help, -h    Script helper
```

Install
-------

To install into your machine run the commands bellow:

```sh
curl -sL https://raw.githubusercontent.com/euclecio/g-new-task/master/g-new-task.sh -o /usr/local/bin/g-new-task
chmod a+x /usr/local/bin/g-new-task
```
If it didn't work, try run it with `sudo`

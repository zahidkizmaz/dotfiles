# ZSH Config

### How to set ssh-agent for each session
```shell
# SSH agent setup
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
if [ "$(ssh-add -l)" = "The agent has no identities." ]; then
  ssh-add ~/.ssh/my-private-key >/dev/null 2>&1
fi
```

# Mailslurp

*Mailslurp* is a frontend slurper for [Peril](https://github.com/rackerlabs/peril)
that turns incoming :envelope: into support incidents. It uses
[Mailgun](https://mailgun.com/).

## Hacking

To hack on Mailslurp:

```bash
cd ${PROJECTS_HOME}
git clone git@github.com:rackerlabs/mailslurp.git
cd mailslurp

# Install dependencies.
bundle install

# Set up your configuration.
cp mailslurp.yml.example mailslurp.yml
${EDITOR} mailslurp.yml
cp unicorn.rb.example unicorn.example
${EDITOR} unicorn.rb # Optional

# To register with Mailgun:
#
# rake mailgun:register

# Start it up. It'll listen on http://localhost:8080/ by default.
# Logs go to unicorn.out and unicorn.err.
unicorn
```

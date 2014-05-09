# Mailslurp

*Mailslurp* is a frontend slurper for [Peril](https://github.com/rackerlabs/peril)
that turns incoming :envelope: into support incidents. It uses
[Mailgun](https://mailgun.com/).

## Getting Started

After you clone:

```bash
# Get dependencies
bundle install

# Set up your configuration
cp mailslurp.yml.example mailslurp.yml
${EDITOR} mailslurp.yml

# Register with Mailgun
rake mailgun:register

# Start it up
rackup -p 4567
```
# Exec module

The `exec` module is responsible for running arbitrary executables as an external data source in terraform.

The module uses the `run` wrapper to simplify the act of writing a "check":
- terraform passes in a JSON payload through stdin. This is clunky to handle in most scripts, so we load the data as environment variables instead.
- terraform treats non-zero exits as terminal conditions. It is more flexible to always return successfully and wrap the result in the returned data.
- terraform expects a JSON object back. If our check returns a non-zero exits, return the last line as the "error"


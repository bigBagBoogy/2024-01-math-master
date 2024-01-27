# to activate:
source <venv-dir>/bin/activate

# to deactivate:
deactivate

### This python based Halmos stuff should run in it's own shell. 
You should activate and deactivate this, to avoid conflicts with other future projects.

To run the check_transfer test using Halmos CLI, you can use the following command:

```halmos --function check_transfer```

optionally add the flag:  `--solver-timeout-assertion <timeout_value>`  when error:
`counterexample-unknown` pops up. This is caused by a timeout in the assertion solver

`--solver-timeout-assertion 10000`   is 10 seconds

If increasing the timeout does not resolve the issue, you can try disabling the timeout entirely by setting it to `0`. This allows the solver to take as much time as needed to find a solution. However, be cautious when disabling timeouts, as it can lead to long-running processes if the solver struggles to find a solution.

##  adding `-vvv` also works with Halmos to "up" the verbosity of the stack trace!
Sets boolean to enable/disable debugging. Vedeu's default setting is
for debugging to be disabled. Using `debug!` or setting `debug` to
true will enable debugging.

Enabling debugging will:
- Enable `Vedeu::Logging::Timer` meaning various timing
  information is output to the log file.
- Produce a full a backtrace to STDOUT and the log file upon
  unrecoverable error or unhandled exception.

    Vedeu.configure do
      debug!
      # ...
    end

    Vedeu.configure do
      debug false
      # ...
    end
